use std::{
	error, fmt,
	io::{Error, Read},
};

use num_traits::FromPrimitive;

use crate::{
	reader::SMFReader,
	util::{latin1_decode, read_amount, read_byte},
};

/// An error that can occur parsing a meta command
#[derive(Debug)]
pub enum MetaError {
	InvalidCommand(u8),
	OtherErr(&'static str),
	Error(Error),
}

impl From<Error> for MetaError {
	fn from(err: Error) -> MetaError {
		MetaError::Error(err)
	}
}

impl error::Error for MetaError {
	fn description(&self) -> &str {
		match *self {
			MetaError::InvalidCommand(_) => "Invalid meta command",
			MetaError::OtherErr(_) => "A general midi error has occured",
			// TODO: find a way to remove depreciated `description` method
			MetaError::Error(ref other) => {
				eprintln!("Unknown Error: 'MidiError::Error: {}'", other);
				"An Unknown Error occured see stderr log for details"
			},
		}
	}

	fn cause(&self) -> Option<&dyn error::Error> {
		match *self {
			MetaError::Error(ref err) => Some(err as &dyn error::Error),
			_ => None,
		}
	}
}

impl fmt::Display for MetaError {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		match *self {
			MetaError::InvalidCommand(ref c) => write!(f, "Invalid Meta command: {}", c),
			MetaError::OtherErr(ref s) => write!(f, "Meta Error: {}", s),
			MetaError::Error(ref e) => write!(f, "{}", e),
		}
	}
}

/// A MIDI meta command.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, FromPrimitive)]
pub enum MetaCommand {
	/// This optional event, which must occur at the beginning of a track, before any nonzero
	/// delta-times, and before any transmittable MIDI events, specifies the number of a sequence.
	/// In a format 2 MIDI file, it is used to identify each "pattern" so that a "song" sequence
	/// using the Cue message to refer to the patterns. If the ID numbers are omitted, the
	/// sequences' locations in order in the file are used as defaults. In a format 0 or 1 MIDI
	/// file, which only contain one sequence, this number should be contained in the first (or
	/// only) track. If transfer of several multitrack sequences is required, this must be done as a
	/// group of format 1 files, each with a different sequence number.
	SequenceNumber = 0x00,
	TextEvent = 0x01,
	CopyrightNotice = 0x02,
	SequenceOrTrackName = 0x03,
	InstrumentName = 0x04,
	LyricText = 0x05,
	MarkerText = 0x06,
	CuePoint = 0x07,
	MIDIChannelPrefixAssignment = 0x20,
	MIDIPortPrefixAssignment = 0x21,
	EndOfTrack = 0x2F,
	TempoSetting = 0x51,
	SMPTEOffset = 0x54,
	TimeSignature = 0x58,
	KeySignature = 0x59,
	SequencerSpecificEvent = 0x7F,
	Unknown,
}

/// Meta event building and parsing.  See
/// http://cs.fit.edu/~ryan/cse4051/projects/midi/midi.html#meta_event
/// for a description of the various meta events and their formats
#[derive(Debug)]
pub struct MetaEvent {
	pub command: MetaCommand,
	pub length: u64,
	pub data: Vec<u8>,
}

impl Clone for MetaEvent {
	fn clone(&self) -> MetaEvent {
		MetaEvent {
			command: self.command,
			length: self.length,
			data: self.data.clone(),
		}
	}
}

impl fmt::Display for MetaEvent {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "Meta Event: {}", match self.command {
			MetaCommand::SequenceNumber =>
				format!(
					"Sequence Number: {}",
					((self.data[0] as u16) << 8) | self.data[1] as u16
				),
			MetaCommand::TextEvent => {
				format!("Text Event. Len: {} Text: {}", self.length, latin1_decode(&self.data))
			},
			MetaCommand::CopyrightNotice => {
				format!("Copyright Notice: {}", latin1_decode(&self.data))
			},
			MetaCommand::SequenceOrTrackName => {
				format!(
					"Sequence/Track Name, length: {}, name: {}",
					self.length,
					latin1_decode(&self.data)
				)
			},
			MetaCommand::InstrumentName => {
				format!("InstrumentName: {}", latin1_decode(&self.data))
			},
			MetaCommand::LyricText => {
				format!("LyricText: {}", latin1_decode(&self.data))
			},
			MetaCommand::MarkerText => {
				format!("MarkerText: {}", latin1_decode(&self.data))
			},
			MetaCommand::CuePoint => format!("CuePoint: {}", latin1_decode(&self.data)),
			MetaCommand::MIDIChannelPrefixAssignment =>
				format!("MIDI Channel Prefix Assignment, channel: {}", self.data[0] + 1),
			MetaCommand::MIDIPortPrefixAssignment => format!("MIDI Port Prefix Assignment, port: {}", self.data[0]),
			MetaCommand::EndOfTrack => "End Of Track".to_string(),
			MetaCommand::TempoSetting => format!("Set Tempo, microseconds/quarter note: {}", self.data_as_u64(3)),
			MetaCommand::SMPTEOffset => "SMPTEOffset".to_string(),
			MetaCommand::TimeSignature =>
				format!(
					"Time Signature: {}/{}, {} ticks/metronome click, {} 32nd notes/quarter note",
					self.data[0],
					2usize.pow(self.data[1] as u32),
					self.data[2],
					self.data[3]
				),
			MetaCommand::KeySignature =>
				format!(
					"Key Signature, {} sharps/flats, {}",
					self.data[0] as i8,
					match self.data[1] {
						0 => "Major",
						1 => "Minor",
						_ => "Invalid Signature",
					}
				),
			MetaCommand::SequencerSpecificEvent => "SequencerSpecificEvent".to_string(),
			MetaCommand::Unknown => format!("Unknown, length: {}", self.data.len()),
		})
	}
}

impl MetaEvent {
	/// Turn `bytes` bytes of the data of this event into a u64
	pub fn data_as_u64(&self, bytes: usize) -> u64 {
		let mut res = 0;
		for i in 0..bytes {
			res <<= 8;
			res |= self.data[i] as u64;
		}
		res
	}

	/// Extract the next meta event from a reader
	pub fn next_event(reader: &mut dyn Read) -> Result<MetaEvent, MetaError> {
		let command = match MetaCommand::from_u8(read_byte(reader)?) {
			Some(c) => c,
			None => MetaCommand::Unknown,
		};
		let len = match SMFReader::read_vtime(reader) {
			Ok(t) => t,
			Err(_) => {
				return Err(MetaError::OtherErr("Couldn't read time for meta command"));
			},
		};
		let mut data = Vec::new();
		read_amount(reader, &mut data, len as usize)?;
		Ok(MetaEvent {
			command,
			length: len,
			data,
		})
	}

	// util functions for event constructors
	fn u16_to_vec(val: u16) -> Vec<u8> {
		vec![((val >> 8) & 0xFF) as u8, (val & 0xFF) as u8]
	}

	fn u24_to_vec(val: u32) -> Vec<u8> {
		assert!(val <= 2u32.pow(24));
		vec![
			((val >> 16) & 0xFF) as u8,
			((val >> 8) & 0xFF) as u8,
			(val & 0xFF) as u8,
		]
	}

	// event constructors below

	/// Create a sequence number meta event
	pub fn sequence_number(sequence_number: u16) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::SequenceNumber,
			length: 0x02,
			data: MetaEvent::u16_to_vec(sequence_number),
		}
	}

	/// Create a text meta event
	pub fn text_event(text: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::TextEvent,
			length: text.len() as u64,
			data: text.into_bytes(),
		}
	}

	/// Create a copyright notice meta event
	pub fn copyright_notice(copyright: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::CopyrightNotice,
			length: copyright.len() as u64,
			data: copyright.into_bytes(),
		}
	}

	/// Create a name meta event
	pub fn sequence_or_track_name(name: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::SequenceOrTrackName,
			length: name.len() as u64,
			data: name.into_bytes(),
		}
	}

	/// Create an instrument name meta event
	pub fn instrument_name(name: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::InstrumentName,
			length: name.len() as u64,
			data: name.into_bytes(),
		}
	}

	/// Create a lyric text meta event
	pub fn lyric_text(text: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::LyricText,
			length: text.len() as u64,
			data: text.into_bytes(),
		}
	}

	/// Create a marker text meta event
	pub fn marker_text(text: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::MarkerText,
			length: text.len() as u64,
			data: text.into_bytes(),
		}
	}

	/// Create a cue point meta event
	pub fn cue_point(text: String) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::CuePoint,
			length: text.len() as u64,
			data: text.into_bytes(),
		}
	}

	/// Create a midi channel prefix assignment meta event
	pub fn midichannel_prefix_assignment(channel: u8) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::MIDIChannelPrefixAssignment,
			length: 1,
			data: vec![channel],
		}
	}

	/// Create a midi port prefix assignment meta event
	pub fn midiport_prefix_assignment(port: u8) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::MIDIPortPrefixAssignment,
			length: 1,
			data: vec![port],
		}
	}

	/// Create an end of track meta event
	pub fn end_of_track() -> MetaEvent {
		MetaEvent {
			command: MetaCommand::EndOfTrack,
			length: 0,
			data: vec![],
		}
	}

	/// Create an event to set track tempo.  This is stored
	/// as a 24-bit value.  This method will fail an assertion if
	/// the supplied tempo is greater than 2^24.
	pub fn tempo_setting(tempo: u32) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::TempoSetting,
			length: 3,
			data: MetaEvent::u24_to_vec(tempo),
		}
	}

	/// Create an smpte offset meta event
	pub fn smpte_offset(hours: u8, minutes: u8, seconds: u8, frames: u8, fractional: u8) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::SMPTEOffset,
			length: 5,
			data: vec![hours, minutes, seconds, frames, fractional],
		}
	}

	/// Creates a time signature meta event
	///
	/// ## Arguments
	/// * `numerator` - the numerator of the time signature
	/// * `denominator` - the denominator of the time signature
	///
	/// ## Examples
	///
	/// ```rust
	/// use midi_utils::MetaEvent;
	///
	/// // create a time signature event for 4/4 time
	/// let event = MetaEvent::time_signature(4, 4);
	///
	/// // create a time signature event for 3/4 time
	/// let event = MetaEvent::time_signature(3, 4);
	/// ```
	pub fn time_signature(numerator: u8, mut denominator: u8) -> MetaEvent {
		// take the log base 2 of the denominator
		let mut log2_denominator = 0;
		while denominator > 1 {
			denominator >>= 1;
			log2_denominator += 1;
		}
		denominator = log2_denominator;

		MetaEvent {
			command: MetaCommand::TimeSignature,
			length: 4,
			data: vec![
				numerator,
				// this value must be the log2() of the denominator, such that
				// time_signature = numerator / 2^denominator
				denominator,
				// clocks_per_tick:
				24,
				// num_32nd_notes_per_24_clocks:
				8,
			],
		}
	}

	/// Creates an advanced time signature meta event
	///
	/// ## Arguments
	/// * `numerator` - the numerator of the time signature
	/// * `denominator` - the denominator of the time signature
	/// * `clocks_per_tick` - the number of MIDI clocks per tick
	/// * `num_32nd_notes_per_24_midi_clocks` - the number of 32nd notes per 24 MIDI clocks
	///
	/// ## Notes
	/// It is standard (and recommended) to set 24 MIDI clocks per tick, where the tick is the
	/// quarter note. Additionally, it is standard to set 8 32nd notes per 24 MIDI clocks. (equaling
	/// a quarter note).
	///
	/// As these are the standardized values, the method defaults to these values, however, they can
	/// be overridden.
	///
	/// ## Examples
	///
	/// ```rust
	/// use midi_utils::MetaEvent;
	///
	/// // create a time signature event for 4/4 time
	/// let event = MetaEvent::time_signature_adv(4, 4, 24, 8);
	/// ```
	pub fn time_signature_adv(
		numerator: u8, mut denominator: u8, clocks_per_tick: u8, num_32nd_notes_per_24_clocks: u8,
	) -> MetaEvent {
		// take the log base 2 of the denominator
		let mut log2_denominator = 0;
		while denominator > 1 {
			denominator >>= 1;
			log2_denominator += 1;
		}
		denominator = log2_denominator;

		MetaEvent {
			command: MetaCommand::TimeSignature,
			length: 4,
			data: vec![
				numerator,
				// this value must be the log2() of the denominator, such that
				// time_signature = numerator / 2^denominator
				denominator,
				clocks_per_tick,
				num_32nd_notes_per_24_clocks,
			],
		}
	}

	///  Create a Key Signature event
	///  expressed as the number of sharps or flats, and a major/minor flag.

	/// `sharps_flats` of 0 represents a key of C, negative numbers represent
	/// 'flats', while positive numbers represent 'sharps'.
	pub fn key_signature(sharps_flats: u8, major_minor: u8) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::KeySignature,
			length: 2,
			data: vec![sharps_flats, major_minor],
		}
	}

	/// This is the MIDI-file equivalent of the System Exclusive Message.
	/// sequencer-specific directives can be incorporated into a
	/// MIDI file using this event.
	pub fn sequencer_specific_event(data: Vec<u8>) -> MetaEvent {
		MetaEvent {
			command: MetaCommand::SequencerSpecificEvent,
			length: data.len() as u64,
			data,
		}
	}
}

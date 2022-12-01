use std::path::Path;

use crate::{Event, MetaCommand, MetaEvent, MidiMessage, SMFBuilder, SMFWriter, TrackEvent};

/// Struct containing data to define a single MIDI event.
#[allow(dead_code)]
struct MidiEvent {
	/// which MIDI note to play, represtned as an `u8` (0-127)
	note: u8,
	/// Velocity of the note.
	velocity: u8,
	/// The MIDI channel to use for this event.
	channel: u8,
	/// length of the note in ticks.
	length: u32,
}
#[allow(dead_code)]
struct MidiBuf {}

pub fn write_midi_from_buf() {
	let note_on = MidiMessage::note_on(69, 100, 0);
	let note_off = MidiMessage::note_off(69, 100, 0);

	let mut builder = SMFBuilder::new();

	builder.add_track();

	builder.add_event(0, TrackEvent {
		vtime: 0,
		event: Event::Midi(note_on),
	});

	builder.add_event(0, TrackEvent {
		vtime: 10,
		event: Event::Midi(note_off),
	});

	builder.add_event(0, TrackEvent {
		vtime: 10,
		event: Event::Meta(MetaEvent {
			command: MetaCommand::EndOfTrack,
			length: 0,
			data: Vec::new(),
		}),
	});

	let smf = builder.result();

	let writer = SMFWriter::from_smf(smf);

	writer.write_to_file(Path::new("test.mid")).unwrap();
}

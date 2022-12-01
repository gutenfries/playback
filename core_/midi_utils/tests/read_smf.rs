extern crate midi_utils;
use std::path::Path;

use midi_utils::{SMFError, SMF};

fn read_smf(path: String) -> Result<SMF, SMFError> {
	println!("Reading: {}", path);
	match SMF::from_file(Path::new(&path[..])) {
		Ok(smf) => {
			println!("format: {}", smf.format);
			println!("tracks: {}", smf.tracks.len());
			println!("division: {}", smf.division);
			let mut tnum = 1;
			for track in smf.tracks.iter() {
				let mut time: u64 = 0;
				println!("\n{}: {}\nevents:", tnum, track);
				tnum += 1;
				for event in track.events.iter() {
					println!("  {}", event.fmt_with_time_offset(time));
					time += event.vtime;
				}
			}
			Ok(smf)
		},

		Err(e) => {
			match &e {
				SMFError::MidiError(e) => {
					println!("Midi Error: {}", e);
				},
				SMFError::Error(e) => {
					println!("IO Error: {}", e);
				},
				SMFError::InvalidSMFFile(e) => {
					println!("{}", *e);
				},
				SMFError::MetaError(_) => {
					println!("Meta Error");
				},
			};
			Err(e)
		},
	}
}

#[test]
fn read_invalid_smf() {
	let invalid = read_smf("invalid_path.mid".to_string());
	assert!(invalid.is_err());
}

#[test]
fn read_valid_smf() {
	let result = read_smf("./tests/morse_code_a.mid".to_string());
	assert!(result.is_ok());
}

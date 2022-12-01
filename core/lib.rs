/// ! playback
extern crate image_utils;
extern crate midi_utils;

use image::imageops;
// use image_utils::ImageBufRgba;

pub fn main() {
	// load image from file
	let img = image::open("./core/resources/README/image1.jpg").unwrap();
	// put in buffer
	let mut imgbuf: image_utils::ImagePixelBuf = image::ImageBuffer::new(img.width(), img.height());
	// copy image into buffer
	imageops::overlay(&mut imgbuf, &img, 0, 0);
	// destroy `img` now that it is in the buffer
	drop(img);
	//
	let img = image_utils::segment_image_avg_col(imgbuf);
	// write to disk
	img.save("test.png").unwrap();
	// midi_utils::mom::write_midi_from_buf();
}

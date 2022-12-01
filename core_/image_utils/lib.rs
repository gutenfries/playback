pub mod best_match;

/// An `image::ImagePixelBuffer` of `image::Rgba` (Color) pixels.
pub type ImagePixelBuf = image::ImageBuffer<image::Rgba<u8>, std::vec::Vec<u8>>;

/// Takes an `&ImagePixelBuf` and calculates the average color of the buffer, represented as an
/// `u8`.
fn calculate_contrast_from_buf(imgbuf: &ImagePixelBuf) -> u8 {
	let (mut pixel_buf_r, mut pixel_buf_g, mut pixel_buf_a): (Vec<usize>, Vec<usize>, Vec<usize>) =
		(Vec::new(), Vec::new(), Vec::new());

	for (_x, _y, pixel) in imgbuf.enumerate_pixels() {
		pixel_buf_r.push(pixel[0] as usize);
		pixel_buf_g.push(pixel[1] as usize);
		pixel_buf_a.push(pixel[2] as usize);
	}

	// average the pixel values
	let pixel_buf_r_avg = pixel_buf_r.iter().sum::<usize>() / pixel_buf_r.len();
	let pixel_buf_g_avg = pixel_buf_g.iter().sum::<usize>() / pixel_buf_g.len();
	let pixel_buf_a_avg = pixel_buf_a.iter().sum::<usize>() / pixel_buf_a.len();

	// average the averages
	let imgbuf_avg: usize = (pixel_buf_r_avg + pixel_buf_g_avg + pixel_buf_a_avg) / 3;

	assert!(imgbuf_avg <= 255); // prevent a stack overflow
	print!("{} ", imgbuf_avg as u8);
	imgbuf_avg as u8
}

// Segments an image from an ```ImagePixelBuf``` using the calculated average color of the buffer.
//
// ## Notes:
// This method of segmentation is not optimized for images that are very saturated, but
// for sheet music, the existing saturation of the image is generally quite minimal.
// A visual example of this method is shown below:
// ```rust
// use super::{sement_image_avg_col, ImagePixelBuf};
// // image vec before `avg_col` segmentation
// let imgdata: Vec<u8> = vec![];
// let imgbuf: ImagePixelBuf = ImageBuffer::new()
// ```

/// ...
pub fn segment_image_avg_col(mut imgbuf: ImagePixelBuf) -> ImagePixelBuf {
	let imagebuf_contrast = calculate_contrast_from_buf(&imgbuf);

	// Iterate over the coordinates and pixels of the image and sharpen using the average value of the
	// image buffer
	for (_x, _y, pixel) in imgbuf.enumerate_pixels_mut() {
		if ((pixel[0] as u32 + pixel[1] as u32 + pixel[2] as u32) / 3) as u8 >= imagebuf_contrast {
			*pixel = image::Rgba([255, 255, 255, 255]);
		} else {
			*pixel = image::Rgba([0, 0, 0, 255]);
		}
	}

	// print!("finished segmenting image");

	imgbuf
}

#[derive(Clone, Debug, Eq, PartialEq, Default)]
pub struct Flags {
	/// Vector of CLI arguments - these are user script arguments, all Deno
	/// specific flags are removed.
	pub argv: Vec<String>,
	pub unstable: bool,
	pub version: bool,
	pub no_clear_screen: bool,
	pub color: String,
	pub log_level: String,
}

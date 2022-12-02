use once_cell::sync::Lazy;

pub static LONG_VERSION: Lazy<String> = Lazy::new(|| -> String {
	let origin: &'static str = option_env!("GIT_BRANCH").unwrap_or("UNKNOWN ORIGIN");
	format!(
		"{} {}{}\n",
		crate::version::cargo_ver(),
		if crate::version::is_canary() {
			"canary"
		} else {
			"stable"
		},
		if crate::version::is_canary() {
			format!("+{}", &origin)
		} else {
			"".to_string()
		},
	)
});

pub static SHORT_VERSION: Lazy<String> =
	Lazy::new(|| crate::version::cargo_ver().split('+').next().unwrap().to_string());

pub fn cargo_ver() -> String {
	let semver = env!("CARGO_PKG_VERSION");
	let hash: &'static str = option_env!("GIT_COMMIT_HASH").unwrap_or("UNKNOWN GIT HASH");
	option_env!("PLAYBACK_CLI_CANARY").map_or(semver.to_string(), |_| format!("{}+{}", semver, hash))
}

pub fn is_canary() -> bool {
	option_env!("PLAYBACK_CLI_CANARY").is_some()
}

pub fn release_version_or_canary_commit_hash() -> &'static str {
	if is_canary() {
		"SHORT_VERSION"
	} else {
		env!("CARGO_PKG_VERSION")
	}
}

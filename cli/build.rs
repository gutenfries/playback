use std::ffi::OsStr;

pub fn main() {
	fn git<T>(args: Vec<T>) -> String
	where T: AsRef<OsStr> {
		let output = std::process::Command::new("git").args(args).output().unwrap();
		String::from_utf8(output.stdout).unwrap()
	}

	fn git_commit_hash() -> String {
		git(vec!["rev-parse", "--short", "HEAD"])
	}

	fn git_commit_date() -> String {
		git(vec!["show", "-s", "--format=%ci"])
	}

	fn git_branch() -> String {
		git(vec!["rev-parse", "--abbrev-ref", "HEAD"])
	}

	#[allow(clippy::print_literal)]
	{
		// ignore my trash code...
		println!("cargo:rustc-env=PLAYBACK_CLI_CANARY={}", true,);
	}

	println!("cargo:rustc-env=GIT_COMMIT_HASH={}", &git_commit_hash()[0..7]);
	println!("cargo:rerun-if-env-changed=GIT_COMMIT_HASH");
	println!("cargo:rustc-env=GIT_COMMIT_DATE={}", &git_commit_date()[0..10]);
	println!("cargo:rerun-if-env-changed=GIT_COMMIT_DATE");
	println!("cargo:rustc-env=GIT_BRANCH={}", &git_branch());
	println!("cargo:rerun-if-env-changed=GIT_BRANCH");
}

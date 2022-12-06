#! /bin/bash

function clang_format() {
	echo "finding files..."
	find . -type f \( \
		-name "*.c" -o \
		-name "*.cpp" -o \
		-name "*.cc" -o \
		-name "*.h" -o \
		-name "*.hpp" -o \
		-name "*.hh" -o \
		-name "*.m" -o \
		-name "*.mm" \
		\) \
		-not -path "*/target/*" \
		-not -path "*/node_modules/*" \
		-not -path "*/build/*" \
		-not -path "*/ephemeral/*" \
		-not -path "*/ios/*" \
		-not -path "*/macos/*" \
		-not -path "*/linux/*" \
		-not -path "*/windows/*" \
		-not -path "*/android/*" \
		-not -path "*/web/*" \
		-print0 | xargs -0 clang-tidy --format-style=file
}

function find_clang_format() {
	# Check if clang-tidy is installed
	if ! command -v clang-tidy >/dev/null 2>&1; then
		echo "Error: clang-tidy is not installed"
		exit 1
	fi
}

function main() {
	cd ..
	echo "Running clang-tidy..."
	find_clang_format
	clang_format
}

main

#!/usr/bin/env bash

set -e
shopt -s extglob

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
pushd "$scriptdir" >/dev/null
trap "popd >/dev/null" EXIT

CLEAN="n"
JOBS=1
MODE="debug"
TARGETS=()
CFLAGS=()
LFLAGS=()
parse_arguments () {
	while [[ $# -gt 0 ]]; do case $1 in
		-c|--clean)
			CLEAN="y"; shift;;
		-cc|--compiler)
			CC="$2"; shift; shift;;
		-d|--debug)
			MODE="debug"; shift;;
		-h|--help)
			HELP="y"; shift;;
		-j|--jobs)
			JOBS=$2; shift; shift;;
		-r|--release)
			MODE="release"; shift;;

		-cf|--cflags)
			while IFS=";" read -ra ARR; do
				for item in "${ARR[@]}"; do
					CFLAGS+=("$item")
				done
			done <<< "$2"
			shift; shift;;

		-lf|--lflags)
			while IFS=";" read -ra ARR; do
				for item in "${ARR[@]}"; do
					LFAGS+=("$item")
				done
			done <<< "$2"
			shift; shift;;

		-t|--targets)
			while IFS="," read -ra ARR; do
				for item in "${ARR[@]}"; do
					TARGETS+=("$item")
				done
			done <<< "$2"
			shift; shift;;

		*)
			echo -e "ERROR: Unknown argument: $1\n"; HELP="y"; shift;;
	esac; done
}
parse_arguments "${@}"

if ! [[ $JOBS =~ ^[1-9][0-9]*$ ]] ; then
	echo -e "ERROR: The number of jobs must be a positive integer. Received: $JOBS\n"
	HELP="y"
fi

if [ -z "$CC" ]; then
	os="$(uname -s)"
	[ "$os" = "Darwin" ] && CC="clang"
	[ "$os" = "Linux" ] && CC="gcc"
fi

[ ${#CFLAGS[@]} -eq 0 ] && [ "$MODE" = "debug" ] && CFLAGS=(-std=c99 -g -O0 -Wall -Werror)
[ ${#CFLAGS[@]} -eq 0 ] && [ "$MODE" = "release" ] && CFLAGS=(-std=c99 -O3 -Wall -Werror)
[ ${#LFLAGS[@]} -eq 0 ] && [ "$MODE" = "debug" ] && LFLAGS=()
[ ${#LFLAGS[@]} -eq 0 ] && [ "$MODE" = "release" ] && LFLAGS=()

help () {
	echo 'Build all in debug mode                  ./build.sh'
	echo 'Build all in release mode                ./build.sh -r|--release'
	echo 'Remove all build and execution artifacts ./build.sh -c|--clean'
	echo 'Build specific targets                   ./build.sh -t|--targets 01,02,03,...'
	echo 'Build using a specific compiler          ./build.sh -cc|--compiler'
	echo 'Build w/ specific CFLAGS/LFLAGS          ./build.sh -cf|--cflags "-Wall -Werror ..." -lf|--lflags "..."'
	echo 'Increase the number of build jobs        ./build.sh -j|--jobs 2'

	echo -e "\nCurrent configuration:"
	echo -e "\tJOBS: $JOBS"
	echo -e "\tMODE: $MODE"
	echo -e "\tCC: $CC"
	echo -e "\tCFLAGS: ${CFLAGS[*]}"
	echo -e "\tLFLAGS: ${LFLAGS[*]}"
}

print_and_run () {
	echo "$@"
	# shellcheck disable=SC2068
	$@
}

if [ "$HELP" = "y" ]; then
	help
	exit 0
fi

if [ "$CLEAN" = "y" ]; then
	print_and_run "rm -rf ./bin ./*.ppm"
	exit 0
fi

build () {
	mkdir -p ./bin
	if [ ${#TARGETS[@]} -eq 0 ]; then
		NTH_BUILD=0
		for item in +([0-9])*.c; do
			((NTH_BUILD = NTH_BUILD % JOBS)) || true
			((++NTH_BUILD == 1)) && wait
			print_and_run "$CC" "${item}" "${CFLAGS[@]}" "${LFLAGS[@]}" -o "./bin/${item%".c"}"
		done
		wait
	else
		for item in "${TARGETS[@]}"; do
			((NTH_BUILD = NTH_BUILD % JOBS)) || true
			((++NTH_BUILD == 1)) && wait
			print_and_run "$CC" "${item}.c" "${CFLAGS[@]}" "${LFLAGS[@]}" -o "./bin/$item"
		done
		wait
	fi
	[ -z "$( /bin/ls -A './bin' )" ] && rmdir ./bin
}
build

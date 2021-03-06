#!/usr/bin/env bash

_common_setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$PROJECT_ROOT/src:$PATH"
	if ! [[ -d $PROJECT_ROOT/test/resource/original ]]; then
		mkdir $PROJECT_ROOT/test/resource/original
	fi
	if ! [[ -d $PROJECT_ROOT/test/resource/new ]]; then
		mkdir $PROJECT_ROOT/test/resource/new
	fi
    cd $PROJECT_ROOT/test/resource/original/
    cp ../original_BAK/* .
}

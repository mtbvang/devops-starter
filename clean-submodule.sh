#!/usr/bin/env bash


# Remove leading and trailing whitespace chars.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

MODULE=$(trim ${1})

git submodule deinit -f ${MODULE}
git rm -f ${MODULE}
rm -rf .git/modules/${MODULE}/

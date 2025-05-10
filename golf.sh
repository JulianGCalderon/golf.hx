#!/bin/sh

BASE_URL="https://golf-d5bs.onrender.com/v1"

usage() {
	echo "Usage: golf.sh [mode]"
	echo
	echo "Modes:"
	echo "    daily:      play daily challenge"
	echo "    easy:       play easy difficulty challenge"
	echo "    medium:     play medium difficulty challenge"
	echo "    hard:       play hard difficulty challenge"
	echo
	echo "If no mode is given, a random challenge is selected."
	exit 1
}
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

if [ "$1" = "--help" ]; then
	usage
fi

mode=$1
case $mode in
  daily)
    challenge_url="$BASE_URL/challenges/daily"
  ;;
  easy)
    challenge_url="$BASE_URL/challenges/random?difficulty=easy"
  ;;
  medium)
    challenge_url="$BASE_URL/challenges/random?difficulty=medium"
  ;;
  hard)
    challenge_url="$BASE_URL/challenges/random?difficulty=hard"
  ;;
  "")
    challenge_url="$BASE_URL/challenges/random"
  ;;
  *)
    die "invalid mode"
  ;;
esac

challenge=$(curl -s -H "Accept: application/json" "$challenge_url")

jq_string() {
	data=$1; shift
	printf "%s" "$data" | jq "$@"
}
title=$(jq_string "$challenge" .title --raw-output)
difficulty=$(jq_string "$challenge" .difficulty --raw-output)
description=$(jq_string "$challenge" .description --raw-output)
tags=$(jq_string "$challenge" '.tags // [] | join(", ")' --raw-output)
start_text=$(jq_string "$challenge" .start_text --raw-output)
end_text=$(jq_string "$challenge" .end_text --raw-output)

tmp_dir_name=$(echo "$title" | tr -s ' ' '-' | tr '[:upper:]' '[:lower:]')
tmp_dir=".tmp/$tmp_dir_name"
mkdir -p "$tmp_dir"
instructions_file="$tmp_dir/instructions.md"
expected_file="$tmp_dir/expected"
submission_file="$tmp_dir/submission"

{
	echo "$end_text"
} > "$expected_file"

{
	echo "# $title"
	echo
	echo "- difficulty: $difficulty"
	echo "- tags: $tags"
	echo
	echo "$description"
	echo
	echo "# Expected"
	echo
	echo '```'
	cat "$expected_file"
	echo '```'
} > "$instructions_file"

{
	echo "$start_text"
} > "$submission_file"

start_time=$(date +%s)
hx --vsplit "$instructions_file" "$submission_file"
end_time=$(date +%s)

elapsed_time=$((end_time - start_time))
echo "Took $elapsed_time seconds."
echo

if cmp -s "$expected_file" "$submission_file"; then
	echo "Success!"
else
	echo "Failure!"
	echo
	diff --color=always "$expected_file" "$submission_file"
fi

#!/usr/bin/env bash
# check.sh — the vault's test suite. Run from the repo root: bash 99.Meta/scripts/check.sh [--full]
# Every task in docs/plan.md appends a check_<name> function; all check_* functions run automatically.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."
FAILS=0; PASSES=0
fail() { echo "FAIL: $*"; FAILS=$((FAILS + 1)); }
ok()   { echo "ok:   $*"; PASSES=$((PASSES + 1)); }
FULL=0; [[ "${1:-}" == "--full" ]] && FULL=1

check_skeleton() {
	for d in 0.Map_of_Contents 00.Inbox 01.Fleeting 99.Meta; do
		[[ -d "$d" ]] && ok "dir $d" || fail "missing dir $d"
	done
	local links; links=$(find . -path ./.git -prune -o -path ./.superpowers -prune -o -type l -print)
	[[ -z "$links" ]] && ok "no symlinks" || fail "symlinks present: $links"
	local spaced; spaced=$(ls -1 | grep -c ' ' || true)
	[[ "$spaced" == "0" ]] && ok "no spaces in top-level names" || fail "top-level names with spaces: $spaced"
	[[ -f LICENSE ]] && ok "LICENSE" || fail "missing LICENSE"
	[[ -f README.md ]] && ok "README.md" || fail "missing README.md"
	[[ -f .gitignore ]] && grep -q 'workspace.json' .gitignore && ok ".gitignore ignores workspace.json" || fail ".gitignore missing workspace.json"
}

for fn in $(declare -F | awk '{print $3}' | grep '^check_'); do
	echo "== $fn"; "$fn"
done
echo "== $PASSES ok, $FAILS failed"
[[ $FAILS -eq 0 ]]

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

check_system_files() {
	for f in MANIFESTO.md CLAUDE.md AGENTS.md; do [[ -f "$f" ]] && ok "$f" || fail "missing $f"; done
	[[ -f CLAUDE.md ]] || return 0
	[[ "$(grep -c '^@' CLAUDE.md)" == "0" ]] && ok "no @import in CLAUDE.md" || fail "CLAUDE.md has @ lines"
	grep -qF "A real person whose ideas don't always cascade in the logical, sequential style served up by AI." MANIFESTO.md && ok "manifesto sentence" || fail "manifesto sentence missing"
	for kw in '[!ai]' 'explored' '리버스 프롬프팅' '30일'; do grep -qF "$kw" CLAUDE.md && ok "CLAUDE.md has $kw" || fail "CLAUDE.md lacks $kw"; done
	for h in '## 철학 (요약)' '## 규칙 8' '## 폴더' '## 커맨드' '## 긴 규칙은 99.Meta/rules/ 를 Read'; do grep -qF "$h" CLAUDE.md && ok "section $h" || fail "CLAUDE.md lacks section $h"; done
	if diff -q <(sed '1,/^# /d' CLAUDE.md) <(sed '1,/^# /d' AGENTS.md) >/dev/null; then ok "CLAUDE/AGENTS bodies identical"; else fail "CLAUDE/AGENTS bodies differ"; fi
	for r in frontmatter wikilink blank-line human-ai-layers growth-path; do
		[[ -f "99.Meta/rules/$r.md" ]] && ok "rule $r" || fail "missing rule 99.Meta/rules/$r.md"
	done
}

for fn in $(declare -F | awk '{print $3}' | grep '^check_'); do
	echo "== $fn"; "$fn"
done
echo "== $PASSES ok, $FAILS failed"
[[ $FAILS -eq 0 ]]

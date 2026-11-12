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

fm_block() { awk 'NR==1 && $0!="---"{exit} NR==1{next} /^---$/{exit} {print}' "$1"; }
yaml_ok() { fm_block "$1" | sed -E 's/<%[^%]*%>/X/g' | ruby -ryaml -rdate -e 'YAML.safe_load(STDIN.read, permitted_classes: [Date]) or exit 1' >/dev/null 2>&1; }
check_templates() {
	local t; for t in 나 씨앗 데일리 위클리 프로젝트 취향; do
		local f="99.Meta/templates/$t.md"
		[[ -f "$f" ]] || { fail "missing template $f"; continue; }
		yaml_ok "$f" && ok "template $t yaml" || fail "template $t yaml broken"
		grep -qE '^description: "' "$f" && ok "template $t description quoted" || fail "template $t description not quoted"
		grep -qE '^type: (me|seed|note|daily|weekly|project|taste)$' "$f" && ok "template $t type" || fail "template $t type not in allowed set"
		grep -qE 'move file|GWTH:' "$f" && fail "template $t carries mothership-only keys" || ok "template $t no mothership keys"
	done
	[[ -f 99.Meta/templates/위클리.md ]] && grep -qF '[!ai]' 99.Meta/templates/위클리.md && grep -qF '질문 3개' 99.Meta/templates/위클리.md && ok "weekly has [!ai] 질문 3개" || fail "weekly lacks [!ai] 질문 3개"
	local me="0.Map_of_Contents/🏛 나.md"
	[[ -f "$me" ]] || { fail "missing $me"; return 0; }
	for h in '누구인가' '무엇을 하는가' '지금 국면' '취향' '금지어'; do grep -q "^## .*$h" "$me" && ok "나.md heading $h" || fail "나.md lacks heading $h"; done
	[[ -f 00.Inbox/README.md ]] && grep -q '일주일에 한 번' 00.Inbox/README.md && ok "Inbox README" || fail "Inbox README missing or lacks rule"
}

PLUGIN_IDS="omnisearch realclaudian obsidian-excalidraw-plugin notebook-navigator obsidian-style-settings templater-obsidian periodic-notes calendar quickadd smart-connections obsidian42-strange-new-worlds obsidian-advanced-uri"
check_obsidian() {
	[[ -d .obsidian ]] || { fail "missing .obsidian/"; return 0; }
	local want; want=$(for id in $PLUGIN_IDS; do [[ "$id" != realclaudian ]] && echo "$id"; done | sort)
	local have; have=$(python3 -I -c 'import json;print("\n".join(sorted(json.load(open(".obsidian/community-plugins.json")))))' 2>/dev/null)
	[[ "$have" == "$want" ]] && ok "community-plugins = 11 enabled ids" || fail "community-plugins.json differs from expected set (realclaudian must be disabled)"
	for id in $PLUGIN_IDS; do [[ -f ".obsidian/plugins/$id/manifest.json" && -f ".obsidian/plugins/$id/main.js" ]] && ok "plugin $id" || fail "plugin $id missing manifest/main"; done
	[[ -f .obsidian/workspace.json ]] && fail "workspace.json must not exist" || ok "no workspace.json"
	grep -q '"cssTheme": "Velocity"' .obsidian/appearance.json 2>/dev/null && [[ -f .obsidian/themes/Velocity/theme.css ]] && ok "Velocity theme" || fail "Velocity theme not set/present"
	grep -q 'data-callout="ai"' .obsidian/snippets/gwth-velocity.css 2>/dev/null && ok "ai callout style" || fail "snippet lacks ai callout style"
	local leak; leak=$(grep -ril 'Growth_Bridge\|영민\|/Users/young' .obsidian/snippets .obsidian/plugins/*/data.json .obsidian/*.json 2>/dev/null || true)
	[[ -z "$leak" ]] && ok "no personal identifiers in .obsidian" || fail "personal identifiers: $leak"
	grep -q '"bases"' .obsidian/core-plugins.json 2>/dev/null && ok "core bases on" || fail "core-plugins lacks bases"
	[[ -f 99.Meta/LICENSES.md ]] || { fail "missing 99.Meta/LICENSES.md"; return 0; }
	for id in $PLUGIN_IDS Velocity cmds-llm-wiki; do grep -q "$id" 99.Meta/LICENSES.md && ok "license row $id" || fail "LICENSES.md lacks $id"; done
	grep -qi 'TODO' 99.Meta/LICENSES.md && fail "LICENSES.md has TODO" || ok "LICENSES.md complete"
}

for fn in $(declare -F | awk '{print $3}' | grep '^check_'); do
	echo "== $fn"; "$fn"
done
echo "== $PASSES ok, $FAILS failed"
[[ $FAILS -eq 0 ]]

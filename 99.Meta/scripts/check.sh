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
	[[ -f .gitattributes ]] && grep -qE '^\*\.sh text eol=lf' .gitattributes && ok ".gitattributes forces LF for .sh" || fail ".gitattributes missing or lacks '*.sh text eol=lf'"
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
	git ls-files --error-unmatch .obsidian/workspace.json >/dev/null 2>&1 && fail "workspace.json is tracked (must stay ignored)" || ok "workspace.json not tracked"
	grep -q '"cssTheme": "Velocity"' .obsidian/appearance.json 2>/dev/null && [[ -f .obsidian/themes/Velocity/theme.css ]] && ok "Velocity theme" || fail "Velocity theme not set/present"
	grep -q 'data-callout="ai"' .obsidian/snippets/gwth-velocity.css 2>/dev/null && ok "ai callout style" || fail "snippet lacks ai callout style"
	local leak; leak=$(grep -ril 'Growth_Bridge\|영민\|/Users/young' .obsidian/snippets .obsidian/plugins/*/data.json .obsidian/*.json 2>/dev/null || true)
	[[ -z "$leak" ]] && ok "no personal identifiers in .obsidian" || fail "personal identifiers: $leak"
	grep -q '"bases"' .obsidian/core-plugins.json 2>/dev/null && ok "core bases on" || fail "core-plugins lacks bases"
	grep -q '"daily-notes": false' .obsidian/core-plugins.json 2>/dev/null && [[ ! -f .obsidian/daily-notes.json ]] && ok "core daily-notes off (Periodic Notes owns dailies)" || fail "core daily-notes must be off and daily-notes.json absent"
	grep -q '"trigger_on_file_creation": true' .obsidian/plugins/templater-obsidian/data.json 2>/dev/null && ok "templater triggers on file creation" || fail "templater trigger_on_file_creation must be true (folder templates depend on it)"
	[[ -f 99.Meta/LICENSES.md ]] || { fail "missing 99.Meta/LICENSES.md"; return 0; }
	for id in $PLUGIN_IDS Velocity cmds-llm-wiki; do grep -q "$id" 99.Meta/LICENSES.md && ok "license row $id" || fail "LICENSES.md lacks $id"; done
	grep -qi 'TODO' 99.Meta/LICENSES.md && fail "LICENSES.md has TODO" || ok "LICENSES.md complete"
}

check_profiles() {
	local name; for name in daily projects knowledge ai; do
		local wantf; case "$name" in daily) wantf="02.Daily";; projects) wantf="10.Projects 20.Areas 30.Resources 40.Archives";; knowledge) wantf="03.Notes";; ai) wantf="50.Wiki";; esac
		local f="99.Meta/profiles/$name.md"; [[ -f "$f" ]] || { fail "missing profile $f"; continue; }
		local heads; heads=$(grep -E '^## ' "$f" | sed 's/^## //' | tr '\n' '|')
		[[ "$heads" == "목적|더해지는 폴더|템플릿·설정|MOC 골격|손으로 적용하는 법|"* ]] && ok "profile $name sections" || fail "profile $name sections wrong: $heads"
		local folders; folders=$(awk '/^## 더해지는 폴더/{f=1;next} /^## /{f=0} f && /^- `/{gsub(/[-` ]/,""); print}' "$f" | tr '\n' ' ' | sed 's/ $//')
		[[ "$folders" == "$wantf" ]] && ok "profile $name folders" || fail "profile $name folders '$folders' != '$wantf'"
		local moc; moc=$(grep -oE '\[\[moc-[^]|]+' "$f" | head -1 | sed 's/\[\[//')
		[[ -n "$moc" && -f "99.Meta/templates/$moc.md" ]] && ok "profile $name moc template $moc" || fail "profile $name MOC 골격 link missing or template absent ($moc)"
	done
	grep -q '사전 준비' 99.Meta/profiles/ai.md 2>/dev/null && grep -q 'realclaudian' 99.Meta/profiles/ai.md && ok "ai profile prerequisites" || fail "ai profile lacks 사전 준비 / realclaudian"
	local b; for b in '자라는 씨앗' '최근 연결'; do
		local bf="99.Meta/bases/$b.base"
		[[ -f "$bf" ]] && ruby -ryaml -e 'YAML.safe_load(File.read(ARGV[0]))' "$bf" >/dev/null 2>&1 && grep -q '^views:' "$bf" && ok "base $b" || fail "base $b missing/invalid"
	done
}

check_commands() {
	local c; for c in onboard map weekly seeds; do
		local f=".claude/commands/$c.md"; [[ -f "$f" ]] || { fail "missing command $f"; continue; }
		grep -qE '^description: "' "$f" && ok "command $c description quoted" || fail "command $c description not quoted"
	done
	[[ -f .claude/commands/onboard.md ]] && for kw in '99.Meta/profiles' '덮어쓰지' '비어 있을 때만'; do grep -qF "$kw" .claude/commands/onboard.md && ok "onboard has $kw" || fail "onboard lacks $kw"; done
	[[ -f .claude/commands/weekly.md ]] && for kw in '말하지 않은 전제' '끊긴 논리' '감정만' '판단 없는' '모순' '답은 손으로'; do grep -qF "$kw" .claude/commands/weekly.md && ok "weekly has $kw" || fail "weekly lacks $kw"; done
	[[ -f .claude/commands/map.md ]] && grep -qF '승인' .claude/commands/map.md && ok "map has 승인" || fail "map lacks 승인"
	if [[ -f .claude/commands/seeds.md ]]; then
		[[ "$(wc -l < .claude/commands/seeds.md)" -le 40 ]] && ok "seeds ≤ 40 lines" || fail "seeds.md longer than 40 lines"
		grep -qF '이동·삭제는 하지 않는다' .claude/commands/seeds.md && ok "seeds no-move rule" || fail "seeds lacks 이동·삭제는 하지 않는다"
	fi
}

KIT_CMDS="ingest query lint verify status reindex refresh-context inbox capture-tabs audit"
check_kit() {
	[[ -f 50.Wiki/CLAUDE.md ]] || { fail "missing 50.Wiki/CLAUDE.md"; return 0; }
	grep -q 'cmds-llm-wiki' 50.Wiki/CLAUDE.md && grep -q 'v1.13.0' 50.Wiki/CLAUDE.md && ok "kit attribution" || fail "50.Wiki/CLAUDE.md lacks attribution/version"
	local stray; stray=$(find 50.Wiki -maxdepth 3 \( -name .claude -o -name .codex -o -name .agents -o -name '94. Agent Settings' -o -name 'setup-agent-links.*' \) -print)
	[[ -z "$stray" ]] && ok "no kit dotfolders under 50.Wiki" || fail "stray kit harness under 50.Wiki: $stray"
	local c; for c in $KIT_CMDS; do
		local f=".claude/commands/$c.md"; [[ -f "$f" ]] || { fail "missing kit command $f"; continue; }
		local bare; bare=$(grep -nE '(00\. Inbox|10\. Raw Sources|20\. Wiki|30\. Queries|40\. Paper Analyses|70\. Outputs|80\. References|90\. Settings)/' "$f" | grep -v '50\.Wiki/' || true)
		[[ -z "$bare" ]] && ok "kit command $c paths prefixed" || fail "kit command $c has unprefixed paths: $(echo "$bare" | head -2 | tr '\n' ' ')"
	done
	local h; for h in qmd-reindex.sh validate-raw-source.sh; do
		[[ -f ".claude/hooks/$h" ]] || { fail "missing hook $h"; continue; }
		local sample; sample=$(find "50.Wiki/10. Raw Sources" -name '*.md' | head -1)
		local payload; payload=$(printf '{"tool_input":{"file_path":"%s"}}' "$PWD/${sample:-50.Wiki/10. Raw Sources/x.md}")
		if echo "$payload" | env -i HOME="$HOME" PATH=/usr/bin:/bin CLAUDE_PROJECT_DIR="$PWD" /bin/bash ".claude/hooks/$h" >/dev/null 2>&1; then ok "hook $h exits 0 without qmd/python3"; else fail "hook $h fails without qmd/python3"; fi
	done
	python3 -I -m json.tool .claude/settings.json >/dev/null 2>&1 && grep -q '\\"$CLAUDE_PROJECT_DIR\\"/' .claude/settings.json && ok "settings.json hooks quoted" || fail "settings.json invalid or unquoted CLAUDE_PROJECT_DIR"
	[[ -f 99.Meta/KIT-CHANGES.md ]] && ok "KIT-CHANGES.md" || fail "missing 99.Meta/KIT-CHANGES.md"
	grep -q '🏛 나' "50.Wiki/Core Context.md" 2>/dev/null && ok "Core Context points to 🏛 나" || fail "50.Wiki/Core Context.md does not point to 🏛 나.md"
	local b; for b in 50.Wiki/*/*/*.base 50.Wiki/*/*.base; do [[ -f "$b" ]] || continue
		local bare; bare=$(grep -nE '(inFolder|file)\("(00\. Inbox|10\. Raw Sources|20\. Wiki|30\. Queries|40\. Paper Analyses)' "$b" || true)
		[[ -z "$bare" ]] && ok "base $(basename "$b") paths prefixed" || fail "base $(basename "$b") has unprefixed paths: $(echo "$bare" | head -1)"
	done
	grep -q '적용되지 않는다' 50.Wiki/CLAUDE.md && grep -q '적용되지 않는다' 50.Wiki/AGENTS.md && ok "kit schema carries the not-applicable note" || fail "50.Wiki/CLAUDE.md|AGENTS.md lack the symlink/mirror not-applicable note"
}

check_split() {
	[[ -f 99.Meta/scripts/split-wiki.sh ]] || { fail "missing split-wiki.sh"; return 0; }
	[[ -f 99.Meta/scripts/split-wiki.ps1 ]] && [[ "$(grep -c 'Copy-Item' 99.Meta/scripts/split-wiki.ps1)" -ge 1 ]] && ok "split-wiki.ps1" || fail "split-wiki.ps1 missing or lacks Copy-Item"
	grep -q 'UTF8Encoding' 99.Meta/scripts/split-wiki.ps1 2>/dev/null && grep -q 'Encoding UTF8' 99.Meta/scripts/split-wiki.ps1 && ok "split-wiki.ps1 reads/writes UTF-8" || fail "split-wiki.ps1 lacks explicit UTF-8 read/write"
	grep -q '| 5 ' 99.Meta/rules/growth-path.md && grep -q '위성' 99.Meta/rules/growth-path.md && ok "growth-path table" || fail "growth-path.md lacks the 6-stage table"
	local t; t="$(mktemp -d)/wiki-test"
	if bash 99.Meta/scripts/split-wiki.sh "$t" >/dev/null 2>&1; then ok "split-wiki ran"; else fail "split-wiki failed"; return 0; fi
	[[ -f "$t/CLAUDE.md" ]] && ok "split target has CLAUDE.md" || fail "split target lacks CLAUDE.md"
	[[ -f "$t/.claude/commands/ingest.md" ]] && [[ "$(grep -c '50\.Wiki/' "$t/.claude/commands/ingest.md")" == "0" ]] && ok "split commands unprefixed" || fail "split target ingest.md missing or still prefixed"
	[[ -f "$t/.claude/settings.json" ]] && ok "split target settings.json" || fail "split target lacks settings.json"
	[[ -f "$t/Core Context.md" ]] && grep -q 'obsidian://' "$t/Core Context.md" && ok "split reverse link" || fail "split target Core Context lacks obsidian:// link"
	[[ -z "$(git status --porcelain -- 50.Wiki .claude)" ]] && ok "source repo untouched by split" || fail "split modified source repo"
	bash 99.Meta/scripts/split-wiki.sh "$t" >/dev/null 2>&1 && fail "second split run should refuse" || ok "second split run refused"
	rm -rf "$(dirname "$t")"
}

check_readme() {
	local heads; heads=$(grep -E '^## ' README.md | sed 's/^## //' | tr '\n' '|')
	[[ "$heads" == "이 볼트는|시작하기|왜 옵시디언을 쓰나요? — 온보딩 3문항|60분 걸어보기|준비된 사람용 — AI 층|플러그인과 테마|AI 없이 쓰는 프롬프트|출처|" ]] && ok "README sections" || fail "README sections wrong: $heads"
	local missing=0 pth; while IFS= read -r pth; do [[ -e "$pth" ]] || { fail "README links to missing $pth"; missing=1; }; done < <(grep -oE '(99\.Meta/[^) `\]]+\.md|MANIFESTO\.md)' README.md | sort -u)
	[[ $missing -eq 0 ]] && ok "README paths exist"
	grep -q 'Ctrl+Shift+F' README.md && fail "README claims a Cmd/Ctrl+Shift+F Omnisearch hotkey that does not exist" || ok "README no bogus hotkey"
	for kw in 'Things 2' 'Git for Windows' 'Smart Connections' 'cmds-llm-wiki' 'YohanKoo' 'git clone'; do grep -qF "$kw" README.md && ok "README has $kw" || fail "README lacks $kw"; done
}

check_clone() {
	(( FULL )) || { ok "clone test skipped (run with --full)"; return 0; }
	local d; d="$(mktemp -d)/clone"
	git clone --quiet "$PWD" "$d" >/dev/null 2>&1 || { fail "git clone failed"; return 0; }
	( cd "$d" && bash 99.Meta/scripts/check.sh >/dev/null 2>&1 ) && ok "clone passes check.sh" || fail "clone fails check.sh"
	[[ -z "$(find "$d" -path "$d/.git" -prune -o -type l -print)" ]] && ok "clone has no symlinks" || fail "clone has symlinks"
	[[ "$(cd "$d" && git ls-files | grep -c workspace.json)" == "0" ]] && ok "clone has no workspace.json" || fail "workspace.json tracked"
	local n; n=$(cd "$d" && git ls-files | wc -l | tr -d ' ')
	[[ "$n" -le 1500 ]] && ok "clone tracks $n files (≤1500)" || fail "clone tracks $n files — something large slipped in"
	rm -rf "$(dirname "$d")"
}

for fn in $(declare -F | awk '{print $3}' | grep '^check_'); do
	echo "== $fn"; "$fn"
done
echo "== $PASSES ok, $FAILS failed"
[[ $FAILS -eq 0 ]]

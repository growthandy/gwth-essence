#!/usr/bin/env bash
# split-wiki.sh — 50.Wiki/ 를 독립 볼트로 떼어낸다 (growth-path 4단계).
# Usage: bash 99.Meta/scripts/split-wiki.sh /path/to/new-vault [--dry-run]
# - 50.Wiki/ 전체를 새 볼트 루트로 복사한다 (원본은 건드리지 않는다)
# - 루트 .claude/ 의 킷 커맨드·훅을 새 볼트 .claude/ 로 복사하며 `50.Wiki/` 접두를 뗀다
# - 새 볼트 Core Context.md 끝에 이 볼트의 🏛 나.md 로 가는 obsidian:// 링크를 남긴다
# - 이 볼트 쪽에 넣을 링크는 화면에 출력한다 (📖 위키.md 에 사람이 붙여 넣는다)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../.."

TARGET="${1:-}"; DRY=0; [[ "${2:-}" == "--dry-run" ]] && DRY=1
[[ -n "$TARGET" ]] || { echo "usage: split-wiki.sh /path/to/new-vault [--dry-run]" >&2; exit 2; }
[[ -d 50.Wiki ]] || { echo "50.Wiki/ not found — nothing to split" >&2; exit 2; }
[[ -e "$TARGET" ]] && { echo "refusing: $TARGET already exists" >&2; exit 1; }

KIT_CMDS="ingest query lint verify status reindex refresh-context inbox capture-tabs audit"
VAULT_NAME="$(basename "$PWD")"
NEW_NAME="$(basename "$TARGET")"
urlenc() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$1" 2>/dev/null || printf '%s' "$1" | sed 's/ /%20/g'; }
BACK_LINK="obsidian://advanced-uri?vault=$(urlenc "$VAULT_NAME")&filepath=$(urlenc '0.Map_of_Contents/🏛 나.md')"
FWD_LINK="obsidian://advanced-uri?vault=$(urlenc "$NEW_NAME")&filepath=index.md"

if (( DRY )); then
	echo "would copy 50.Wiki/ -> $TARGET"
	echo "would copy .claude/{commands: $KIT_CMDS, hooks, settings.json} -> $TARGET/.claude (50.Wiki/ prefix removed)"
	echo "would append back-link to $TARGET/Core Context.md: $BACK_LINK"
	echo "paste into 0.Map_of_Contents/📖 위키.md: [$NEW_NAME 위키]($FWD_LINK)"
	exit 0
fi

mkdir -p "$TARGET/.claude/commands" "$TARGET/.claude/hooks"
cp -R 50.Wiki/. "$TARGET/"
for c in $KIT_CMDS; do
	[[ -f ".claude/commands/$c.md" ]] && sed 's#50\.Wiki/##g' ".claude/commands/$c.md" > "$TARGET/.claude/commands/$c.md"
done
for h in .claude/hooks/*.sh; do
	sed 's#50\.Wiki/##g' "$h" > "$TARGET/.claude/hooks/$(basename "$h")"
	chmod +x "$TARGET/.claude/hooks/$(basename "$h")"
done
cp .claude/settings.json "$TARGET/.claude/settings.json"
printf '\n## Mothership\n- 이 위키는 %s 볼트에서 분리됐다. 자화상(Core Context 원본): [%s · 🏛 나](%s)\n' "$VAULT_NAME" "$VAULT_NAME" "$BACK_LINK" >> "$TARGET/Core Context.md"

echo "split done -> $TARGET"
echo "next: open $TARGET as a new vault, install plugins (Claudian, Advanced URI), then paste this into 0.Map_of_Contents/📖 위키.md:"
echo "[$NEW_NAME 위키]($FWD_LINK)"
echo "then delete 50.Wiki/ from this vault once the new vault opens (git rm -r 50.Wiki)."

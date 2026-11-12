# KIT-CHANGES — cmds-llm-wiki v1.13.0 (9a4f6e2) 대비 바뀐 것

원본: https://github.com/johnfkoo951/cmds-llm-wiki · 동봉 위치 `50.Wiki/` · 작성 2026-11-12

## 동봉하지 않은 것
- `.claude/` `.codex/` `.agents/` `.obsidian/` `docs/` `assets/` `index.html` `index-brutalist.html` `.gitignore` — 하네스 점폴더와 사이트 자산. 커맨드·훅은 볼트 루트 `.claude/` 로 옮겼다
- `90. Settings/94. Agent Settings/` · `90. Settings/Scripts/setup-agent-links.sh|.ps1` — symlink 레이아웃 (이 볼트는 symlink 를 두지 않는다)
- 킷의 `onboard.md` 커맨드 — 이 볼트의 `/onboard`(프로파일 온보딩)가 대신한다

## 고친 파일
- `.claude/commands/{ingest,query,lint,verify,status,reindex,refresh-context,inbox,capture-tabs,audit}.md` — 킷 폴더·루트 파일 경로에 `50.Wiki/` 접두 (정규식 치환 후 사람 검토)
- `.claude/hooks/qmd-reindex.sh` — 둘째 줄 `command -v qmd || exit 0` (qmd 없으면 건너뜀)
- `.claude/hooks/validate-raw-source.sh` — `command -v python3 || exit 0` + 경로 판정 `50.Wiki/10. Raw Sources/`
- `.claude/settings.json` — 킷과 같은 PostToolUse 2건, `"$CLAUDE_PROJECT_DIR"` 큰따옴표
- `50.Wiki/CLAUDE.md` `50.Wiki/AGENTS.md` — 프론트매터 아래 출처·경로 기준 한 줄
- `50.Wiki/Core Context.md` — 킷 placeholder 대신 `../0.Map_of_Contents/🏛 나.md` 포인터

## 그대로인 것
- 폴더 구조 · 템플릿 · `Explored 학습 보드.base`(킷의 `date created` 유지 — 사람 층의 `created` 와 다르지만 킷 안에서는 킷 규약) · `index.md` `log.md` placeholder · README · CHANGELOG

## diff -rq 결과 (원본 vs 50.Wiki, 제외 폴더 빼고)
- Files KIT/AGENTS.md and 50.Wiki/AGENTS.md differ
- Files KIT/CLAUDE.md and 50.Wiki/CLAUDE.md differ
- Files KIT/Core Context.md and 50.Wiki/Core Context.md differ

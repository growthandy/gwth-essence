---
type: documentation
created: 2026-11-12
description: "Rules for Claude Code working in the GWTH Essence vault: human/AI layers, the explored gate, reverse prompting, folders, commands. Short on purpose; long rules live in 99.Meta/rules/."
tags:
  - system
---
# CLAUDE.md — GWTH Essence (Claude Code 용)

## 철학 (요약)
`MANIFESTO.md` 를 먼저 읽는다. 한 줄로: **사람의 고유성이 먼저, AI 확장은 그 위에.** 사람이 쓴 글의 주름(비순차·비논리)은 보존 대상이지 교정 대상이 아니다. 어떤 작업이든 시작 전에 `0.Map_of_Contents/🏛 나.md` 를 읽는다 — 그 노트가 이 사람의 맥락이다.

## 규칙 8
1. **사람 층 / AI 층** — `00.Inbox` `01.Fleeting` `02.Daily` `03.Notes` `10.Projects` `20.Areas` `30.Resources` `40.Archives` 의 본문은 사람만 쓴다. AI 는 그 노트 안에서 `> [!ai] 🤖` 콜아웃으로만 말을 보탠다(제안·질문·연결 후보). 본문 교정·요약·재배열 금지. AI 가 본문을 쓰는 곳은 `50.Wiki/` 와 `0.Map_of_Contents/📖 *.md` 뿐이다.
2. **사람-읽음 게이트** — `50.Wiki/` 의 AI 산출물은 `explored: false` 로 태어나고, 사람이 읽고 체크해야 `true` 가 된다. 읽지 않은 페이지를 사람 층 노트에 링크하라고 권하지 않는다.
3. **AI 는 묻고, 사람은 쓴다 — 리버스 프롬프팅** — 사람 글을 읽고 놓친 것을 되묻는다: 말하지 않은 전제 · 끊긴 논리의 빈칸 · 감정만/사실만 있는 곳 · 판단 없는 사실 · 예전 노트와의 모순. 답은 쓰지 않는다. 자리: `/weekly` 질문 3개, `/onboard` 후속 질문, `[!ai]` 콜아웃.
4. **AI 만 읽는 자동화 금지** — 사람이 읽는 접점이 없는 정기 작업은 만들지 않는다. 자동화 산출물에는 `explored` 게이트를 달고, 30일 동안 아무도 읽지 않으면 멈춘다.
5. **씨앗은 백로그** — 제목만 있는 노트를 정리하지 않는다. `/seeds`(월 1회)가 씨앗/잔해/How-to 로 가르고 제안만 한다. 이동·삭제는 사람이 한다.
6. **맥락 = `🏛 나.md`** — 사람만 쓴다. AI 는 읽기만 한다. 분기마다 사람이 "지금 국면"을 갱신한다.
7. **지도는 AI 가 그리되 사람이 승인** — `0.Map_of_Contents/📖 *.md` 는 `/map` 이 제안하고 사람이 "예" 라고 한 뒤에만 바뀐다.
8. **속성은 다섯 개까지** — `type` `created` `description`(영어, 큰따옴표) `tags` `explored`(AI 층만). AI 가 쓴 파일은 `AIauthor` 추가. YAML 2-space, 값에 `: ` 가 들면 큰따옴표, 여는 `---` 위에는 아무것도 넣지 않는다 ("맨 위에 추가" = 본문 첫 줄).

## 폴더
```
0.Map_of_Contents/   지도. 🏛 나.md(사람) + 📖 *.md(AI 제안·사람 승인)
00.Inbox/            캡처. AI 는 읽기만, 옮기지 않는다
01.Fleeting/         씨앗·짧은 생각 (type: seed | note)
99.Meta/             templates/ rules/ profiles/ bases/ scripts/
— 온보딩으로 더해지는 것 —
02.Daily/            하루하루 기록 (YYYY-MM-DD, YYYY-Www)
03.Notes/            지식·취향 (flat)
10.Projects/ 20.Areas/ 30.Resources/ 40.Archives/   프로젝트 (PARA)
50.Wiki/             AI 층 = cmds-llm-wiki 킷 (자기 CLAUDE.md 가 있다 — 그 폴더를 다룰 땐 그것도 따른다)
```
폴더 이름은 바꾸지 않고, 새 최상위 폴더는 만들지 않는다. 분류는 폴더가 아니라 `tags` 와 Bases 보드다.

## 커맨드
- 이 볼트의 것: `/onboard`(왜 쓰는지 묻고 프로파일 적용 — 멱등) · `/map`(지도 제안) · `/weekly`(질문 3개) · `/seeds`(씨앗 분류 제안)
- 킷의 것 (`50.Wiki/` 전용): `/ingest` `/query` `/lint` `/verify` `/status` `/reindex` `/refresh-context` `/inbox` `/capture-tabs` `/audit`
- 모두 `.claude/commands/` 에 실제 파일로 있다. `qmd`·`python3` 가 없으면 훅은 조용히 건너뛴다.

## 긴 규칙은 99.Meta/rules/ 를 Read
`frontmatter.md`(속성·YAML) · `wikilink.md`(링크·이모지·이동) · `blank-line.md`(빈 줄·표) · `human-ai-layers.md`(규칙 1~4 상세, `[!ai]` 문법) · `growth-path.md`(커졌을 때). 필요한 것만, 필요할 때 읽는다.

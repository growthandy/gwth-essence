---
GWTH:
  - "[[102.50 지식관리 pkm]]"
index:
  - "[[🏷 Analysis Notes(A@)]]"
AIauthor:
  - Claude(Fable 5.1)
description: "Implementation plan for the shareable GWTH Essence vault repository: 10 tasks from repo skeleton to clone test, each with a check.sh assertion cycle. Executors read this with the design document 2026-11-12-essence-vault-design.md."
created: 2026-11-12
updated: 2026-11-12
status: 🖨️ 초안 작성
tags:
  - 지식관리/볼트설계
  - 프로젝트/공유볼트
---
# GWTH Essence Vault — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the shareable "GWTH Essence" Obsidian vault as a GitHub-ready repository at `/Users/young/DEV/gwth-essence/` that opens working on macOS and Windows right after `git clone`, with the common core, four purpose profiles, the LLM Wiki kit for prepared users, and the originality rules.

**Architecture:** A plain Obsidian vault committed with its `.obsidian/` and `.claude/` as real files (no symlinks). One bash check script (`99.Meta/scripts/check.sh`) is the test suite: every task adds assertions to it before adding files, and the script must exit 0 at the end of every task. Profiles are documents (`99.Meta/profiles/*.md`) read by both the README (humans) and `/onboard` (AI).

**Tech Stack:** Obsidian 1.15+, Markdown/YAML, bash (+ PowerShell twin for one script), Templater, Bases, cmds-llm-wiki v1.13.0 (vendored), Claude Code slash commands.

**Spec:** `/Users/young/Obsidian Sync/Growth_Bridge_/05.Resources/GenAI Chats/2026-11-12-essence-vault-design.md` (v2). Task 1 copies spec and this plan into the repo as `docs/`.

## Global Constraints

- Repo root: `/Users/young/DEV/gwth-essence/` (outside the vault — `file-creation-rules.md`). Default branch `main`. Commit after every task.
- **No symlinks anywhere in the repo** (Windows). `find . -type l` must return nothing.
- **Top-level folder names have no spaces**: `0.Map_of_Contents` `00.Inbox` `01.Fleeting` `99.Meta` (+ profile folders `02.Daily` `03.Notes` `10.Projects` `20.Areas` `30.Resources` `40.Archives` `50.Wiki` are created only by onboarding, so they are NOT in the repo except `50.Wiki` which is vendored).
- Frontmatter: YAML 2-space, `description` always double-quoted, no line above the opening `---`. Property set ≤ 5 (`type` `created` `description` `tags` `explored`) + `AIauthor` on AI-written files.
- Human-layer body text is written only by humans; AI speaks in `> [!ai]` callouts. Human-read gate uses the kit's `explored`.
- Hooks must exit 0 when `qmd` or `python3` is absent.
- Language: Korean body, English `description`. Manifesto sentence verbatim: *"A real person whose ideas don't always cascade in the logical, sequential style served up by AI."*
- Plugins (exactly 10 community ids): `omnisearch` `realclaudian` `obsidian-excalidraw-plugin` `notebook-navigator` `obsidian-style-settings` `templater-obsidian` `periodic-notes` `calendar` `quickadd` `smart-connections` `obsidian42-strange-new-worlds` `obsidian-advanced-uri` → that is 12 ids; spec counts Templater+Periodic+Calendar as one row. Ship all 12 installed; `realclaudian` **disabled** in `community-plugins.json` (enabled by the AI profile).
- Theme: Velocity default + sanitized snippet; `workspace.json` not committed.
- Kit: `cmds-llm-wiki` v1.13.0 (commit `9a4f6e2`) vendored under `50.Wiki/`; attribution line in README and `50.Wiki/CLAUDE.md`; every kit edit listed in `99.Meta/KIT-CHANGES.md`.

## Review Focus

1. A user **without Claude Code** opens the vault → nothing errors: Claudian stays disabled, no hook runs (hooks only run inside Claude Code). Test in Task 4 (plugin state) and Task 7 (hook skip).
2. A **Windows** clone → no symlink text files, no `@import` lines in `CLAUDE.md`, scripts have a `.ps1` twin where a human must run them. Test in Task 1 (symlink/space assertions), Task 2 (`@` grep), Task 8 (ps1 exists).
3. **Kit commands run from the root** → every kit path is prefixed `50.Wiki/`; a bare `10. Raw Sources/` left in a command would write into the vault root. Test in Task 7 (grep for unprefixed kit paths).
4. **Onboarding applied twice** → `/onboard` must be idempotent (folders already present are left alone, `🏛 나.md` never overwritten). Test in Task 6 (command text states the rule; Task 10 manual run twice).
5. **Smart Connections first launch** downloads an embedding model and may prompt → README states it; settings ship with local model default. Test in Task 4 (data.json present) and Task 9 (README section).

---

### Task 1: Repository skeleton + check script

**Files:**
- Create: `/Users/young/DEV/gwth-essence/.gitignore`, `README.md` (stub), `LICENSE` (MIT, holder "YOUNG (GWTH Bridge)"), `docs/design.md` (copy of spec), `docs/plan.md` (copy of this plan), `0.Map_of_Contents/.gitkeep`, `00.Inbox/.gitkeep`, `01.Fleeting/.gitkeep`, `99.Meta/scripts/check.sh`

**Interfaces:**
- Produces: `99.Meta/scripts/check.sh` — bash, `set -euo pipefail`, defines `fail(msg)` (prints `FAIL: msg`, increments counter) and `ok(msg)`, runs all `check_*` functions, exits 1 if any fail. Later tasks append `check_<task>()` functions. Run from repo root: `bash 99.Meta/scripts/check.sh`.

- [ ] **Step 1: Create the repo and the failing check**

`git init -b main /Users/young/DEV/gwth-essence`. Write `check.sh` with `check_skeleton()` asserting: dirs `0.Map_of_Contents 00.Inbox 01.Fleeting 99.Meta` exist; `find . -path ./.git -prune -o -type l -print` is empty; no top-level entry name contains a space (`ls -1 | grep -c ' '` = 0); `LICENSE` and `README.md` exist.

- [ ] **Step 2: Run it to verify it fails**

Run: `bash 99.Meta/scripts/check.sh` · Expected: `FAIL:` lines for missing dirs/LICENSE, exit 1.

- [ ] **Step 3: Add the skeleton files**

`.gitignore`: `.obsidian/workspace.json`, `.obsidian/workspace-mobile.json`, `.DS_Store`, `.claude/settings.local.json`, `.smart-env/`, `.trash/`. Copy spec and plan into `docs/`.

- [ ] **Step 4: Run check → PASS (exit 0)**

- [ ] **Step 5: Commit** — `git add -A && git commit -m "chore: repo skeleton + check script"` (this repo is fresh; `-A` is fine here only).

### Task 2: MANIFESTO · CLAUDE.md · AGENTS.md

**Files:**
- Create: `MANIFESTO.md`, `CLAUDE.md`, `AGENTS.md`, `99.Meta/rules/{frontmatter,wikilink,blank-line,human-ai-layers,growth-path}.md` (growth-path body is filled in Task 8; create with heading only here)
- Modify: `99.Meta/scripts/check.sh` (add `check_system_files`)

**Interfaces:**
- Produces: `CLAUDE.md` with H2 sections in this exact order: `철학 (요약)` · `규칙 8` (the eight rules of spec §6, numbered, each ≤ 2 lines) · `폴더` · `커맨드` (`/onboard` `/map` `/weekly` `/seeds` + kit list) · `긴 규칙은 99.Meta/rules/ 를 Read`. No `@` import lines. `AGENTS.md` = same body, header says "Codex/Cursor 용 미러".

- [ ] **Step 1: Add `check_system_files`** — asserts: all three files exist; `grep -c '^@' CLAUDE.md` = 0; `MANIFESTO.md` contains the verbatim English sentence; CLAUDE.md contains the strings `[!ai]`, `explored`, `리버스 프롬프팅`, `30일`; body of CLAUDE.md after the first H1 equals body of AGENTS.md after its first H1 (`diff <(sed '1,/^# /d' CLAUDE.md) <(sed '1,/^# /d' AGENTS.md)`); every `99.Meta/rules/*.md` parses as a markdown file with no frontmatter required.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write the files.** MANIFESTO: spec §1 philosophy (영민's sentences verbatim) + the five-type reverse-prompting list from §6-3. CLAUDE.md inline rules = spec §6 rules 1–8 compressed; `99.Meta/rules/*` = the long versions, each derived from the current vault's rule of the same name cut to ≤ 60 lines, `human-ai-layers.md` new (rules 1–4 expanded with the `[!ai]` callout syntax: `> [!ai] 🤖` first line, suggestion/question/link-candidate only).
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add MANIFESTO.md CLAUDE.md AGENTS.md 99.Meta && git commit -m "feat: manifesto, CLAUDE/AGENTS, long rules"`

### Task 3: Core notes and templates

**Files:**
- Create: `0.Map_of_Contents/🏛 나.md`, `00.Inbox/README.md`, `99.Meta/templates/{나,씨앗,데일리,위클리,프로젝트,취향}.md`
- Modify: `check.sh` (add `check_templates`)

**Interfaces:**
- Produces: template frontmatter contract — `type:` one of `me|seed|note|daily|weekly|project|taste`, `created: <% tp.file.creation_date("YYYY-MM-DD") %>`, `description: ""`, `tags: []`. `🏛 나.md` body headings: `누구인가` · `무엇을 하는가` · `지금 국면 (분기마다 갱신)` · `취향` · `금지어·싫은 것`. 위클리 template ends with a `> [!ai] 🤖 이번 주 질문 3개` callout containing three empty `- ` lines and the sentence "답은 손으로 쓴다".

- [ ] **Step 1: Add `check_templates`** — asserts: each template's frontmatter parses (`ruby -ryaml` on the block between the first two `---`, after replacing `<% … %>` with `X`); `description:` value starts with `"`; `type:` ∈ allowed set; 위클리 contains `[!ai]` and `질문 3개`; `🏛 나.md` has the five headings; no template contains `move file` or `GWTH:`.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write the notes and templates.** `🏛 나.md` is the blank form (spec §12: no personal sample). `00.Inbox/README.md`: one paragraph — "일주일에 한 번 비운다", QuickAdd 가 여기로 떨어뜨린다, AI 는 옮기지 않는다.
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git commit -am "feat: core notes and templates"` (plus `git add` new files)

### Task 4: `.obsidian/` — plugins, theme, settings, licenses

**Files:**
- Create: `.obsidian/{app.json,appearance.json,core-plugins.json,community-plugins.json,hotkeys.json}`, `.obsidian/plugins/<12 ids>/{main.js,manifest.json,styles.css?,data.json}`, `.obsidian/themes/Velocity/`, `.obsidian/snippets/gwth-velocity.css`, `99.Meta/LICENSES.md`
- Modify: `check.sh` (add `check_obsidian`)

**Interfaces:**
- Consumes: plugin binaries copied from `/Users/young/Obsidian Sync/Growth_Bridge_/.obsidian/plugins/<id>/` (same versions 영민 runs); theme from `.obsidian/themes/Velocity/`; snippet from `gb-velocity-design-snippet.css` with personal identifiers removed.
- Produces: `community-plugins.json` = the 12 ids **minus** `realclaudian`; `core-plugins.json` enables `bases properties daily-notes templates backlink canvas outline bookmarks`; `appearance.json` `cssTheme: "Velocity"`, `enabledCssSnippets: ["gwth-velocity"]`, no font family keys; `gwth-velocity.css` also styles the AI callout: `.callout[data-callout="ai"]` with a distinct left border color and the 🤖 icon (spec §11); Periodic Notes `data.json` folders `02.Daily`, formats `YYYY-MM-DD`/`YYYY-[W]ww`, templates `99.Meta/templates/데일리.md`/`위클리.md`; QuickAdd: two choices "씨앗 → 01.Fleeting" (template 씨앗) and "캡처 → 00.Inbox"; Templater: templates folder `99.Meta/templates`, `trigger_on_file_creation: true` (폴더 템플릿과 Periodic Notes 템플릿의 `<% %>` 치환이 이 설정에 달려 있다 — 최종 리뷰에서 정정), `enable_system_commands: false`.

- [ ] **Step 1: Add `check_obsidian`** — asserts: `community-plugins.json` is exactly the 11-id set (sorted compare); each of the 12 plugin dirs has `manifest.json`; `realclaudian` dir exists but id absent from enabled list; `workspace.json` absent; `grep -ril 'Growth_Bridge\|영민\|young' .obsidian/snippets .obsidian/plugins/*/data.json` is empty; `grep -c 'data-callout="ai"' .obsidian/snippets/gwth-velocity.css` ≥ 1; `LICENSES.md` lists 12 plugin ids + Velocity + cmds-llm-wiki with a license string each (no `TODO`).
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Copy and configure.** Read each plugin's `manifest.json`/LICENSE in the source vault or its GitHub repo to fill `LICENSES.md`; if any plugin or the theme is not redistributable, remove its folder, keep the id in a `99.Meta/INSTALL-MANUALLY.md` list, and make the check accept that list. Smart Connections `data.json`: local embedding model default, no API keys.
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add .obsidian 99.Meta && git commit -m "feat: obsidian config, 12 plugins, Velocity theme, licenses"`

### Task 5: Profiles, MOC skeletons, Bases boards

**Files:**
- Create: `99.Meta/profiles/{daily,projects,knowledge,ai}.md`, `99.Meta/templates/moc-{하루,프로젝트,지식,위키}.md`, `99.Meta/bases/{자라는 씨앗.base,최근 연결.base}`
- Modify: `check.sh` (add `check_profiles`)

**Interfaces:**
- Produces: each profile file has exactly these H2s: `목적` · `더해지는 폴더` (bullet list of folder names — the source of truth `/onboard` reads) · `템플릿·설정` · `MOC 골격` (wikilink to its `moc-*.md`) · `손으로 적용하는 법` (≤ 5 steps). `ai.md` additionally: `사전 준비` (Claude Code CLI + 구독, Git Bash on Windows, `qmd`·Node 선택) and the line "`realclaudian` 을 켠다".
- Bases: `자라는 씨앗.base` filters `01.Fleeting`+`03.Notes`, columns 노트·type·links count·created, view sorted by link count; `최근 연결.base` lists notes modified in 7 days with backlink count, formula `file.backlinks.map(value.asFile())` pattern.

- [ ] **Step 1: Add `check_profiles`** — asserts: four profile files with the five H2s in order; folder names listed in `더해지는 폴더` match spec §4 table exactly (`02.Daily` / `10.Projects 20.Areas 30.Resources 40.Archives` / `03.Notes` / `50.Wiki`); each `moc-*.md` exists and parses; both `.base` files parse as YAML and contain `views:`.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write the files.** MOC skeletons: H1 + a `> [!ai] 🤖` note "이 지도는 /map 이 제안하고 사람이 승인한다" + empty sections (하루: 이번 주·이번 달·반복되는 것 / 프로젝트: 진행 중·대기·끝남 / 지식: 자라는 씨앗 보드 임베드·취향 / 위키: Explored 보드 임베드·최근 ingest).
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add 99.Meta && git commit -m "feat: four purpose profiles, MOC skeletons, Bases boards"`

### Task 6: Originality commands — `/onboard` `/map` `/weekly` `/seeds`

**Files:**
- Create: `.claude/commands/{onboard,map,weekly,seeds}.md`
- Modify: `check.sh` (add `check_commands`)

**Interfaces:**
- Produces: each command file has frontmatter `description:` (quoted) and `argument-hint:`. `onboard.md` steps: read `99.Meta/profiles/*.md` → ask the three spec §5 questions → create only missing folders (idempotent, state it) → write answers 2·3 verbatim into `01.Fleeting/<answer-title>.md` and `0.Map_of_Contents/🏛 나.md` first paragraph **only if that paragraph is empty** → copy the profile's `moc-*.md` into `0.Map_of_Contents/📖 <name>.md` if absent → if `ai` profile: tell the user to enable `realclaudian` and list 사전 준비. `map.md`: proposes MOC edits as a diff in chat, writes only after the user says yes. `weekly.md`: reads this week's `02.Daily/*`, `01.Fleeting/*` changed this week, and `🏛 나.md`; outputs exactly three questions chosen from the five reverse-prompting types (말하지 않은 전제 · 끊긴 논리 · 감정만/사실만 · 판단 없는 사실 · 예전 노트와의 모순), appends them into the weekly note's `[!ai]` callout, never writes answers. `seeds.md`: the mothership `99. Meta/Obsidian Settings/commands/seeds.md` shortened to ≤ 40 lines, paths `01.Fleeting` → report to `00.Inbox/YYYY-MM-DD-seeds.md`.

- [ ] **Step 1: Add `check_commands`** — asserts: four files with quoted `description:`; `onboard.md` contains `99.Meta/profiles`, `덮어쓰지`, `비어 있을 때만`; `weekly.md` contains all five type keywords and `답은 손으로`; `map.md` contains `승인`; `seeds.md` ≤ 40 lines and contains `이동·삭제는 하지 않는다`.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write the four commands.**
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add .claude/commands && git commit -m "feat: onboard, map, weekly (reverse prompting), seeds commands"`

### Task 7: LLM Wiki kit import (`50.Wiki/` + root `.claude/`)

**Files:**
- Create: `50.Wiki/` (kit tree minus `90. Settings/94. Agent Settings/`, `90. Settings/Scripts/setup-agent-links.*`, `.claude/`, `.codex/`, `.agents/`, `.obsidian/`, `docs/`, `index-brutalist.html`, `assets/`), `.claude/commands/{ingest,query,lint,verify,status,reindex,refresh-context,inbox,capture-tabs,audit}.md`, `.claude/hooks/{qmd-reindex.sh,validate-raw-source.sh,validate-frontmatter.sh}`, `.claude/settings.json`, `99.Meta/KIT-CHANGES.md`, `50.Wiki/20. Wiki/24. Maps/Explored 학습 보드.base` (from the kit, with `date created` → `created` only if the kit's templates are also switched — **decision: keep the kit's `date created`** inside `50.Wiki/` to avoid touching kit templates; the human layer uses `created`. Record in KIT-CHANGES.)
- Modify: `check.sh` (add `check_kit`), `.gitignore` (add `50.Wiki/.smtcmp*`)

**Interfaces:**
- Consumes: kit source `/private/tmp/claude-501/-Users-young-Obsidian-Sync-Growth-Bridge-/9f64a78f-8c45-46ab-949b-7d696249b091/scratchpad/up-wiki/cmds-llm-wiki/` (commit `9a4f6e2`; re-clone `https://github.com/johnfkoo951/cmds-llm-wiki.git` at that commit if the scratchpad is gone).
- Produces: kit commands with every vault path prefixed `50.Wiki/` (`00. Inbox` `10. Raw Sources` `20. Wiki` `30. Queries` `40. Paper Analyses` `70. Outputs` `80. References` `90. Settings` `index.md` `log.md` `Core Context.md` `CLAUDE.md` references); hooks with first-line guards `command -v qmd >/dev/null 2>&1 || exit 0` (reindex) and `command -v python3 >/dev/null 2>&1 || exit 0` (validate-frontmatter; validate-raw-source uses python3 too → same guard) and path checks adjusted to `*"/50.Wiki/10. Raw Sources/"*`; `.claude/settings.json` PostToolUse hooks as in the kit with `"$CLAUDE_PROJECT_DIR"` quoted; `50.Wiki/Core Context.md` = one paragraph pointing to `../0.Map_of_Contents/🏛 나.md` + the kit's placeholder sections; `50.Wiki/CLAUDE.md` top line: attribution + "이 볼트에서는 루트 `.claude/` 의 커맨드를 쓴다".

- [ ] **Step 1: Add `check_kit`** — asserts: `50.Wiki/CLAUDE.md` exists and contains `cmds-llm-wiki` and `v1.13.0`; no `.claude|.codex|.agents|94. Agent Settings` under `50.Wiki/`; for each kit command in root `.claude/commands/`, `grep -nE '(^|[^/.])(00\. Inbox|10\. Raw Sources|20\. Wiki|30\. Queries|90\. Settings)/' ` finds no line lacking a `50.Wiki/` prefix (regex: lines matching the folder but not `50.Wiki/` → fail); hooks: `PATH=/usr/bin:/bin env -i HOME=$HOME bash -c 'echo "{}" | bash .claude/hooks/qmd-reindex.sh'` exits 0 (no qmd in that PATH), same for the two validate hooks with a payload pointing at a real `50.Wiki/10. Raw Sources/` file; `settings.json` parses with `python3 -I -m json.tool` and contains `"$CLAUDE_PROJECT_DIR"/`; `KIT-CHANGES.md` lists every modified kit file (compare `diff -rq` kit source vs `50.Wiki/` + root command/hook names → every differing file name appears in KIT-CHANGES).
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Vendor the kit and apply the edits.** Use `sed` for the prefixing, then read every command once to catch prose paths the regex missed. Write `KIT-CHANGES.md` from the `diff -rq` output.
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add 50.Wiki .claude 99.Meta/KIT-CHANGES.md .gitignore && git commit -m "feat: vendor cmds-llm-wiki v1.13.0 under 50.Wiki with root commands/hooks"`

### Task 8: Growth path + split script

**Files:**
- Create: `99.Meta/scripts/split-wiki.sh`, `99.Meta/scripts/split-wiki.ps1`
- Modify: `99.Meta/rules/growth-path.md` (fill spec §9 table + the multi-device symlink procedure, copied from the current vault's `directory-structure.md` 점폴더 정책 and reduced to 10 lines), `check.sh` (add `check_split`)

**Interfaces:**
- Produces: `split-wiki.sh <target-dir>` — copies `50.Wiki/` to `<target-dir>/` as a new vault root, copies the kit commands/hooks from root `.claude/` into `<target-dir>/.claude/` **removing the `50.Wiki/` prefix**, writes `<target-dir>/.claude/settings.json`, leaves `0.Map_of_Contents/📖 위키.md` with an `obsidian://advanced-uri?vault=<basename>&filepath=index.md` link and writes the reverse link into `<target-dir>/Core Context.md`; refuses if target exists; `--dry-run` prints the plan. `.ps1` does the same with `Copy-Item`.

- [ ] **Step 1: Add `check_split`** — runs `bash 99.Meta/scripts/split-wiki.sh "$(mktemp -d)/wiki-test"` then asserts: target has `CLAUDE.md`, `.claude/commands/ingest.md` with zero `50.Wiki/` occurrences, `.claude/settings.json`; source repo unchanged (`git status --porcelain` empty except the 📖 위키.md link when present); running twice → second run exits non-zero with "exists"; `split-wiki.ps1` exists and `grep -c 'Copy-Item'` ≥ 1; `growth-path.md` has the 6-stage table.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write both scripts and the growth-path doc.**
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git add 99.Meta && git commit -m "feat: growth path doc and split-wiki scripts"`

### Task 9: README (onboarding, 60-minute walk, prompts)

**Files:**
- Modify: `README.md` (replace stub), `check.sh` (add `check_readme`)

**Interfaces:**
- Produces: README H2s in order: `이 볼트는` (3 sentences + manifesto link) · `시작하기` (`git clone`, open in Obsidian, trust plugins, Windows note: Git for Windows) · `왜 옵시디언을 쓰나요? — 온보딩 3문항` (the spec §5 questions, each answer → which profile doc) · `60분 걸어보기` (spec §10 steps 1–7, step 7 marked 준비된 사람만) · `준비된 사람용 — AI 층` (Claude Code CLI + 구독, Claudian 켜기, Git Bash, `qmd`·Node 선택, Smart Connections 첫 실행 모델 다운로드 안내) · `플러그인과 테마` (12 + Velocity, Things 2 대안 한 줄) · `AI 없이 쓰는 프롬프트` (the four commands' bodies condensed into copy-paste prompts) · `출처` (cmds-llm-wiki · cmds-system-files · 영민).

- [ ] **Step 1: Add `check_readme`** — asserts: the eight H2s present in order; every `99.Meta/profiles/*.md` and `MANIFESTO.md` linked from README exists (`grep -o '99.Meta/[^) ]*' README.md` → each path exists); README contains `Things 2`, `Git for Windows`, `Smart Connections`; the attribution strings `cmds-llm-wiki` and `YohanKoo`.
- [ ] **Step 2: Run check → FAIL**
- [ ] **Step 3: Write the README.**
- [ ] **Step 4: Run check → PASS**
- [ ] **Step 5: Commit** — `git commit -am "docs: README with onboarding, 60-minute walk, prompts"`

### Task 10: Clone test, Obsidian smoke test, tag

**Files:**
- Modify: `check.sh` (add `check_clone` guarded by `$1 == --full`), `README.md` only if the smoke test finds a wrong step

- [ ] **Step 1: Add `check_clone --full`** — `git clone --quiet /Users/young/DEV/gwth-essence "$(mktemp -d)/clone"` then in the clone: `bash 99.Meta/scripts/check.sh` exits 0; `find . -type l` empty; `git ls-files | grep -c workspace.json` = 0; `git ls-files | wc -l` ≤ 1500 (guards against accidental `node_modules`/`.smart-env`).
- [ ] **Step 2: Run `bash 99.Meta/scripts/check.sh --full` → PASS**
- [ ] **Step 3: Obsidian smoke test (manual, 영민 or executor on this Mac)** — open the clone as a vault: Velocity on, Notebook Navigator shows the 4 folders, open `🏛 나.md`, run QuickAdd "씨앗" once, open `99.Meta/bases/자라는 씨앗.base` → the seed appears; then enable Claudian and run `/onboard` **twice** → second run creates nothing new (Review Focus 4). Record results in `docs/smoke-test.md` (date, Obsidian version, what failed).
- [ ] **Step 4: Fix anything the smoke test broke, re-run `check.sh --full`.**
- [ ] **Step 5: Commit and tag** — `git commit -am "test: clone + smoke test" && git tag v0.1.0`. Repo creation on GitHub and push are 영민's step (repo name undecided — working name `gwth-essence`).

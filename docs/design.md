---
GWTH:
  - "[[102.50 지식관리 pkm]]"
index:
  - "[[🏷 Analysis Notes(A@)]]"
AIauthor:
  - Claude(Fable 5.1)
description: "Design document for the shareable 'essence' vault (GitHub template, lecture-ready): philosophy, common core folders + purpose profiles chosen at onboarding, AI-composed Map of Contents, LLM Wiki zone for prepared users, human-read gate, Windows-safe layout without symlinks, growth path to satellite vaults. Plan the build from this without going back to 영민."
created: 2026-11-12
updated: 2026-11-12
status: 🖨️ 초안 작성
tags:
  - 지식관리/볼트설계
  - 프로젝트/공유볼트
---
# 공유용 에센스 볼트 — 설계 문서 (v2, 2026-11-12)

문서 성격: 설계 정본. 빌더가 이 문서만 읽고 계획을 세울 수 있어야 한다. "영민의 결정" 은 대화에서 확정된 것, "제 결정" 은 제가 정한 기본값이다 (영민이 뒤집을 수 있다). v1(저자 층 폴더 안)은 이 문서로 대체됐다.

## 1. 의도와 이유

영민이 `Growth_Bridge_` 와 위성 LLM Wiki 4개를 1년 넘게 운영하며 몸으로 확인한 것을, **옵시디언을 처음 여는 사람**이 하루 안에 따라 할 수 있는 볼트 하나로 압축한다. GitHub 저장소로 공유하고 (`git clone`), 강의에서도 쓴다.

받는 사람은 세 가지 앞에서 멈춰 있다 — 폴더를 어떻게 나눌지, 플러그인은 뭘 깔지, 테마는 뭘 고를지. 이 볼트는 그 셋을 **정답이 이미 들어 있어 고민이 사라지는** 상태로 넘긴다. 그가 실제로 원하는 것은 네 가지다: 중요한 것을 남기고, 취향과 지식을 남기고, 일상을 유용하게 기록하고, 그것들이 연결되고 찾아지는 것. 다만 사람마다 옵시디언을 쓰는 **이유가 다르므로**, 볼트는 하나의 구조를 강요하지 않고 **이유를 묻는 온보딩**으로 시작한다 (영민의 결정).

### 철학 (영민의 말 — 선언문에 그대로 들어간다)
- 지식이 AI를 거치며 **평균으로 수렴**하는 시대에, 볼트의 첫 번째 일은 **자신의 고유성을 지키는 것**이다. 몸으로 쓴 글, 논리적·순차적으로 흐르지 않는 진짜 사람의 생각, 그 "살아 있는 주름"을 그대로 남긴다.
- 두 번째 일은 그 고유성 위에서 **AI에게 나의 맥락을 최대한 잘 전달해 나를 확장하는 second brain** 이 되는 것이다. 순서가 중요하다 — 고유성이 먼저, 확장은 그 위에.
- 선언문 원문: *"A real person whose ideas don't always cascade in the logical, sequential style served up by AI."*
- 영민의 볼트에서 확인된 선순환: 데일리 노트(몸으로 쓴 글) → AI 가 그것을 Core Context 로 읽고 지식을 확장(LLM Wiki) → 확장된 지식이 다시 사람의 글에 참조된다.

## 2. 목표 · 비목표 · 안티골

**목표**
- 처음 쓰는 사람이 **첫날 한 시간** 안에 "남기기 → 연결 → 찾기"를 한 번 경험하고, AI 를 연결한 사람은 **첫 주 안에 선순환을 한 바퀴** 경험한다 (데일리/씨앗에 손으로 쓰고 → AI 가 확장하고 → 사람이 읽고 → 다음 글에서 참조).
- 사람과 AI 가 **같은 문서 세트**(README · MANIFESTO · CLAUDE.md)를 읽는다. AI 가 없어도 볼트는 완결된다.
- 목적이 다른 사람들이 **같은 코어에서 다른 모양으로** 자라고, 커지면 AI 층을 위성 볼트로 떼어낼 수 있다.

**비목표** (넣지 않는다)
- 할 일 관리 체계 (Tasks·Operon·Morgen 등 — 사람마다 달라 볼트가 정하지 않는다)
- 숫자 taxonomy(`GWTH:`), 🏷 인덱스 노트 체계, 클라이언트 업무 구조, 발행 파이프라인 — 현재 볼트의 복잡도
- Dataview (내장 Bases 로 대체)
- 저장소 안의 symlink (Windows 포함이므로 — §4)

**안티골** (영민의 말: "AI 만 일하는 상황")
- **AI 만 문서를 확인하는 상황**이 되면 실패다 (예: Pulse 처럼 AI 가 쓰고 AI 만 읽는 브리핑). 모든 AI 산출물에는 사람이 읽는 접점이 있어야 하고, 사람이 읽지 않은 AI 산출물은 지식이 아니라 **후보**다 (§6-2).
- 사람이 쓴 글을 AI 가 "정리"하면서 주름을 펴 버리는 것. 데일리·Fleeting 본문은 교정 대상이 아니다.

## 3. 제약 (영민의 결정)
- 대상: 옵시디언 첫 사용자. **Windows 사용자 포함.** macOS 와 Windows 에서 `git clone` 직후 열리면 동작해야 한다.
- 모두에게 공통인 폴더는 `0.Map_of_Contents` · `00.Inbox` · `01.Fleeting` 세 개. 그 외는 목적에 따라 더한다.
- AI 층은 **준비된 사람용**이다 (Claude Code CLI + 구독이 있는 사람). 없어도 볼트의 나머지는 전부 동작한다. `qmd`·Node 가 없으면 킷 훅은 **조용히 건너뛴다**.
- AI 층은 **CMDS LLM Wiki 스타터킷(`cmds-llm-wiki`, 2026-11 기준 v1.13.0)의 규칙을 그대로** 쓴다. 영민의 originality 는 코어·온보딩·규칙(§6)에 들어간다.
- AI 가 연결되면 `0.Map_of_Contents` 는 **그 사람의 목적에 맞춰 AI 가 구성**한다.
- 배포: GitHub 저장소, `git clone`(또는 "Use this template"). `.obsidian/` 을 플러그인·테마·스니펫까지 포함 (제 결정). 언어: 한국어 본문 + 영어 `description`·선언문.
- Obsidian 1.15+.

## 4. 구조 — 공통 코어 + 목적별 프로파일

폴더 이름에 **공백을 쓰지 않는다** (영민의 명명 관례 `0.Map_of_Contents` 를 따름; Windows 경로·`@import` 모두 안전).

```
<vault>/
├── README.md              사람용: 시작 안내 + 온보딩 질문 + 60분 걸어보기
├── MANIFESTO.md           철학 선언문 (사람·AI 공통)
├── CLAUDE.md              AI 규칙 — 짧은 규칙은 인라인, 긴 판은 99.Meta/rules/ 를 Read 하라고 지시
├── AGENTS.md              CLAUDE.md 미러 (Codex 등)
├── 0.Map_of_Contents/     지도. 첫 노트 `🏛 나.md` = 손으로 쓴 자화상 (AI 의 1차 Core Context)
├── 00.Inbox/              캡처 (QuickAdd 목적지, Web Clipper 착륙)
├── 01.Fleeting/           씨앗·짧은 생각 — 몸으로 쓴 글의 첫 자리 (하위 폴더 없음)
├── 99.Meta/               templates/ · rules/ · profiles/ · bases/ · snippets/ · scripts/
└── .claude/ .obsidian/    실제 파일 (symlink 없음)
```

### 코어 폴더의 역할
- `0.Map_of_Contents/` — `🏛 나.md`(누구인가·무엇을 하는가·지금 국면·취향·금지어 — 한 쪽)가 뿌리. 온보딩 뒤 프로파일별 MOC(`📖 하루.md` · `📖 프로젝트.md` · `📖 지식.md` · `📖 위키.md`)가 더해진다. AI 가 있으면 `/onboard` 가 이 폴더를 **그 사람 목적에 맞춰 구성**하고, 이후 `/map` 이 링크 수·최근 변경을 보고 갱신을 제안한다(사람이 승인). 이것이 이전 안의 `2 Me/`(손으로 쓴 Core Context)가 들어온 자리다.
- `00.Inbox/` — 무엇이든 먼저 떨어지는 곳. 처리 기준은 한 줄: "일주일에 한 번 비운다". AI 는 여기 파일을 읽을 수는 있어도 옮기지 않는다.
- `01.Fleeting/` — 제목만 있어도 된다. `type: seed`(제목/몇 줄) · `type: note`(자란 글)를 속성으로 구분. 씨앗은 백로그이지 결함이 아니다 (`/seeds` 월 1회, §6-5).

### 프로파일 (온보딩에서 고른다 — 복수 선택 가능, 영민의 결정)

| 목적 | 더해지는 폴더 | 더해지는 설정·템플릿 | MOC |
|------|---------------|----------------------|-----|
| **하루하루 기록** | `02.Daily/` (`YYYY-MM-DD.md`, 위클리 `YYYY-Www.md`) | Periodic Notes·Calendar 설정, 데일리·위클리 템플릿 (§6-3 AI 질문 3개 포함) | `📖 하루.md` |
| **프로젝트** | PARA — `10.Projects/` · `20.Areas/` · `30.Resources/` · `40.Archives/` | 프로젝트 템플릿(목적·성공 기준·다음 단계 한 쪽), 완료 시 Archives 이동 규칙 | `📖 프로젝트.md` |
| **지식·취향 쌓기** | `03.Notes/` (flat) | 취향 노트·레퍼런스 노트 템플릿, Bases 보드 `자라는 씨앗`·`최근 연결` | `📖 지식.md` |
| **AI 로 확장** (준비된 사람) | `50.Wiki/` = CMDS LLM Wiki 킷 (`00. Inbox`·`10. Raw Sources`·`20. Wiki`·`30. Queries`·`90. Settings`·`CLAUDE.md`) | Claudian, `/ingest`·`/query`·`/verify`·`/lint`, Explored 학습 보드 | `📖 위키.md` |

- 프로파일 정의는 `99.Meta/profiles/<이름>.md` 한 장씩: 폴더 목록 · 템플릿 · 플러그인 설정 · MOC 골격 · "손으로 적용하는 법" 5줄. **AI 가 있는 사람**은 `/onboard` 가 이 문서를 읽고 적용하고, **AI 가 없는 사람**은 README 의 같은 질문을 읽고 이 문서대로 손으로 만든다 — 같은 결과, 다른 입구.
- 프로파일은 나중에 더할 수 있다 (예: 독서·강의 노트). 코어는 바뀌지 않는다.
- 숫자 접두어는 정렬용이다: 0·00·01 코어 → 02·03 사람 층 → 10~40 PARA → 50 AI 층 → 99 메타.

### Windows 포함에 따른 레이아웃 (제 결정)
- 저장소에 **symlink 를 두지 않는다.** `git clone` 이 점폴더를 그대로 가져오므로 `.claude/commands/`·`.claude/hooks/`·`.claude/rules/` 는 실제 파일로 커밋한다. (현재 볼트의 "점폴더 symlink" 정책은 Obsidian Sync 로 다기기 운영할 때의 이야기이고, 이 볼트는 git 으로 배포된다. 받는 사람이 다기기 Sync 를 시작하면 그때의 절차를 `99.Meta/rules/growth-path.md` 에 적는다.)
- 규칙은 `CLAUDE.md` 에 **인라인**(초보용, 현재 볼트 규칙의 1/3 분량). 긴 판 `99.Meta/rules/*.md` 는 `CLAUDE.md` 가 "필요할 때 Read" 로 가리킨다 (`@import` 불사용).
- LLM Wiki 킷의 커맨드·훅은 **볼트 루트 `.claude/` 에 실제 파일로** 둔다 (Claude Code 는 프로젝트 루트의 `.claude/` 만 읽는다). 킷의 `90. Settings/94. Agent Settings/` 와 symlink 스크립트는 **동봉하지 않는다**. `50.Wiki/CLAUDE.md` 는 그 폴더 파일을 다룰 때 Claude Code 가 자동으로 함께 읽는다.
- 킷 훅은 첫머리에 `command -v qmd >/dev/null 2>&1 || exit 0`(reindex) · `command -v python3 >/dev/null 2>&1 || exit 0`(validate) 를 넣어 도구가 없으면 조용히 종료한다. Windows 에서 훅은 Git Bash 로 실행되며(Claude Code 요구사항), README "준비된 사람용" 절에 그 한 줄을 적는다.
- 위성 분리는 `99.Meta/scripts/split-wiki.sh`(+ `.ps1`) 한 번: `50.Wiki/` 를 새 볼트로 옮기고, 루트 `.claude/` 의 킷 커맨드·훅을 그 볼트로 복사하고, 양쪽에 Advanced URI 링크 한 쌍을 남긴다.

## 5. 온보딩 (README 와 `/onboard` 가 같은 질문)

1. **왜 옵시디언을 쓰려 하나요?** — 하루하루 기록 / 프로젝트 / 지식·취향 쌓기 / AI 로 확장 (여러 개 가능)
2. **지금 가장 먼저 남기고 싶은 것 하나는?** — 답이 첫 씨앗이 된다 (`01.Fleeting/`)
3. **나를 한 문단으로 쓴다면?** — 답이 `0.Map_of_Contents/🏛 나.md` 의 첫 단락이 된다

AI 가 있으면 `/onboard` 가 1번 답으로 프로파일을 적용하고 2·3번 답을 해당 노트에 **그대로**(교정 없이) 넣은 뒤 `0.Map_of_Contents` 를 구성한다. AI 가 없으면 README 가 같은 세 질문을 보여 주고 `99.Meta/profiles/` 로 안내한다.

## 6. 핵심 규칙 (영민의 originality — `CLAUDE.md` 인라인 + `MANIFESTO.md`)

1. **사람 층 / AI 층** — `00.Inbox`·`01.Fleeting`·`02.Daily`·`03.Notes`·PARA 폴더의 본문은 사람만 쓴다. AI 는 그 노트 안에서 `> [!ai]` 콜아웃(🤖)으로만 말을 보탠다 — 제안·질문·연결 후보. 본문 교정·요약·재배열 금지. AI 가 본문을 쓰는 곳은 `50.Wiki/` 와 `0.Map_of_Contents/📖 *.md` 뿐이다. (영민의 성서모임 실험 — 사람 = 본문, AI = 🤖 콜아웃 — 을 일반 규칙으로 올린 것)
2. **사람-읽음 게이트** — `50.Wiki/` 의 AI 산출물은 킷 속성 `explored: false` 로 태어나고(화면 라벨 "읽음"), 사람이 읽고 체크해야 `true` 가 된다. 읽지 않은 페이지는 사람 층 노트에서 링크하지 않도록 템플릿이 안내한다. Explored 학습 보드가 이 게이트의 화면이다.
3. **AI 는 묻고, 사람은 쓴다 — 리버스 프롬프팅** (영민의 결정) — AI 의 기본 동사는 "쓰다"가 아니라 "묻다"다. 사람이 쓴 글을 읽고 **사람이 놓친 것을 역으로 질문**한다: 말하지 않은 전제, 끊긴 논리의 빈칸, 감정만 있고 사실이 없는 곳, 반대로 사실만 있고 판단이 없는 곳, 예전 노트와 모순되는 곳. 질문은 답을 끌어내는 것이지 고치는 것이 아니다. 자리: 위클리 템플릿의 **질문 3개**(이번 주 데일리·씨앗과 `🏛 나.md` 를 읽고), `/onboard` 의 후속 질문, 사람 층 노트의 `> [!ai]` 콜아웃. 답은 사람이 손으로 쓴다. `/weekly` 커맨드 본문에 이 질문 유형 5가지를 규칙으로 둔다.
4. **AI 만 읽는 자동화 금지** — 사람이 읽는 접점이 없는 정기 작업은 만들지 않는다. 자동화 산출물에는 `explored` 게이트를 달고, 30일 동안 아무도 읽지 않으면 그 자동화를 멈춘다.
5. **씨앗은 백로그** — 제목만 있는 노트를 정리 대상으로 보지 않는다. `/seeds`(월 1회)가 씨앗/잔해/How-to 로 가르고 글감을 제안하되 이동·삭제는 사람이 한다.
6. **맥락 전달 = `🏛 나.md`** — AI 는 어떤 작업이든 이 노트를 먼저 읽는다. 사람은 분기마다 "지금 국면" 단락을 갱신한다. 선순환의 입구.
7. **지도는 AI 가 그리되 사람이 승인** — `0.Map_of_Contents/📖 *.md` 는 `/map` 이 제안하고 사람이 승인한 뒤에만 바뀐다. `🏛 나.md` 는 사람만 쓴다.
8. **속성은 다섯 개까지** — `type` · `created` · `description`(선택, 영어) · `tags`(선택) · `explored`(AI 층만). AI 가 쓴 파일은 `AIauthor`. 그 외는 사용자가 필요할 때 더한다. 값에 `: ` 가 들면 큰따옴표, YAML 2-space, 프론트매터 위에는 아무것도 넣지 않는다 — 이 세 줄이 인라인 규칙의 전부에 가깝다.

## 7. 플러그인 · 테마 · 설정 (영민의 결정)

| 범주 | 항목 | 역할 |
|------|------|------|
| 찾기 | Omnisearch | 전문 검색 |
| AI 층 | Claudian | Claude Code 가 볼트를 작업 폴더로 삼음 (준비된 사람용 — 설치돼 있어도 CLI 없으면 조용히 비활성) |
| 주름 | Excalidraw | 순차적이지 않은 생각을 그대로 남기는 자리 |
| 탐색 | Notebook Navigator | 폴더 고민을 없애는 탐색기 |
| 테마 | Style Settings | 테마 조정 |
| 데일리 | Templater + Periodic Notes + Calendar | "하루하루 기록" 프로파일의 중심. 다른 프로파일에서도 Templater 는 쓰인다 |
| 캡처 | QuickAdd | `00.Inbox`·`01.Fleeting` 로 한 번에 |
| 연결 | Smart Connections | 쓰는 동안 비슷한 과거 노트를 옆에 띄움 (사람이 연결을 발견) |
| 연결 | Strange New Worlds | 링크 수 표시 — 자라는 생각이 보임 |
| 확장 | Advanced URI | 위성 분리 때 볼트 간 링크의 전제 |

- 내장 기능 우선: Properties · **Bases** · Canvas · 백링크 · Daily notes · Web Clipper(외부 앱).
- 테마: **Velocity** 기본 + 영민의 `gb-velocity-design-snippet`(개인 식별 요소 제거). README 에 Things 2 를 대안으로 한 줄. Velocity(`Gonzalo-D-Sales/obsidian-velocity`)와 플러그인 10종의 라이선스를 빌더가 확인해 `99.Meta/LICENSES.md` 에 적고, 동봉 불가한 것은 README 설치 안내로 대체.
- `.obsidian/` 포함 범위: `community-plugins.json` · `appearance.json` · `core-plugins.json` · `plugins/*` · `themes/*` · `snippets/*`. `workspace.json` 제외. Periodic Notes·Calendar·Smart Connections 설정은 프로파일 적용 전에도 무해한 기본값으로.

## 8. AI 층 상세 (`50.Wiki/`, 준비된 사람용)
- 킷 원본을 `50.Wiki/` 아래에 두고 `Core Context.md` 는 킷 placeholder 대신 "`../0.Map_of_Contents/🏛 나.md` 를 읽어라" 한 줄로 가리킨다. 킷 README 는 "템플릿 — 자유롭게 fork·복제" 를 허용한다. 출처(cmds-llm-wiki · @YohanKoo · v1.13.0)를 README 와 `50.Wiki/CLAUDE.md` 상단에 한 줄 남기고, `index`·`log` 는 킷 placeholder 관례를 따른다.
- 루트 `.claude/commands/` 에 킷 커맨드(`ingest`·`query`·`lint`·`verify`·`status`·`reindex`·`refresh-context`·`inbox`·`capture-tabs`·`audit`)와 이 볼트의 커맨드(`onboard`·`map`·`seeds`·`weekly`)가 함께 있다. 킷 커맨드 안의 경로(`10. Raw Sources/` 등)는 `50.Wiki/` 접두를 붙여 고친다 — 킷 수정은 이 접두와 §4 의 훅 두 줄뿐이며, 어디를 고쳤는지 `99.Meta/KIT-CHANGES.md` 에 적는다.
- `/onboard` · `/map` · `/weekly` · `/seeds` 는 이 볼트의 originality 커맨드다 (`.claude/commands/`, Claudian 슬래시 커맨드로 노출 — 제 결정). AI 가 없는 사람을 위해 같은 내용을 README 끝에 "복사해 쓰는 프롬프트" 로도 둔다.

## 9. 성장 경로 (`99.Meta/rules/growth-path.md` 한 문서)

| 단계 | 신호 | 무엇을 하나 |
|------|------|------|
| 0 — 시작 | clone 직후 | README 온보딩 3문항 + 60분 걸어보기 |
| 1 — 한 바퀴 | 씨앗 5개 · (AI 층) Wiki 3페이지 | 위클리에서 AI 질문 3개에 답하기 |
| 2 — 분류 등장 | `01.Fleeting`+`03.Notes` 100개 | 폴더 추가 대신 `tags`·Bases 보드. `/map` 으로 지도 갱신 |
| 3 — 다기기 | 두 번째 기기 | Obsidian Sync 켜기 + 점폴더 정책(그때 symlink 절차 안내) |
| 4 — 위성 분리 | `50.Wiki/` 300페이지 또는 검색이 느려짐 | `split-wiki.sh`, `🏛 나.md` 를 위성 Core Context 로 복사 |
| 5 — 다중 위성 | 도메인별 위키 | 현재 영민 체제 |

## 10. README 의 60분 걸어보기 (강의 동선)

1. (5분) 볼트를 열고 테마가 켜져 있는 것을 확인 — 고를 것이 없음을 느낀다.
2. (10분) 온보딩 3문항에 답한다 (AI 있으면 `/onboard`, 없으면 손으로).
3. (10분) `01.Fleeting/` 에 **손으로 다섯 줄** 쓴다. 틀려도 두서없어도 된다 — 주름이 목적.
4. (10분) `🏛 나.md` 를 쓴다 — AI 가 있든 없든 이 볼트의 뿌리.
5. (10분) 선택한 프로파일의 첫 노트 하나 (오늘 데일리 / 프로젝트 한 장 / 취향 노트 한 장).
6. (10분) 연결과 찾기 — Smart Connections 패널에서 비슷한 노트를 하나 링크하고, Omnisearch 로 다시 찾는다.
7. (5분, 준비된 사람만) Claudian 에서 씨앗 하나를 `/ingest` — `explored: false` 로 온 결과를 읽고 체크한다. 한 바퀴.

## 11. 빌더에게 맡기는 것
- 템플릿(데일리·위클리·씨앗·프로젝트·취향·`🏛 나`)의 실제 문구와 Templater 식.
- `99.Meta/profiles/*.md` 4장과 `/onboard`·`/map`·`/weekly`·`/seeds` 커맨드 본문 (`/weekly` 는 §6-3 의 리버스 프롬프팅 질문 유형 5가지를 포함) (`/seeds` 는 현재 볼트 `99. Meta/Obsidian Settings/commands/seeds.md` 를 초보용으로 줄여 쓴다).
- Bases 보드 2~3개 공식 (현재 위성의 `Explored 학습 보드.base` 를 단순화 — `file.backlinks.map(value.asFile())` 패턴 유지).
- `CLAUDE.md`·`AGENTS.md`·`MANIFESTO.md`·`99.Meta/rules/*.md` 문장. 현재 볼트 규칙(indentation · frontmatter · wikilink · blank-line · mermaid)을 초보용 1/3 분량으로.
- `> [!ai]` 콜아웃 스타일(스니펫)과 아이콘. 스니펫에서 영민 개인 식별 요소 제거.
- `split-wiki.sh/.ps1`, `LICENSES.md`, `KIT-CHANGES.md`.
- 저장소 이름 — 작업명 "GWTH Essence" (영민이 바꿀 수 있음).

## 12. 제 결정 목록 (영민이 확인할 것)
- 저장소에 symlink 없음, 규칙 인라인, 킷 커맨드·훅을 루트 `.claude/` 실파일로 — §4.
- 사람-읽음 게이트 속성은 새 이름 대신 킷의 `explored` — §6-2.
- `🏛 나.md` 가 `0.Map_of_Contents/` 의 뿌리이자 AI Core Context (이전 안 `2 Me/` 의 대체) — §4·§6-6.
- 프로파일 복수 선택 가능, 숫자 접두어 배치(02·03·10~40·50) — §4.
- `.obsidian/` 통째 동봉, Velocity 기본 — §7.
- `/onboard`·`/map`·`/weekly`·`/seeds` 를 Claudian 슬래시 커맨드로 노출 + README 프롬프트 병행 — §8.
- `🏛 나.md` 샘플은 **빈 양식** 으로 동봉하고, 영민 본인 예시는 강의 자료로 따로 둔다 (저장소에 개인 정보 없음).
- 공개 범위는 public 을 전제로 썼다 (수강생 한정이면 README 문구만 바뀐다).

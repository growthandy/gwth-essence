# GWTH Essence — 몸으로 쓴 글이 먼저인 옵시디언 볼트

> *"A real person whose ideas don't always cascade in the logical, sequential style served up by AI."*

## 이 볼트는
옵시디언을 처음 여는 사람을 위한 볼트다. 폴더 세 개로 시작하고, **왜 쓰는지**에 따라 자란다. 지식이 AI 를 거치며 평균으로 수렴하는 시대에 **자신의 고유성을 먼저 지키고**, 그 위에서 AI 로 자신을 확장하는 second brain 을 목표로 한다. 철학 전문은 [MANIFESTO.md](MANIFESTO.md), AI 를 위한 규칙은 [CLAUDE.md](CLAUDE.md).

## 시작하기
1. `git clone https://github.com/<you>/gwth-essence.git` (또는 GitHub 의 "Use this template" 로 내 저장소를 만든 뒤 clone).
2. Obsidian → "볼트 열기" → clone 한 폴더. 커뮤니티 플러그인 신뢰 여부를 물으면 **신뢰**(플러그인·테마가 미리 들어 있다 — 목록은 아래).
3. 테마(Velocity)와 플러그인은 이미 켜져 있다. 고를 것이 없다.
4. Windows: `git clone` 은 그대로 되며 symlink 가 없어 풀릴 것도 없다. AI 층(아래 "준비된 사람용")을 쓰려면 **Git for Windows**(Git Bash)가 필요하다.

## 왜 옵시디언을 쓰나요? — 온보딩 3문항
답에 따라 폴더와 템플릿이 더해진다. 여러 개 골라도 된다. AI 를 연결했다면 Claudian 에서 `/onboard` 를 치면 같은 질문을 하고 대신 만들어 준다.

| 1. 왜 쓰려 하나요? | 더해지는 것 | 손으로 하려면 |
|---|---|---|
| 하루하루 기록 | `02.Daily/` + 데일리·위클리 템플릿 + 달력 | [99.Meta/profiles/daily.md](99.Meta/profiles/daily.md) |
| 프로젝트 | PARA 네 폴더 + 프로젝트 템플릿 | [99.Meta/profiles/projects.md](99.Meta/profiles/projects.md) |
| 지식·취향 쌓기 | `03.Notes/` + 취향 템플릿 + 보드 2개 | [99.Meta/profiles/knowledge.md](99.Meta/profiles/knowledge.md) |
| AI 로 확장 (준비된 사람) | `50.Wiki/` (이미 들어 있음) + Claudian | [99.Meta/profiles/ai.md](99.Meta/profiles/ai.md) |

2. **지금 가장 먼저 남기고 싶은 것 하나는?** → `01.Fleeting/` 에 그 제목으로 노트 하나. 제목만 있어도 된다.
3. **나를 한 문단으로 쓴다면?** → `0.Map_of_Contents/🏛 나.md` 의 첫 단락. 이 노트는 사람만 쓰고, AI 는 어떤 일이든 이것을 먼저 읽는다.

## 준비된 사람용 — AI 층
- 필요한 것: **Claude Code CLI** + Anthropic 구독(또는 API 키). 없으면 이 절은 건너뛰어도 볼트는 전부 동작한다.
- 켜기: 설정 → 커뮤니티 플러그인 → **Claudian** 활성화 (설치돼 있고 꺼져 있다). Windows 는 Git for Windows 먼저.
- 선택: `qmd`(검색 색인)·Node — 없으면 재색인 훅이 조용히 건너뛴다.
- **Smart Connections** 는 첫 실행 때 로컬 임베딩 모델을 한 번 내려받는다(수십 MB). 그동안 패널이 비어 있어도 정상이다.
- 커맨드: `/onboard` `/map` `/weekly` `/seeds`(이 볼트) · `/ingest` `/query` `/lint` `/verify` `/status`(킷). 전부 `.claude/commands/` 에 있다.
- AI 가 만든 페이지는 `explored: false` 로 시작한다. **읽은 것만 지식이다** — `50.Wiki/20. Wiki/24. Maps/Explored 학습 보드.base` 에서 체크한다. 규칙 전문: [99.Meta/rules/human-ai-layers.md](99.Meta/rules/human-ai-layers.md).

## 플러그인과 테마
Omnisearch(찾기) · Claudian(AI, 기본 꺼짐) · Excalidraw(그림·비선형 생각) · Notebook Navigator(탐색) · Style Settings · Templater + Periodic Notes + Calendar(데일리) · QuickAdd(캡처) · Smart Connections(연결 발견) · Strange New Worlds(링크 수) · Advanced URI(나중에 위성 볼트 연결). 테마는 **Velocity**. 다른 느낌을 원하면 **Things 2** 테마가 같은 Style Settings 로 잘 맞는다. 라이선스는 [99.Meta/LICENSES.md](99.Meta/LICENSES.md).

## AI 없이 쓰는 프롬프트
Claudian 이 없어도 ChatGPT·Claude 웹에 노트를 붙여 넣고 아래를 쓰면 같은 일이 된다.
- **위클리 질문 3개**: "아래는 이번 주 내 데일리 노트와 자화상이다. 요약하지 말고, 내가 놓친 것을 되묻는 질문을 딱 3개만 — 말하지 않은 전제, 끊긴 논리, 감정만/사실만 있는 곳, 판단 없는 사실, 예전 글과의 모순 중 서로 다른 유형으로. 답은 내가 쓴다."
- **씨앗 수확**: "아래는 제목만 있는 노트 목록이다. 씨앗(자랄 것) / 잔해(끝난 일의 흔적) / How-to(다시 쓸 절차)로 가르고, 씨앗은 묶어서 묶음마다 공통 질문 한 문장과 글감 1~2개를 제안해라. 옮기거나 지우라고 하지 마라."
- **지도 제안**: "아래 노트 목록으로 '📖 지식' 지도를 고치자고 제안만 해라. 어느 절에 무엇을 더하고 빼는지, 왜 그런지 한 줄씩. 내가 승인한 것만 쓴다."
- **온보딩**: "나는 옵시디언을 (하루 기록/프로젝트/지식·취향/AI 확장) 때문에 쓰려 한다. [99.Meta/profiles/](99.Meta/profiles/daily.md) 문서대로 만들 폴더와 첫 노트를 순서대로 알려 달라. 이미 있는 것은 건드리지 마라."

## 출처
- AI 층 킷: [cmds-llm-wiki](https://github.com/johnfkoo951/cmds-llm-wiki) v1.13.0 — [@YohanKoo](https://x.com/YohanKoo) (CMDSPACE). 바뀐 곳은 [99.Meta/KIT-CHANGES.md](99.Meta/KIT-CHANGES.md).
- 모선 패턴: [cmds-system-files](https://github.com/johnfkoo951/cmds-system-files) 의 규칙에서 초보용으로 줄였다.
- 철학·설계: 영민 (GWTH Bridge) — `Growth_Bridge_` 볼트와 위성 LLM Wiki 4개를 운영하며 확인한 것을 압축했다. 설계 문서는 [docs/design.md](docs/design.md).
- 저장소 라이선스 MIT. 동봉 구성요소는 각자의 라이선스 (`99.Meta/LICENSES.md`).

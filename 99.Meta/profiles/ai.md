# 프로파일 · AI 로 확장 (준비된 사람용)

## 목적
손으로 쓴 씨앗을 AI 가 조사·확장해 위키로 쌓고, 그 위키를 사람이 읽어 다시 글로 돌아오는 **선순환**을 돌리고 싶은 사람. AI 층은 `50.Wiki/` 한 폴더이고, 안의 규칙은 CMDS LLM Wiki 킷(cmds-llm-wiki v1.13.0)을 그대로 쓴다.

## 사전 준비
- **Claude Code CLI** 와 Anthropic 구독(또는 API 키) — 없으면 이 프로파일은 동작하지 않는다. 나머지 볼트는 이것 없이도 전부 쓸 수 있다.
- Claudian 플러그인을 켠다: 설정 → 커뮤니티 플러그인 → **Claudian**(`realclaudian`) 활성화. 설치는 돼 있고 꺼져 있다.
- Windows: Claude Code 가 요구하는 **Git for Windows**(Git Bash). 훅은 bash 로 돈다.
- 선택: `qmd`(검색 색인)와 Node — 없으면 재색인 훅이 조용히 건너뛴다. 없어도 `/ingest`·`/query` 는 된다.
- Smart Connections 는 첫 실행 때 로컬 임베딩 모델을 내려받는다(수십 MB, 한 번).

## 더해지는 폴더
- `50.Wiki`

## 템플릿·설정
- `50.Wiki/` 는 저장소에 이미 들어 있다 (킷 구조: `00. Inbox` `10. Raw Sources` `20. Wiki` `30. Queries` `90. Settings` + 자기 `CLAUDE.md`). 온보딩이 하는 일은 Claudian 을 켜고 `50.Wiki/Core Context.md` 가 `🏛 나.md` 를 가리키는지 확인하는 것뿐이다.
- 커맨드(Claudian 안에서): `/ingest`(씨앗·URL·파일 → 위키) · `/query`(질문 → 답과 출처) · `/lint`(건강 점검) · `/verify`(페이지 검증) · `/status`
- 읽음 게이트: AI 가 만든 페이지는 `explored: false`. `50.Wiki/20. Wiki/24. Maps/Explored 학습 보드.base` 에서 읽은 것을 체크한다. 읽은 것만 사람 층에서 링크한다.
- 이 볼트의 커맨드도 Claudian 에서 쓴다: `/onboard` `/map` `/weekly` `/seeds`

## MOC 골격
[[moc-위키]] → `0.Map_of_Contents/📖 위키.md` (Explored 보드 임베드 · 최근 ingest · 자주 묻는 것)

## 손으로 적용하는 법
1. Claude Code 를 설치하고 로그인한다 (`claude` 명령이 터미널에서 뜨면 된다).
2. 설정 → 커뮤니티 플러그인에서 Claudian 을 켠다. 왼쪽 리본에 Claudian 아이콘이 생긴다.
3. Claudian 을 열고 `/onboard` 를 친다 — 질문 세 개에 답하면 나머지를 해 준다.
4. `01.Fleeting/` 의 씨앗 하나를 골라 Claudian 에 "`/ingest` 이 씨앗을 조사해 줘" 라고 한다. 결과는 `50.Wiki/20. Wiki/` 에 `explored: false` 로 생긴다.
5. 읽고, 보드에서 체크하고, 내일 데일리에 링크한다 — 한 바퀴.

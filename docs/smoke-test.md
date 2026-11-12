# Smoke test — Obsidian 에서 직접 여는 확인

자동 검사(`bash 99.Meta/scripts/check.sh --full`)는 2026-11-12 통과(162 ok). 아래는 Obsidian GUI 에서만 확인할 수 있는 항목이라 사람이 한 번 돈다. 결과를 이 표에 적는다. **2026-11-12 Obsidian 1.15.0(macOS)에서 1~5·7·8 통과, 6은 보류.** 첫 열기 때 Obsidian 이 `.obsidian/*.json` 과 `.base` 를 정규화해 다시 썼고(설정값 변화 없음), 그 결과를 저장소에 반영했다. 실행 방식: Advanced URI(`obsidian://advanced-uri?vault=gwth-essence&commandid=…`)로 커맨드를 호출하고 Orca computer-use 로 모달 버튼을 눌렀다.

| # | 확인 | 기대 | 결과 (날짜 · Obsidian 버전) |
|---|------|------|------|
| 1 | clone 폴더를 볼트로 열기 → 플러그인 신뢰 | Velocity 테마, 왼쪽에 Notebook Navigator, 폴더 4개(0·00·01·99) + 50.Wiki | 2026-11-12 · 1.15.0 · ✓ 신뢰 대화상자 → Velocity · Notebook Navigator · 폴더 5개(코어 4 + 50.Wiki). Excalidraw·Notebook Navigator 환영 모달 2개가 첫 실행에 뜬다(닫으면 끝) |
| 2 | `0.Map_of_Contents/🏛 나.md` 열기 | 다섯 절이 보이고 속성 패널에 type/created/description/tags | ✓ 다섯 절 + 속성 4개(type/created/description/tags) |
| 3 | 리본 QuickAdd → "씨앗 → 01.Fleeting" 로 노트 하나 | 씨앗 템플릿이 적용된 노트가 `01.Fleeting/` 에 생김 | ✓ `quickadd:choice:gwth-seed` → 이름 입력 → `01.Fleeting/테스트 씨앗.md`, `<% %>` 치환 0 잔존 |
| 4 | `99.Meta/bases/자라는 씨앗.base` 열기 | 방금 만든 씨앗이 "📝 제목만 있는 씨앗" 뷰에 보임 | ✓ `🌱 자라는 씨앗` 1개 결과 (방금 만든 씨앗) |
| 5 | 달력에서 오늘 클릭 (하루 기록 프로파일 적용 후) | `02.Daily/YYYY-MM-DD.md` 가 열리고 속성 패널에 **실제 날짜**(`<% %>` 아님)가 보임 | ✓ `02.Daily/2026-11-12.md` 생성, 속성 `created: 2026-11-12`, 템플릿 식 잔존 0 (Periodic Notes `open-daily-note` 로 실행 — 달력 클릭과 같은 경로) |
| 6 | Claudian 켜고 `/onboard` 두 번 | 두 번째 실행은 "이미 있음" 만 보고하고 새로 만드는 것이 없음 | 미실행 — Claude Code 구독이 있는 기기에서 영민이 확인 |
| 7 | Smart Connections 첫 실행 | 모델 다운로드 안내 후 패널에 비슷한 노트 표시 | ✓ 로드됨 (상태바 Smart v3.1.1, `.smart-env/` 생성). 모델 다운로드 프롬프트는 뜨지 않았고 패널은 열지 않음 |
| 8 | `50.Wiki/20. Wiki/24. Maps/Explored 학습 보드.base` 열기 | 오류 없이 열림. `/ingest` 로 페이지 하나 만든 뒤 그 페이지가 📖 주제별 대기열에 보임 | ✓ 킷 샘플 14페이지가 주제 영역(MOC 미연결 · Knowledge Management · LLM Wiki Guide)으로 그룹돼 보임 — `50.Wiki/` 접두 수정이 맞았음 |

실패한 항목은 `docs/plan.md` Task 10 의 Step 4 대로 고치고 `check.sh --full` 을 다시 돌린다.

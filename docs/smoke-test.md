# Smoke test — Obsidian 에서 직접 여는 확인

자동 검사(`bash 99.Meta/scripts/check.sh --full`)는 2026-11-12 통과(162 ok). 아래는 Obsidian GUI 에서만 확인할 수 있는 항목이라 사람이 한 번 돈다. 결과를 이 표에 적는다.

| # | 확인 | 기대 | 결과 (날짜 · Obsidian 버전) |
|---|------|------|------|
| 1 | clone 폴더를 볼트로 열기 → 플러그인 신뢰 | Velocity 테마, 왼쪽에 Notebook Navigator, 폴더 4개(0·00·01·99) + 50.Wiki | |
| 2 | `0.Map_of_Contents/🏛 나.md` 열기 | 다섯 절이 보이고 속성 패널에 type/created/description/tags | |
| 3 | 리본 QuickAdd → "씨앗 → 01.Fleeting" 로 노트 하나 | 씨앗 템플릿이 적용된 노트가 `01.Fleeting/` 에 생김 | |
| 4 | `99.Meta/bases/자라는 씨앗.base` 열기 | 방금 만든 씨앗이 "📝 제목만 있는 씨앗" 뷰에 보임 | |
| 5 | 달력에서 오늘 클릭 (하루 기록 프로파일 적용 후) | `02.Daily/YYYY-MM-DD.md` 가 열리고 속성 패널에 **실제 날짜**(`<% %>` 아님)가 보임 | |
| 6 | Claudian 켜고 `/onboard` 두 번 | 두 번째 실행은 "이미 있음" 만 보고하고 새로 만드는 것이 없음 | |
| 7 | Smart Connections 첫 실행 | 모델 다운로드 안내 후 패널에 비슷한 노트 표시 | |
| 8 | `50.Wiki/20. Wiki/24. Maps/Explored 학습 보드.base` 열기 | 오류 없이 열림. `/ingest` 로 페이지 하나 만든 뒤 그 페이지가 📖 주제별 대기열에 보임 | |

실패한 항목은 `docs/plan.md` Task 10 의 Step 4 대로 고치고 `check.sh --full` 을 다시 돌린다.

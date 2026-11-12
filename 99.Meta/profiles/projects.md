# 프로파일 · 프로젝트

## 목적
끝이 있는 일을 여러 개 돌리는 사람. PARA(Projects · Areas · Resources · Archives)의 네 폴더만 쓴다 — 진행 중인 것, 계속 돌보는 영역, 참고 자료, 끝난 것. 분류 고민은 "끝이 있나?" 하나로 끝난다.

## 더해지는 폴더
- `10.Projects`
- `20.Areas`
- `30.Resources`
- `40.Archives`

## 템플릿·설정
- 프로젝트: `99.Meta/templates/프로젝트.md` — 왜 하나 · 끝의 모습 · 다음 한 걸음 · 기록
- 프로젝트 하나 = `10.Projects/<이름>.md` 한 장. 자료가 많아지면 `10.Projects/<이름>/` 폴더로 바꾸고 그 안에 같은 이름의 대표 노트를 둔다.
- 끝나면 `40.Archives/` 로 옮긴다 (옮기기 전 "끝의 모습" 옆에 실제 결과 한 줄).
- 할 일 관리 플러그인은 넣지 않았다. 체크박스(`- [ ]`)로 시작하고, 필요해지면 그때 고른다.

## MOC 골격
[[moc-프로젝트]] → `0.Map_of_Contents/📖 프로젝트.md` (진행 중 · 대기 · 끝남)

## 손으로 적용하는 법
1. 루트에 `10.Projects` `20.Areas` `30.Resources` `40.Archives` 네 폴더를 만든다.
2. 지금 돌리는 일 하나를 `10.Projects/<이름>.md` 로 만들고 Templater(`Alt+E` 또는 명령 팔레트 "Templater: Open insert template modal")로 `프로젝트` 템플릿을 넣는다.
3. "끝의 모습"을 한 줄이라도 쓴다 — 이것이 없는 프로젝트는 Areas 다.
4. `99.Meta/templates/moc-프로젝트.md` 를 `0.Map_of_Contents/📖 프로젝트.md` 로 복사하고 그 노트를 링크한다.
5. 끝난 프로젝트는 `40.Archives/` 로 끌어다 놓는다 — 링크는 Obsidian 이 따라온다.

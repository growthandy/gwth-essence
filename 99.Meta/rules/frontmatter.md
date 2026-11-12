# frontmatter — 속성과 YAML

노트 맨 위 `---` 사이가 속성(프론트매터)이다. 이 볼트는 속성을 **다섯 개까지만** 쓴다.

## 속성

| 속성 | 값 | 누가 |
|------|------|------|
| `type` | `seed` `note` `daily` `weekly` `project` `taste` `me` `moc` (AI 층: 킷의 `raw-source` `wiki-page` `query-result` `moc`) | 템플릿이 넣는다 |
| `created` | `YYYY-MM-DD` | 템플릿이 넣는다 |
| `description` | 영어 1~2문장, **항상 큰따옴표** `"..."` | 선택. AI 가 노트를 찾을 때 쓰는 힌트 |
| `tags` | 배열 `- 태그` (한글 가능, 숫자만인 값 금지) | 선택 |
| `explored` | `true` / `false` — AI 층(`50.Wiki/`)에서만 | AI 가 `false` 로 만들고, 사람이 읽고 `true` 로 |

AI 가 본문을 쓴 파일에는 `AIauthor:` 배열을 더한다 (예: `- Claude(Opus 5)`).

## YAML 규칙 (이것만 지키면 깨지지 않는다)
1. 들여쓰기는 **스페이스 2칸** (탭 금지).
2. 값에 `: ` 나 ` #` 이 들어가면 **큰따옴표**로 감싼다. `description` 은 무조건.
3. 배열은 `- 값` 한 줄에 하나.
4. 날짜는 `YYYY-MM-DD`.
5. **여는 `---` 위에는 아무것도 넣지 않는다.** "문서 맨 위에 추가해" 는 닫는 `---` 아래 본문 첫 줄을 뜻한다. 위에 한 줄이라도 들어가면 속성 패널이 통째로 사라진다.
6. 본문을 고치면서 속성을 건드리지 않는다 (의도된 갱신만).
7. 숫자만으로 된 태그(`- 22`)는 속성 패널을 깨뜨린다. 본문의 `#22` 같은 번호는 백틱으로 감싼다.

## 예
```yaml
---
type: seed
created: 2026-11-12
description: "Seed note: why my mornings feel shorter on project days."
tags:
  - 일상
---
```

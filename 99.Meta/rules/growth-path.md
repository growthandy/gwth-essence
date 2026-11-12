# growth-path — 커졌을 때

볼트는 세 폴더에서 시작해 이유에 따라 자란다. 아래 신호가 보이면 그 단계의 일을 한다. 단계를 건너뛰어도 되고, 안 가도 된다.

| 단계 | 신호 | 무엇을 하나 |
|------|------|------|
| 0 — 시작 | clone 직후 | `README.md` 의 온보딩 3문항 + 60분 걸어보기 |
| 1 — 한 바퀴 | 씨앗 5개 · (AI 층) Wiki 3페이지 | 위클리에서 AI 질문 3개에 손으로 답하기 |
| 2 — 분류 등장 | `01.Fleeting` + `03.Notes` 100개 | 폴더를 더하지 말고 `tags` 와 Bases 보드로 가른다. `/map` 으로 지도 갱신 |
| 3 — 다기기 | 두 번째 기기 | Obsidian Sync 켜기 + 아래 점폴더 정책 |
| 4 — 위성 분리 | `50.Wiki/` 300페이지 또는 검색이 느려짐 | `99.Meta/scripts/split-wiki.sh`(Windows: `.ps1`) 한 번 |
| 5 — 다중 위성 | 도메인별 위키가 필요 | 위성을 하나 더 만든다 (각 위성은 자기 Core Context 로 `🏛 나.md` 를 가리킨다) |

## 3단계 — 다기기와 점폴더
Obsidian Sync 는 `.obsidian` 을 뺀 점폴더(`.claude` `.git` 등)를 동기화하지 않는다. 그래서:
1. 이 저장소는 **git 으로** 기기 사이를 오간다 — 점폴더도 git 이 옮긴다. Sync 와 git 을 같이 쓰면 노트는 Sync 가, `.claude/` 는 git 이 맡는다.
2. `.claude/settings.local.json` 처럼 기기 전용 파일은 `.gitignore` 에 있다. 토큰·세션 기록이 든 파일을 Sync 나 rsync 로 복사하지 않는다.
3. Obsidian Sync 는 `.sh` 의 실행 권한을 떨어뜨린다. git 으로 받으면 권한이 유지되고, Sync 로만 받았다면 `chmod +x .claude/hooks/*.sh` 한 번.
4. 점폴더를 symlink 로 두는 방식(설정 정본을 일반 폴더에 두고 기기마다 링크)은 Windows 에서 풀리므로 이 볼트는 쓰지 않는다. macOS 만 쓴다면 cmds-llm-wiki v1.12.0 의 `setup-agent-links.sh` 패턴을 참고할 수 있다.

## 4단계 — 위성 분리
```bash
bash 99.Meta/scripts/split-wiki.sh ~/Vaults/my-wiki --dry-run   # 무엇을 할지 본다
bash 99.Meta/scripts/split-wiki.sh ~/Vaults/my-wiki             # 실행
```
스크립트는 `50.Wiki/` 를 새 볼트 루트로 복사하고, 킷 커맨드·훅을 `50.Wiki/` 접두 없이 새 볼트 `.claude/` 에 넣고, 새 볼트 `Core Context.md` 끝에 이 볼트의 `🏛 나.md` 로 가는 `obsidian://advanced-uri` 링크를 남긴다. 이 볼트 쪽 링크는 화면에 출력되니 `0.Map_of_Contents/📖 위키.md` 에 붙여 넣는다. 새 볼트가 열리는 것을 확인한 뒤에만 `50.Wiki/` 를 지운다. 두 볼트 모두 Advanced URI 플러그인이 있어야 링크가 열린다 — 없으면 `obsidian://open?vault=...&file=...` 로 바꾼다.

# 00-교류: claude와 chatgpt가 이 프로젝트를 주고받는 규칙

두 AI 도구는 서로 대화하지 않고, git 커밋과 이 폴더의 파일로만 변경을 주고받는다.
루트의 `AGENTS.md`(Codex가 읽음)와 `CLAUDE.md`(Claude가 읽음, AGENTS.md를 가리킴)는 이 문서를 가리킨다.

## 구성

| 파일, 폴더 | 무엇 | 누가 고치나 |
|---|---|---|
| `현황.md` | 무엇이 현행이고 다음에 무엇을 하는지. 단일 기준 | 둘 다. 세션 끝에 갱신 |
| `log/YYYY-MM-DD-NN-도구.md` | 세션 기록. 세션마다 파일 하나 | 쓴 쪽만 |
| `claude-to-chatgpt/` | claude가 chatgpt에게 남기는 인계 노트 | claude가 쓰고 chatgpt가 `status`를 바꾼다 |
| `chatgpt-to-claude/` | chatgpt가 claude에게 남기는 인계 노트 | chatgpt가 쓰고 claude가 `status`를 바꾼다 |

## 세션을 시작할 때

1. `git pull --rebase origin main`.
2. `현황.md`를 읽는다.
3. `log/`의 최근 세 파일을 읽는다.
4. 자기 앞으로 온 노트 가운데 `status: 대기`를 읽고 `확인`으로 바꾼 뒤 `read:`에 날짜를 적는다. 요청 사항은 이번 할 일에 넣는다.
5. `git log --oneline -20`.

## 세션을 마칠 때

1. 바꾼 것이 있으면 인계 노트 한 장. 파일명 `YYYY-MM-DD-NN-주제.md`. 양식은 `인계노트-양식.md`.
2. `현황.md` 갱신. 현행 판이 바뀌었으면 반드시.
3. `log/`에 세션 파일 하나. 양식은 `log/README.md`.
4. `[claude]` 또는 `[chatgpt]` 접두 커밋. 몰아서 하지 않고 작업 단위마다 한다.
5. `git push origin main`. 거절되면 pull --rebase 후 다시.

## 충돌을 피하는 규칙

- 같은 {{산출물}}에 두 도구가 동시에 손대지 않는다. `현황.md`의 담당 칸에 적힌 쪽만 고친다. 담당을 바꾸려면 노트에 적고 `현황.md`를 고친다.
- 현행 판의 위치는 `현황.md`에만 적는다. 다른 문서가 어긋나면 `현황.md`가 맞다.
- 새 판은 올리고 지난 판은 `구판/`으로 내린다. 지우지 않는다.
- 사용자 확인 후에만 하는 일: {{금지행위}}. 그 직전 단계까지 준비하고 노트에 적는다.
- 상대가 만든 파일을 지우거나 크게 옮길 때는 먼저 노트로 알린다.

## git 규칙

- 저장소는 프로젝트 루트. 원격은 GitHub private `origin/main`. 기준선 커밋 `{{기준선 해시}}`.
- 브랜치는 `main` 하나. 긴 실험처럼 며칠 걸리는 일만 `exp/이름` 브랜치를 쓰고 끝나면 합친다.
- 20MB 넘는 원자료와 원결과는 폴더에 두되 git에는 넣지 않는다.
- 이력을 고쳐 쓰지 않는다(`rebase -i`, `push --force` 금지). 잘못 커밋했으면 되돌리는 커밋을 새로 만든다.
- 작업 환경이 파일을 못 지워 git이 `index.lock`이나 `objects/*/tmp_obj_*`에 걸리면 사용자에게 삭제 권한을 요청한 뒤 지우고 다시 한다.
- 각 도구의 git identity: claude는 `user.name=claude`, chatgpt는 `user.name=chatgpt`. 커밋 접두와 함께 `git log --author`로 거를 수 있게 한다.

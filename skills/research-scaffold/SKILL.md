---
name: research-scaffold
description: 논문 한 편을 GitHub private 저장소 하나와 claude·chatgpt 교류 규약으로 관리하는 연구 프로젝트를 새로 만들거나 기존 폴더에 입힐 때, 또는 00-교류/log/가 있는 프로젝트에서 세션을 시작하고 끝낼 때 사용
---

# 연구 프로젝트 스캐폴드

논문 한 편을 저장소 하나로 관리한다. 원고, 교류 기록, 코드, 자료, 결과를 한 저장소에 두고 claude와 chatgpt(Codex)가 번갈아 고친다. 기준은 GitHub `main`이고 맥 폴더와 각 도구의 클라우드 작업 공간은 모두 클론이다. 투고용 artifact는 `code/`만 새 이력으로 뽑는다.

정본은 사용자 컴퓨터의 `~/Projects/research-ops/scaffold/`다. 이 스킬의 끝에 같은 틀 전체를 담아 두었으므로, 그 폴더에 닿지 않는 세션에서도 복원해 쓸 수 있다. 두 곳이 어긋나면 정본이 맞고, 이 스킬을 정본에 맞춰 고친다.

## 언제 쓰나

- 사용자가 새 연구, 새 논문, 새 프로젝트 폴더를 만들어 달라고 할 때 → **만들기**.
- 이미 있는 연구 폴더에 이 구조를 입혀 달라고 할 때 → **만들기**에서 `--existing`.
- 프로젝트 루트에 `00-교류/log/`가 있을 때 → **세션 절차**. 사용자가 말하지 않아도 따른다. 옛 규약(`00-교류/LOG.md` 한 파일)만 있는 프로젝트는 ai-exchange-protocol 스킬을 따른다.

## 만들기

### 1. 값 정하기

| 인자 | 뜻 | 예 |
|---|---|---|
| 폴더경로 | 만들 곳 | `~/Projects/my-study` |
| 프로젝트명 | 저장소 이름, 소문자 | `my-study` |
| 한 줄 설명 | 폴더가 무엇인지 | `어느 측정 연구의 학회 논문` |
| 산출물 단위 | 담당을 나누는 단위 | `원고` (기본) |
| 금지행위 | 사용자 확인 없이 하면 안 되는 일 | `실험 실행` (기본) |

대화에서 정해지지 않은 값만 묻는다. 산출물과 금지행위는 기본값을 쓰고 그렇게 했다고 말한다.

### 2. 실행할 곳

- 사용자 컴퓨터의 shell(`device_bash`)이 있고 `~/Projects`가 연결돼 있으면 거기서 정본을 돌린다.
  ```
  SCAFFOLD_PUSH=n "$HOME/mnt/Projects/research-ops/scaffold/new-project.sh" "$HOME/mnt/Projects/<폴더>" <이름> "<설명>" 원고 "실험 실행" [--existing]
  ```
- shell이 없거나 정본에 닿지 않으면 클라우드 작업 공간에 아래 "틀 전체"를 경로대로 써서 복원하고 거기서 돌린 뒤, 결과 파일을 `device_commit_files`로 사용자 폴더에 쓴다. `.git`은 옮기지 않는다. 파일명의 `{{오늘}}`은 복원할 때 그대로 둔다. 스크립트가 바꾼다. `.gitkeep`은 빈 파일이다.
- 에이전트가 돌릴 때는 늘 `SCAFFOLD_PUSH=n`. 원격 저장소 생성과 push는 사용자 몫이다.

### 3. 뒤처리

1. 스크립트 출력의 `.scaffold` 파일(이미 있던 `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitignore`와 겹친 것)을 기존 파일과 손으로 합치고 지운다. 기존 내용을 버리지 않는다.
2. `00-교류/현황.md`의 산출물 표, `docs/승인기록.md`, `docs/할일목록.md`, `docs/연구계획.md`를 대화에서 정한 내용으로 채운다. 사용자 결정과 도구 권고를 구별한다.
3. `--existing`이면 첫 로그(`00-교류/log/<오늘>-01-claude.md`)와 첫 인계 노트를 실제로 한 일에 맞게 고친다. 옮긴 파일이 있으면 노트의 "바뀐 파일"에 적는다.
4. 스크립트가 넣은 파일에 `{{`가 남았는지 본다. 기존 파일의 자리표시자는 일부러 둔 것일 수 있으니 건드리지 않는다.
5. 사용자에게 남은 명령을 준다.
   ```
   cd <폴더> && git add -A && git commit -m "[claude] 교류 구조 도입"
   gh repo create <이름> --private --source=. --remote=origin --push
   ```
6. 만든 폴더의 `README.md`를 computer:// 링크로 보인다.

### 하지 않을 것

- 기존 파일에 자리표시자 치환을 하지 않는다. 스크립트도 넣은 파일에만 한다.
- `gh repo create`, `git push`를 하지 않는다.
- 사용자 컴퓨터의 연결 폴더에서 `git commit`을 하지 않는다. 그 환경은 파일 삭제가 막혀 있어 git이 lock 파일에서 멈춘다.

## 세션 절차 (00-교류/log/가 있는 프로젝트)

시작할 때:
1. `git pull --rebase origin main`. 충돌이 나면 상대 것을 살리고 내 것을 다시 적는다.
2. `00-교류/현황.md`. 어느 산출물의 어느 판이 현행이고 누가 맡았는지는 여기가 기준이다.
3. `00-교류/log/`의 최근 세 파일.
4. 자기 앞으로 온 인계 노트 중 `status: 대기`를 읽고 `확인`으로, `read:`에 날짜. 요청은 이번 할 일에 넣는다.
5. `git log --oneline -20`.

끝낼 때:
1. 바꾼 게 있으면 인계 노트 한 장(`claude-to-chatgpt/YYYY-MM-DD-NN-주제.md`).
2. `현황.md` 갱신. 현행 판이 바뀌었으면 반드시.
3. `00-교류/log/YYYY-MM-DD-NN-claude.md` 한 파일.
4. `[claude]` 접두 커밋, 작업 단위마다.
5. `git push origin main`. 거절되면 pull --rebase 뒤 다시. force push는 하지 않는다.

지킬 것: 현황의 담당 칸에 적힌 쪽만 그 산출물을 고친다. 새 판을 올리면 지난 판은 `구판/`으로. 금지행위는 사용자 확인 뒤에만. `.env`, 키 파일, `data/raw/`, `results/raw/`는 커밋하지 않는다. git 이력을 고쳐 쓰지 않는다.

## 틀 전체

정본 `~/Projects/research-ops/scaffold/`의 사본이다. 경로는 스캐폴드 폴더 기준.

### `README.md`

````
# research-scaffold

논문 한 편을 private GitHub 저장소 하나로 관리하면서 Claude와 Codex가 번갈아 변경하도록 만든 연구 프로젝트 틀이다.
원고, 교류 기록, 코드, 자료, 결과를 한 저장소에 두고, 투고용 artifact는 `code/`만 따로 뽑아 낸다.

## 쓰는 법

새 프로젝트:

    ./new-project.sh <폴더경로> <프로젝트명> "<한 줄 설명>" "<산출물 단위>" "<금지행위>"
    예) ./new-project.sh ~/Projects/my-study my-study "어느 측정 연구의 학회 논문" 원고 "실험 실행"

이미 있는 폴더에 입히기:

    ./new-project.sh ~/Projects/old-study old-study "..." 원고 "실험 실행" --existing

`--existing`이면 기존 파일을 덮지 않고 없는 것만 넣는다. `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitignore`가 이미 있으면 `.scaffold`를 붙여 두고 사용자가 합친다. `--existing` 없이 이미 파일이 있는 폴더를 주면 멈춘다.

자리표시자 치환과 파일명의 `{{오늘}}` 바꾸기는 스크립트가 넣은 파일에만 한다. 기존 파일, 특히 일부러 자리표시자를 남겨 둔 양식이나 스킬은 건드리지 않는다.

마지막에 `gh repo create <프로젝트명> --private --source=. --remote=origin --push`를 실행할지 묻는다. `SCAFFOLD_PUSH=y` 또는 `n`으로 미리 정할 수 있고, 터미널이 아닌 곳(에이전트 실행)에서는 묻지 않고 만들지 않는다. 문서에 적을 사용자 이름은 `SCAFFOLD_USER`(기본은 `git config user.name`, 없으면 "사용자").

## 고친 것 (2026-10-15)

- `--existing`에서 치환이 대상 폴더의 모든 `.md`에 걸려 기존 양식의 자리표시자를 덮던 문제. 넣은 파일 목록을 따로 적고 그 목록에만 치환한다.
- 같은 이유로 기존 파일 이름의 `{{오늘}}`까지 바꾸던 문제.
- 새 저장소에서 기준선 해시가 늘 "없음"으로 적히던 것. 첫 커밋을 가리키는 문구로 둔다.
- 터미널이 아닌 곳에서 `read`가 실패해 스크립트가 오류로 끝나던 것.
- 설명에 `|`나 `&`가 있으면 치환이 깨지던 것.
- 자리표시자에 조사가 붙어 있어(`{{산출물}}을`, `{{금지행위}}는`) 기본값 "원고", "실험 실행"에서도 "원고을", "실험 실행는"이 되던 것. 조사가 값에 붙지 않게 문장을 고쳤다.

## 폴더 구조

    AGENTS.md            Codex가 읽는 규칙. CLAUDE.md는 이 파일을 가리킨다
    CLAUDE.md
    .gitignore           비밀값, 가상환경, 원자료, 큰 결과 파일 제외
    .env.example         키 이름만. 실제 값은 .env(커밋 금지)
    README.md            프로젝트 지도
    00-교류/             두 도구의 교류. 현황.md가 단일 진실
      log/               세션마다 파일 하나. 충돌이 나지 않는다
      claude-to-chatgpt/ chatgpt-to-claude/   인계 노트
    docs/                연구계획, 할일목록, 승인기록
    manuscript/          원고. 지난 판은 구판/
    code/                실험 코드. 투고용 artifact는 여기서만 뽑는다
      scripts/export-artifact.sh
    data/                raw는 git 제외, processed는 작은 것만
    results/             raw는 git 제외, summary만 커밋

## 설계 원칙

- 기준은 GitHub main이다. 맥 폴더, Claude 클라우드, Codex 클라우드는 모두 클론이다. 세션은 pull로 시작해 push로 끝낸다.
- 브랜치는 main 하나. 같은 산출물을 동시에 고치지 않는 담당 규칙이 충돌을 막는다.
- LOG는 세션별 파일이다. 한 파일 맨 위에 끼워 넣는 방식은 두 도구가 겹치면 거의 매번 충돌한다.
- 작업 저장소에는 무엇이든 넣는다. 투고용 artifact는 `code/`를 새 이력으로 뽑아 별도 저장소로 낸다. 거기에는 프로젝트 이름과 AI 흔적을 남기지 않는다.
````

### `new-project.sh`

````bash
#!/usr/bin/env bash
# 연구 프로젝트 틀을 새 폴더(또는 기존 폴더)에 입힌다.
#
#   new-project.sh <폴더경로> <프로젝트명> "<한 줄 설명>" ["<산출물 단위>"] ["<금지행위>"] [--existing]
#
# 환경변수
#   SCAFFOLD_USER   문서에 적을 사용자 이름 (기본 git config user.name, 없으면 "사용자")
#   SCAFFOLD_PUSH   y 또는 n. 지정하면 묻지 않는다. 터미널이 아니면 n
#
# 자리표시자 치환과 파일명 바꾸기는 이 스크립트가 넣은 파일에만 한다.
# 기존 파일, 그리고 일부러 자리표시자를 남겨 둔 양식이나 스킬은 건드리지 않는다.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:?폴더경로}"; NAME="${2:?프로젝트명}"; DESC="${3:?한 줄 설명}"
UNIT="${4:-원고}"; FORBID="${5:-실험 실행}"; MODE="${6:-}"
USER_NAME="${SCAFFOLD_USER:-$(git config user.name 2>/dev/null || echo 사용자)}"
TODAY="$(date +%F)"

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
COPIED="$(mktemp)"; trap 'rm -f "$COPIED"' EXIT

# git을 먼저 둔다. 기존 저장소면 지금 HEAD가 기준선이다.
if [ ! -d "$TARGET/.git" ]; then git -C "$TARGET" init -q; fi
if BASE="$(git -C "$TARGET" rev-parse --short HEAD 2>/dev/null)"; then :; else
  BASE="첫 커밋 (git rev-list --max-parents=0 HEAD)"
fi

# 1. 틀의 파일을 옮기고, 옮긴 파일만 목록에 적는다
(cd "$HERE/template" && find . -mindepth 1 \( -type f -o -type d \) | sort) | while IFS= read -r p; do
  src="$HERE/template/$p"; dst="$TARGET/${p#./}"
  if [ -d "$src" ]; then mkdir -p "$dst"; continue; fi
  if [ -e "$dst" ]; then
    if [ "$MODE" = "--existing" ]; then
      case "$p" in
        ./AGENTS.md|./CLAUDE.md|./.gitignore|./README.md)
          cp "$src" "$dst.scaffold"; printf '%s\n' "$dst.scaffold" >> "$COPIED";;
      esac
      continue
    fi
    echo "이미 있음: $dst. 기존 폴더에 입히려면 --existing을 붙인다." >&2
    exit 1
  fi
  mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; printf '%s\n' "$dst" >> "$COPIED"
done

# 2. 옮긴 파일에만 자리표시자를 채운다
esc() { printf '%s' "$1" | sed -e 's/[\\|&]/\\&/g'; }
S_NAME="$(esc "$NAME")"; S_DESC="$(esc "$DESC")"; S_USER="$(esc "$USER_NAME")"
S_UNIT="$(esc "$UNIT")"; S_FORBID="$(esc "$FORBID")"; S_BASE="$(esc "$BASE")"
while IFS= read -r f; do
  case "$f" in *.gitkeep) continue;; esac
  sed -e "s|{{프로젝트명}}|$S_NAME|g" -e "s|{{프로젝트}}|$S_DESC|g" -e "s|{{사용자}}|$S_USER|g" \
      -e "s|{{산출물}}|$S_UNIT|g" -e "s|{{금지행위}}|$S_FORBID|g" -e "s|{{오늘}}|$TODAY|g" \
      -e "s|{{기준선 해시}}|$S_BASE|g" "$f" > "$f.tmp-scaffold"
  cat "$f.tmp-scaffold" > "$f"; rm -f "$f.tmp-scaffold"
done < "$COPIED"

# 3. 옮긴 파일에만 파일명의 날짜 자리표시자를 바꾼다
while IFS= read -r f; do
  case "$(basename "$f")" in
    *'{{오늘}}'*) mv "$f" "$(dirname "$f")/$(basename "$f" | sed "s|{{오늘}}|$TODAY|g")";;
  esac
done < "$COPIED"
[ -f "$TARGET/code/scripts/export-artifact.sh" ] && chmod +x "$TARGET/code/scripts/export-artifact.sh" || true

N="$(wc -l < "$COPIED" | tr -d ' ')"
echo
echo "틀을 입혔다: $TARGET (파일 $N개)"
if grep -q '\.scaffold$' "$COPIED"; then
  echo "기존 파일과 겹쳐 .scaffold로 둔 것 (손으로 합친 뒤 지운다):"
  grep '\.scaffold$' "$COPIED" | sed "s|^$TARGET/|  |"
fi
echo "확인할 것: .env나 키 파일이 .gitignore에 걸리는지, 100MB 넘는 파일이 없는지."
echo "  git -C \"$TARGET\" status --short | head; du -sh \"$TARGET\"/*/ 2>/dev/null"
echo

# 4. 원격 저장소. 묻지 않는 실행에서는 만들지 않는다
yn="${SCAFFOLD_PUSH:-}"
if [ -z "$yn" ]; then
  if [ -t 0 ]; then read -r -p "GitHub private 저장소를 만들고 push할까? [y/N] " yn || yn=N
  else yn=N; fi
fi
if [ "$yn" = "y" ]; then
  cd "$TARGET"
  git add -A && git commit -q -m "[claude] 교류 구조 도입" || true
  gh repo create "$NAME" --private --source=. --remote=origin --push
else
  echo "원격은 만들지 않았다. 나중에:"
  echo "  cd \"$TARGET\" && git add -A && git commit -m \"[claude] 교류 구조 도입\""
  echo "  gh repo create $NAME --private --source=. --remote=origin --push"
fi
````

### `template/.env.example`

````
# 실제 값은 .env에 둔다. .env는 커밋하지 않는다.
OPENROUTER_API_KEY=
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
````

### `template/.gitignore`

````
# 비밀값
.env
.env.*
!.env.example
*.key
*.pem
secrets/

# 환경
__pycache__/
.venv/
node_modules/
.DS_Store
tmp/
_to_delete*/

# 원자료와 큰 결과. 요약만 커밋한다
data/raw/*
!data/raw/.gitkeep
results/raw/*
!results/raw/.gitkeep
*.tar.gz
*.zip
*.parquet
*.sqlite

# 투고용 artifact 작업본
artifact-export/
````

### `template/00-교류/README.md`

````
# 00-교류 — claude와 chatgpt가 이 프로젝트를 주고받는 규칙

두 AI 도구는 서로 대화하지 않는다. git 커밋과 이 폴더의 파일이 유일한 통로다.
루트의 `AGENTS.md`(Codex가 읽음)와 `CLAUDE.md`(Claude가 읽음, AGENTS.md를 가리킴)는 이 문서를 가리킨다.

## 구성

| 파일·폴더 | 무엇 | 누가 고치나 |
|---|---|---|
| `현황.md` | 무엇이 현행이고 다음에 무엇을 하는지. 단일 진실 | 둘 다. 세션 끝에 갱신 |
| `log/YYYY-MM-DD-NN-도구.md` | 세션 대장. 세션마다 파일 하나 | 쓴 쪽만 |
| `claude-to-chatgpt/` | claude가 chatgpt에게 남기는 인계 노트 | claude가 쓰고 chatgpt가 `status`를 바꾼다 |
| `chatgpt-to-claude/` | chatgpt가 claude에게 남기는 인계 노트 | chatgpt가 쓰고 claude가 `status`를 바꾼다 |

## 세션을 시작할 때

1. `git pull --rebase origin main`.
2. `현황.md`를 읽는다.
3. `log/`의 최근 세 파일을 읽는다.
4. 자기 앞으로 온 노트 중 `status: 대기`를 읽고 `확인`으로 바꾸고 `read:`에 날짜를 적는다. 요청 사항은 이번 할 일에 넣는다.
5. `git log --oneline -20`.

## 세션을 마칠 때

1. 바꾼 것이 있으면 인계 노트 한 장. 파일명 `YYYY-MM-DD-NN-주제.md`. 양식은 `인계노트-양식.md`.
2. `현황.md` 갱신. 현행 판이 바뀌었으면 반드시.
3. `log/`에 세션 파일 하나. 양식은 `log/README.md`.
4. `[claude]` 또는 `[chatgpt]` 접두 커밋. 작업 단위마다, 몰아서 하지 않는다.
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
````

### `template/00-교류/chatgpt-to-claude/.gitkeep`

빈 파일.

### `template/00-교류/claude-to-chatgpt/.gitkeep`

빈 파일.

### `template/00-교류/claude-to-chatgpt/{{오늘}}-01-교류구조-도입.md`

````
---
from: claude
to: chatgpt
date: {{오늘}}
commit: 미커밋
status: 대기
read:
---

## 무엇을 했나
저장소 틀과 교류 규약을 도입했다. 규칙은 루트 `AGENTS.md`와 `00-교류/README.md`에 있다. 기준은 GitHub `main`이고, 세션은 `git pull --rebase`로 시작해 `git push`로 끝난다. LOG는 한 파일이 아니라 `00-교류/log/`의 세션별 파일이다.

## 바뀐 파일
- 전체 틀 도입

## 상대에게 요청
- 첫 세션에서 `AGENTS.md`를 읽고 `현황.md`의 담당 칸을 확인할 것.

## 사용자 판단이 필요한 것
- 없음
````

### `template/00-교류/log/.gitkeep`

빈 파일.

### `template/00-교류/log/README.md`

````
# 세션 대장

세션마다 파일 하나. 파일명 `YYYY-MM-DD-NN-도구.md` (NN은 그날의 일련번호, 01부터).
한 파일을 여럿이 고치지 않으므로 병합 충돌이 나지 않는다. 최근 것부터 보려면 `ls -r`.

양식:

    ---
    date: YYYY-MM-DD
    who: claude | chatgpt
    commit: abc1234   # 이 세션의 마지막 커밋. 없으면 "미커밋"
    note: claude-to-chatgpt/YYYY-MM-DD-01-주제.md   # 인계 노트. 없으면 "없음"
    ---
    (한두 줄 요약. 무엇을 했고 다음에 무엇이 남았나)
````

### `template/00-교류/log/{{오늘}}-01-claude.md`

````
---
date: {{오늘}}
who: claude
commit: 미커밋
note: claude-to-chatgpt/{{오늘}}-01-교류구조-도입.md
---
교류 구조와 저장소 틀을 도입했다. GitHub private 원격을 만들고 push하면 그 뒤로는 pull로 시작해 push로 끝낸다.
````

### `template/00-교류/인계노트-양식.md`

````
# 인계 노트 양식

파일명 `YYYY-MM-DD-NN-주제.md`. 보내는 쪽 폴더에 둔다.
받는 쪽은 읽은 뒤 `status`를 `확인`으로, `read:`에 날짜를 적는다. 그 외에는 고치지 않는다.

---
from: (보낸쪽)
to: (받는쪽)
date: YYYY-MM-DD
commit: abc1234     # 직전 커밋. 없으면 "미커밋"
status: 대기        # 받는 쪽이 읽으면 "확인"
read:               # 받는 쪽이 읽은 날짜
---

## 무엇을 했나
(두세 문단. 왜 그렇게 했는지도)

## 바뀐 파일
- 경로 — 무엇이 바뀌었나

## 상대에게 요청
- (없으면 "없음")

## 사용자 판단이 필요한 것
- (없으면 "없음")

작성 원칙: 결과만이 아니라 판단 근거를 적는다. 상대 담당 {{산출물}}에 대한 의견은 "상대에게 요청"에 넣고 직접 고치지 않는다. 하지 않은 것도 적는다("하지 않았다: {{금지행위}}"). 사용자 판단이 필요한 항목은 도구끼리 결정하지 않고 남긴다.
````

### `template/00-교류/현황.md`

````
# 현황 — 무엇이 현행이고 다음에 무엇을 하나

*마지막 갱신: {{오늘}} (claude, 교류 구조 도입). 세션을 시작하면 이 파일부터 읽는다. 어긋나는 문서가 있으면 이 파일이 맞다.*

## {{산출물}}별 현행 판과 담당

| {{산출물}} | 현행 판 | 위치 | 담당 | 상태 |
|---|---|---|---|---|
| (이름, 목적지나 마감) | (판 번호) | (정본 경로) | claude / chatgpt / 미정 | (한 줄) |

## 방침 (사용자 결정, 날짜순)

- {{오늘}}: 저장소를 GitHub private 하나로 두고 문서와 코드를 함께 관리한다. 투고용 artifact는 `code/`만 따로 뽑는다.

## {{산출물}}별 남은 일

### (이름)

- (다음에 할 일. 누가 하는지, 사용자 판단이 필요한지 표시)

## 폴더 안의 잔여물 (사용자가 지울 것)

- 없음
````

### `template/AGENTS.md`

````
# 이 프로젝트에서 일하는 AI 도구를 위한 규칙

이 폴더는 {{사용자}}의 {{프로젝트}}이다.
claude와 chatgpt(Codex)가 같은 저장소에서 번갈아 일하며, 서로의 변경은 git과 `00-교류/`로 전달한다.
기준은 GitHub의 `main`이다. 맥 폴더와 각 도구의 클라우드 작업 공간은 모두 클론이다.

## 세션을 시작하면

1. `git pull --rebase origin main`. 충돌이 나면 상대 것을 살리고 내 것을 다시 적는다.
2. `00-교류/현황.md`를 읽는다. 어느 {{산출물}}의 어느 판이 현행이고 누가 맡고 있는지는 여기가 기준이다.
3. `00-교류/log/`에서 가장 최근 세 파일과, 자기 앞으로 온 인계 노트(`status: 대기`)를 읽고 `status`를 `확인`으로 바꾼다.
4. `git log --oneline -20`으로 상대의 커밋을 본다.
5. 프로젝트 지도는 `README.md`. 할 일은 `docs/할일목록.md`, 결정과 판정은 `docs/승인기록.md`.

## 세션을 마치면

인계 노트를 쓰고, `현황.md`를 갱신하고, `00-교류/log/`에 세션 파일 하나를 남기고, `[claude]` 또는 `[chatgpt]` 접두를 붙여 커밋한 뒤 `git push origin main`한다.
push가 거절되면 다시 pull --rebase 하고 push한다. force push는 하지 않는다.
형식과 자세한 규칙은 `00-교류/README.md`.

## 지켜야 할 것

- {{산출물}}마다 `현황.md`의 담당 칸에 적힌 쪽만 고친다. 담당이 아니면 심사와 의견까지만.
- 새 판을 만들면 지난 판은 같은 폴더의 `구판/`으로 내린다. 지우지 않는다.
- 사용자 확인 후에만 하는 일: {{금지행위}}. 그 직전 단계까지만 준비한다.
- 상대가 만든 파일을 지우거나 옮길 때는 인계 노트에 적는다.
- `.env`, 키 파일, `data/raw/`, `results/raw/`는 커밋하지 않는다. `.gitignore`가 뺀 큰 파일을 강제로 넣지 않는다.
- git 이력을 고쳐 쓰지 않는다. 잘못되면 되돌리는 커밋을 새로 만든다.
- 이 저장소는 작업 저장소다. 투고용 artifact는 `code/scripts/export-artifact.sh`로 `code/`만 새 이력으로 뽑아 별도 저장소에 낸다. 그 저장소에는 프로젝트 이름, 사용자 이름, AI 흔적을 남기지 않는다.
- 국문 문서는 담백한 학술 문어로 쓴다. 산문 속 기호(·, —, →), "핵심은 ~다"류 강조 공식, 번역투 피동을 쓰지 않는다. 영어 용어는 영문 그대로 둔다. 영문 원고는 프로젝트의 영문 학술 문체 규범을 따른다.
````

### `template/CLAUDE.md`

````
@AGENTS.md
````

### `template/README.md`

````
# {{프로젝트명}}

{{프로젝트}}

| 폴더 | 무엇 |
|---|---|
| `00-교류/` | claude와 chatgpt의 교류. `현황.md`가 단일 진실 |
| `docs/` | 연구계획, 할일목록, 승인기록 |
| `manuscript/` | 원고. 현행 판은 `00-교류/현황.md`에서 확인. 지난 판은 `구판/` |
| `code/` | 실험 코드. 투고용 artifact는 여기서만 뽑는다 |
| `data/` | `raw/`는 git 제외. `processed/`는 작은 것만 |
| `results/` | `raw/`는 git 제외. `summary/`만 커밋 |

AI 도구 규칙은 `AGENTS.md`.
````

### `template/code/README.md`

````
# code

실험 코드. 결과 파일에는 이 폴더의 커밋 해시를 적어 어느 코드 판에서 나왔는지 잇는다.

투고용 artifact는 `scripts/export-artifact.sh`로 이 폴더만 새 이력으로 뽑는다. 뽑은 저장소에는 프로젝트 이름, 사용자 이름, AI 흔적이 없어야 한다. 스크립트가 grep으로 한 번 거르지만 사람이 다시 본다.
````

### `template/code/scripts/export-artifact.sh`

````bash
#!/usr/bin/env bash
# code/ 만 새 git 이력으로 뽑아 투고용 artifact 폴더를 만든다.
# 사용: code/scripts/export-artifact.sh <출력폴더> [금지어 ...]
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
OUT="${1:?출력폴더}"; shift || true
BANNED=("{{프로젝트명}}" "{{사용자}}" claude chatgpt codex anthropic openai "00-교류")
BANNED+=("$@")

rm -rf "$OUT"; mkdir -p "$OUT"
git -C "$ROOT" archive HEAD code | tar -x -C "$OUT" --strip-components=1
rm -f "$OUT/scripts/export-artifact.sh"

echo "금지어 검사:"
hit=0
for w in "${BANNED[@]}"; do
  if grep -rIli -- "$w" "$OUT" >/dev/null 2>&1; then
    echo "  '$w' 발견:"; grep -rIli -- "$w" "$OUT" | sed 's/^/    /'; hit=1
  fi
done
[ "$hit" = 0 ] && echo "  없음"

( cd "$OUT" && git init -q && git add -A && git -c user.name=anon -c user.email=anon@example.com commit -q -m "Initial commit" )
echo "만들었다: $OUT (새 이력, 커밋 1개). 금지어가 있으면 고친 뒤 다시 커밋한다."
````

### `template/data/README.md`

````
# data

`raw/`는 git에 넣지 않는다. 어디서 받았고 어떻게 다시 받는지를 이 파일에 적는다.
`processed/`는 10MB 아래 가공본만 넣는다. 만든 스크립트와 커밋 해시를 함께 적는다.

| 파일 | 출처 | 받은 날 | 다시 받는 법 |
|---|---|---|---|
````

### `template/data/processed/.gitkeep`

빈 파일.

### `template/data/raw/.gitkeep`

빈 파일.

### `template/docs/승인기록.md`

````
# 승인 기록

사용자가 내린 결정과 판정. 도구의 권고안과 구별해 적는다.

| 날짜 | 결정 | 근거 | 영향 |
|---|---|---|---|
| {{오늘}} | 저장소 하나로 문서와 코드를 함께 관리 | 결과와 코드 판을 커밋 하나로 잇기 위해 | 투고용 artifact는 code/만 따로 뽑음 |
````

### `template/docs/연구계획.md`

````
# 연구 계획

## 연구 질문
(한 문장)

## 주장
(결과가 뒷받침해야 하는 것. paper-framing 스킬의 구조를 따른다)

## 실험
| 이름 | 무엇을 재나 | 입력 | 산출 | 비용 |
|---|---|---|---|---|

## 투고처와 마감
````

### `template/docs/할일목록.md`

````
# 할 일 목록 (판 v1, {{오늘}})

| 번호 | 일 | 담당 | 배치 | 상태 | 비고 |
|---|---|---|---|---|---|
| 1 | | claude | | 대기 | |
````

### `template/manuscript/README.md`

````
# 원고

파일명 `<이름>-v<판>.md` (또는 .tex). 현행 판은 `00-교류/현황.md`에서 확인한다. 새 판을 만들면 지난 판은 `구판/`으로 내린다.
초록, 서론, 결론은 paper-framing 스킬을 따른다. 국문은 korean-academic-style, 영문은 english-academic-style을 따른다.
````

### `template/manuscript/구판/.gitkeep`

빈 파일.

### `template/results/README.md`

````
# results

`raw/`는 git에 넣지 않는다. `summary/`에 표와 수치 요약만 넣고, 각 파일 머리에 코드 커밋 해시와 실행 날짜를 적는다.
원고의 숫자는 `summary/`의 파일에서만 가져온다.
````

### `template/results/raw/.gitkeep`

빈 파일.

### `template/results/summary/.gitkeep`

빈 파일.

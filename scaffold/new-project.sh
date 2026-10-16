#!/usr/bin/env bash
# 연구 프로젝트 틀을 새 폴더(또는 기존 폴더)에 입힌다.
#
#   new-project.sh <폴더경로> <프로젝트명> "<한 줄 설명>" ["<산출물 단위>"] ["<금지행위>"] [--existing]
#   --existing은 어느 자리에 와도 된다. 프로젝트명은 영문 소문자, 숫자, . _ - 만.
#
# 환경변수
#   SCAFFOLD_USER   문서에 적을 사용자 이름 (기본 git config user.name, 없으면 "사용자")
#   SCAFFOLD_PUSH   y 또는 n. 지정하면 묻지 않는다. 터미널이 아니면 n
#   SCAFFOLD_TOOLS  쓰는 도구 이름, 쉼표로 하나나 둘 (기본 claude,chatgpt). 하나면 인계 노트 없이 세션 기록만 쓴다
#
# 자리표시자 치환과 파일명 바꾸기는 이 스크립트가 넣은 파일에만 한다.
# 기존 파일, 그리고 일부러 자리표시자를 남겨 둔 양식이나 스킬은 건드리지 않는다.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

# --existing은 어느 자리에 와도 된다. 나머지가 위치 인자다
MODE=""; ARGS=()
for a in "$@"; do
  if [ "$a" = "--existing" ]; then MODE="--existing"; else ARGS+=("$a"); fi
done
set -- "${ARGS[@]+"${ARGS[@]}"}"
TARGET="${1:?폴더경로}"; NAME="${2:?프로젝트명}"; DESC="${3:?한 줄 설명}"
UNIT="${4:-원고}"; FORBID="${5:-실험 실행}"
USER_NAME="${SCAFFOLD_USER:-$(git config user.name 2>/dev/null || echo 사용자)}"
TODAY="$(date +%F)"
TOOLS="${SCAFFOLD_TOOLS:-claude,chatgpt}"; TOOLS="${TOOLS// /}"
IFS=',' read -r -a TL <<< "$TOOLS"
if [ "${#TL[@]}" -lt 1 ] || [ "${#TL[@]}" -gt 2 ]; then echo "SCAFFOLD_TOOLS에는 도구 이름을 하나나 둘 준다: $TOOLS" >&2; exit 1; fi
for t in "${TL[@]}"; do printf '%s' "$t" | grep -Eq '^[a-z0-9-]+$' || { echo "도구 이름은 영문 소문자, 숫자, - 만 쓴다: $t" >&2; exit 1; }; done
T1="${TL[0]}"; T2="${TL[1]:-}"
if [ -n "$T2" ] && [ "$T1" = "$T2" ]; then echo "SCAFFOLD_TOOLS의 두 도구 이름이 같다: $TOOLS" >&2; exit 1; fi
if [ -n "$T2" ]; then NT=2; TOOL_LIST="$T1 / $T2"; else NT=1; TOOL_LIST="$T1"; fi
# 틀의 경로를 실제 경로로. 도구가 하나면 인계 노트 폴더와 양식은 넣지 않는다
mappath() { printf '%s' "$1" | sed -e "s|{{오늘}}|$TODAY|g" -e "s|{{도구1}}|$T1|g" -e "s|{{도구2}}|$T2|g"; }
skip() { [ "$NT" = 1 ] && case "$1" in *'{{도구2}}'*|*인계노트-양식.md) return 0;; esac; return 1; }

if ! printf '%s' "$NAME" | grep -Eq '^[a-z0-9._-]+$'; then
  echo "프로젝트명은 영문 소문자, 숫자, . _ - 만 쓴다(원격 저장소 이름이 된다): $NAME" >&2
  exit 1
fi

# 0. 아무것도 바꾸기 전에 겹치는 파일을 먼저 본다
if [ "$MODE" != "--existing" ] && [ -d "$TARGET" ]; then
  clash="$(cd "$HERE/template" && find . -type f | while IFS= read -r p; do
    skip "$p" && continue; q="$(mappath "${p#./}")"
    [ -e "$TARGET/$q" ] && printf '  %s\n' "$q"; done || true)"
  if [ -n "$clash" ]; then
    printf '이미 있는 파일:\n%s\n기존 폴더에 입히려면 --existing을 붙인다. 아무것도 바꾸지 않았다.\n' "$clash" >&2
    exit 1
  fi
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
COPIED="$(mktemp)"; trap 'rm -f "$COPIED"' EXIT

# git을 먼저 둔다. 기존 저장소면 지금 HEAD가 기준선이다. 새 저장소의 브랜치는 main
if [ ! -d "$TARGET/.git" ]; then
  git -C "$TARGET" init -q -b main 2>/dev/null || { git -C "$TARGET" init -q; git -C "$TARGET" symbolic-ref HEAD refs/heads/main; }
fi
CUR="$(git -C "$TARGET" symbolic-ref --short HEAD 2>/dev/null || echo '')"
[ "$CUR" = "main" ] || echo "주의: 지금 브랜치가 main이 아니다($CUR). 문서는 main을 기준으로 한다." >&2
if BASE="$(git -C "$TARGET" rev-parse --short HEAD 2>/dev/null)"; then :; else
  BASE="첫 커밋 (git rev-list --max-parents=0 HEAD)"
fi

# 1. 틀의 파일을 옮기고, 옮긴 파일만 목록에 적는다
(cd "$HERE/template" && find . -mindepth 1 \( -type f -o -type d \) | sort) | while IFS= read -r p; do
  skip "$p" && continue
  src="$HERE/template/$p"; dst="$TARGET/$(mappath "${p#./}")"
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
S_UNIT="$(esc "$UNIT")"; S_FORBID="$(esc "$FORBID")"; S_BASE="$(esc "$BASE")"; S_TARGET="$(esc "$TARGET")"
KIT_URL="$(git -C "$HERE/.." remote get-url origin 2>/dev/null || echo "(운영 체계 저장소 주소)")"
KIT_VER="$(cat "$HERE/../VERSION" 2>/dev/null || echo "?")"
S_KIT_URL="$(esc "$KIT_URL")"; S_KIT_VER="$(esc "$KIT_VER")"
while IFS= read -r f; do
  case "$f" in *.gitkeep) continue;; esac
  sed -e "s|{{프로젝트명}}|$S_NAME|g" -e "s|{{프로젝트}}|$S_DESC|g" -e "s|{{사용자}}|$S_USER|g" \
      -e "s|{{산출물}}|$S_UNIT|g" -e "s|{{금지행위}}|$S_FORBID|g" -e "s|{{오늘}}|$TODAY|g" \
      -e "s|{{기준선 해시}}|$S_BASE|g" -e "s|{{운영체계 주소}}|$S_KIT_URL|g" -e "s|{{운영체계 판}}|$S_KIT_VER|g" \
      -e "s|{{도구1}}|$T1|g" -e "s|{{도구2}}|$T2|g" -e "s|{{도구 목록}}|$TOOL_LIST|g" -e "s|{{폴더경로}}|$S_TARGET|g" "$f" > "$f.tmp-scaffold"
  # 도구 수에 맞는 줄만 남긴다
  if [ "$NT" = 1 ]; then sed -i.bak -e '/<!--두도구-->/d' -e 's/<!--한도구-->//' "$f.tmp-scaffold"
  else sed -i.bak -e '/<!--한도구-->/d' -e 's/<!--두도구-->//' "$f.tmp-scaffold"; fi
  rm -f "$f.tmp-scaffold.bak"
  cat "$f.tmp-scaffold" > "$f"; rm -f "$f.tmp-scaffold"
done < "$COPIED"

[ -f "$TARGET/code/scripts/export-artifact.sh" ] && chmod +x "$TARGET/code/scripts/export-artifact.sh" || true
[ -f "$TARGET/code/scripts/autosync.sh" ] && chmod +x "$TARGET/code/scripts/autosync.sh" || true

N="$(wc -l < "$COPIED" | tr -d ' ')"
echo
echo "틀을 입혔다: $TARGET (파일 $N개, 도구 $TOOL_LIST)"
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
  git add . && git commit -q -m "[$T1] 교류 구조 도입" || true
  gh repo create "$NAME" --private --source=. --remote=origin --push
else
  echo "원격은 만들지 않았다. 나중에:"
  echo "  cd \"$TARGET\" && git add . && git commit -m \"[$T1] 교류 구조 도입\""
  echo "  gh repo create $NAME --private --source=. --remote=origin --push"
fi

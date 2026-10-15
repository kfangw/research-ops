#!/usr/bin/env bash
# code/ 만 새 git 이력으로 뽑아 투고용 artifact 폴더를 만든다.
# 사용: code/scripts/export-artifact.sh <출력폴더> [금지어 ...]
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
OUT="${1:?출력폴더}"; shift || true
BANNED=("demo-study" "연구자" claude chatgpt codex anthropic openai "00-교류")
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

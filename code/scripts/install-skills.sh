#!/usr/bin/env bash
# skills/ 의 스킬을 AI 도구가 읽는 폴더에 복사하거나, claude.ai에 올릴 zip으로 묶는다.
#
#   install-skills.sh claude            ~/.claude/skills/ 에 복사 (Claude Code, 모든 프로젝트)
#   install-skills.sh claude <폴더>     <폴더>/.claude/skills/ 에 복사 (그 프로젝트에서만)
#   install-skills.sh codex             ~/.codex/skills/ 에 복사 (Codex, 모든 프로젝트)
#   install-skills.sh codex <폴더>      <폴더>/.codex/skills/ 에 복사
#   install-skills.sh zip <출력폴더>    스킬마다 <이름>.zip (claude.ai 설정 화면에서 올린다)
#   install-skills.sh list              스킬 이름과 설명 한 줄씩
#
# 환경변수
#   ONLY=a,b,c   이 스킬만 (기본은 전부). research-session은 공통 규칙이라 늘 함께 넣는다
#   FORCE=1      같은 이름의 스킬이 있으면 덮어쓴다 (기본은 건너뛴다)
#
# 이미 있는 같은 이름의 스킬은 덮지 않는다. 건너뛴 것은 끝에 알린다.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$(cd "$HERE/../../skills" && pwd)"
CMD="${1:-}"; DEST_ARG="${2:-}"

# ONLY를 주면 research-session을 늘 함께 넣는다. 모든 스킬이 그 공통 규칙을 가리킨다
names() {
  if [ -n "${ONLY:-}" ]; then
    { printf '%s\n' research-session; printf '%s\n' "$ONLY" | tr -d ' ' | tr ',' '\n'; } | sed '/^$/d' | awk '!seen[$0]++'
  else (cd "$SRC" && for d in */; do [ -f "$d/SKILL.md" ] && printf '%s\n' "${d%/}"; done); fi
}

# 복사하기 전에 이름을 모두 확인한다
bad=""
while IFS= read -r s; do [ -f "$SRC/$s/SKILL.md" ] || bad="$bad $s"; done < <(names)
if [ -n "$bad" ]; then echo "없는 스킬:$bad (아무것도 복사하지 않았다. 이름은 install-skills.sh list)" >&2; exit 1; fi

copy_to() {
  local dest="$1" skipped="" n=0
  mkdir -p "$dest"
  while IFS= read -r s; do
    [ -f "$SRC/$s/SKILL.md" ] || { echo "없는 스킬: $s" >&2; exit 1; }
    if [ -e "$dest/$s" ] && [ "${FORCE:-0}" != 1 ]; then skipped="$skipped $s"; continue; fi
    rm -rf "${dest:?}/$s"; cp -R "$SRC/$s" "$dest/$s"; n=$((n+1))
  done < <(names)
  echo "복사 $n개: $dest"
  [ -z "$skipped" ] || echo "이미 있어 건너뜀:$skipped (덮어쓰려면 FORCE=1)"
}

case "$CMD" in
  claude) if [ -n "$DEST_ARG" ]; then copy_to "$DEST_ARG/.claude/skills"; else copy_to "$HOME/.claude/skills"; fi ;;
  codex)  if [ -n "$DEST_ARG" ]; then copy_to "$DEST_ARG/.codex/skills";  else copy_to "${CODEX_HOME:-$HOME/.codex}/skills"; fi ;;
  zip)
    out="${DEST_ARG:?출력폴더}"; mkdir -p "$out"; out="$(cd "$out" && pwd)"
    command -v zip >/dev/null || { echo "zip 명령이 없다" >&2; exit 1; }
    n=0
    while IFS= read -r s; do
      [ -f "$SRC/$s/SKILL.md" ] || { echo "없는 스킬: $s" >&2; exit 1; }
      rm -f "$out/$s.zip"; (cd "$SRC" && zip -qr "$out/$s.zip" "$s"); n=$((n+1))
    done < <(names)
    echo "zip $n개: $out"
    echo "claude.ai: 설정 > Capabilities > Skills > Upload skill 에서 하나씩 올린다." ;;
  list)
    while IFS= read -r s; do
      python3 - "$s" "$SRC/$s/SKILL.md" <<'PY'
import sys
name, path = sys.argv[1], sys.argv[2]
for line in open(path, encoding='utf-8'):
    if line.startswith('description:'):
        d = line.split(':', 1)[1].strip().strip('"')
        print(f'{name:<24} {d[:60]}{"…" if len(d) > 60 else ""}')
        break
PY
    done < <(names) ;;
  *) sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac

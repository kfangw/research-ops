#!/usr/bin/env bash
# 공개할 저장소에서 금지어(사람 이름, 연구 이름, 개인 경로 등)를 찾는다. 하나라도 있으면 1로 끝난다.
#
#   check-banned.sh <금지어 목록 파일> [검사할 폴더(기본 .)]
#
# 목록은 한 줄에 하나, '#'으로 시작하는 줄과 빈 줄은 건너뛴다. 대소문자는 가리지 않는다.
# 목록 파일은 공개 저장소 밖(비공개 저장소)에 둔다. 목록 자체가 지켜야 할 정보다.
# 파일 내용, 파일 이름, git이 있으면 모든 커밋 메시지를 본다.
#
# push 전 훅으로 걸기 (공개 저장소에서 한 번):
#   mkdir -p .git/hooks && cat > .git/hooks/pre-push <<'H'
#   #!/usr/bin/env bash
#   exec <이 스크립트 경로> <금지어 목록 경로> "$(git rev-parse --show-toplevel)"
#   H
#   chmod +x .git/hooks/pre-push
set -euo pipefail
LIST="${1:?금지어 목록 파일}"; PUB="$(cd "${2:-.}" && pwd)"

WORDS=()
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|'#'*) continue;; esac
  WORDS+=("$line")
done < "$LIST"
[ "${#WORDS[@]}" -gt 0 ] || { echo "금지어 목록이 비어 있다: $LIST" >&2; exit 1; }

LOG=""
if git -C "$PUB" rev-parse HEAD >/dev/null 2>&1; then LOG="$(git -C "$PUB" log --all --format='%B')"; fi

hit=0
for w in "${WORDS[@]}"; do
  inside="$(grep -rIliF --exclude-dir=.git -- "$w" "$PUB" || true)"
  names="$(cd "$PUB" && find . -path ./.git -prune -o -iname "*$w*" -print 2>/dev/null || true)"
  inlog=""
  if [ -n "$LOG" ] && printf '%s' "$LOG" | grep -qiF -- "$w"; then inlog="(커밋 메시지)"; fi
  if [ -n "$inside$names$inlog" ]; then
    echo "  '$w':"; printf '%s\n%s\n%s\n' "$inside" "$names" "$inlog" | sed '/^$/d; s/^/    /'
    hit=1
  fi
done
if [ "$hit" = 1 ]; then echo "금지어 검사 실패: $PUB" >&2; exit 1; fi
echo "금지어 검사 통과 (${#WORDS[@]}개, $PUB)"

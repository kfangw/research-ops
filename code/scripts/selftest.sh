#!/usr/bin/env bash
# 저장소의 스크립트와 틀이 돌아가는지 빠르게 확인한다. GitHub Actions(.github/workflows/check.yml)와 로컬에서 같이 쓴다.
#   code/scripts/selftest.sh        저장소 루트에서 실행. 하나라도 실패하면 1로 끝난다.
# 네트워크, 원격 저장소, 비공개 금지어 목록이 없어도 돈다.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fail=0
ok()  { printf '[완료] %s\n' "$1"; }
bad() { printf '[막힘] %s\n' "$1"; fail=1; }

cd "$ROOT"
export GIT_AUTHOR_NAME=selftest GIT_AUTHOR_EMAIL=selftest@example.com
export GIT_COMMITTER_NAME=selftest GIT_COMMITTER_EMAIL=selftest@example.com

# 1. 문법
n=0; while IFS= read -r -d '' f; do bash -n "$f" || bad "bash 문법: $f"; n=$((n+1)); done < <(git -c core.quotePath=false ls-files -z '*.sh')
ok "bash 문법 ${n}개"
n=0; while IFS= read -r -d '' f; do python3 -m py_compile "$f" || bad "python 문법: $f"; n=$((n+1)); done < <(git -c core.quotePath=false ls-files -z '*.py')
ok "python 문법 ${n}개"

# 2. 스킬 형식: 폴더마다 SKILL.md, name이 폴더 이름과 같고 description이 있다
n=0
for d in skills/*/; do
  s="$(basename "$d")"; f="$d/SKILL.md"
  [ -f "$f" ] || { bad "SKILL.md 없음: $s"; continue; }
  head -1 "$f" | grep -qx -- '---' || bad "frontmatter 없음: $s"
  grep -qxE "name: \"?$s\"?" "$f" || bad "name이 폴더 이름과 다름: $s"
  grep -q '^description: .\+' "$f" || bad "description 없음: $s"
  n=$((n+1))
done
ok "스킬 ${n}개 형식"

# 3. 봉인: 견본의 봉인이 유지되고, 고치면 깨진다
python3 code/scripts/seal.py verify examples/demo-study/docs/사전등록/측정규칙-v1.md >/dev/null || bad "견본 봉인 검증"
printf '규칙 1\n' > "$TMP/rule.md"
python3 code/scripts/seal.py seal "$TMP/rule.md" >/dev/null && python3 code/scripts/seal.py verify "$TMP/rule.md" >/dev/null || bad "봉인 후 검증"
printf '규칙 2\n' > "$TMP/rule.md"
if python3 code/scripts/seal.py verify "$TMP/rule.md" >/dev/null 2>&1; then bad "고친 규칙이 봉인을 통과함"; else ok "봉인과 변경 탐지"; fi

# 4. 스캐폴드: 도구 둘과 하나, 남은 자리표시자 없음, 브랜치 main
for tools in claude,chatgpt claude; do
  p="$TMP/proj-${tools/,/-}"
  if SCAFFOLD_USER=tester SCAFFOLD_EMAIL=tester@example.com SCAFFOLD_TOOLS="$tools" SCAFFOLD_PUSH=n scaffold/new-project.sh "$p" "t-${tools/,/-}" "selftest" >/dev/null 2>&1; then
    left="$(grep -rl '{{' "$p" --exclude-dir=.git 2>/dev/null | wc -l)"
    br="$(git -C "$p" symbolic-ref --short HEAD 2>/dev/null)"
    [ "$left" = 0 ] && [ "$br" = main ] && ok "스캐폴드 도구 $tools" || bad "스캐폴드 $tools: 자리표시자 남은 파일 $left, 브랜치 $br"
  else bad "스캐폴드 실행 실패: $tools"; fi
done
mkdir -p "$TMP/clash" && touch "$TMP/clash/README.md"
if SCAFFOLD_USER=tester SCAFFOLD_EMAIL=tester@example.com SCAFFOLD_PUSH=n scaffold/new-project.sh "$TMP/clash" clash "x" >/dev/null 2>&1; then bad "겹치는 파일이 있는데 스캐폴드가 멈추지 않음"; else ok "스캐폴드 겹침 탐지"; fi

if SCAFFOLD_USER=Claude SCAFFOLD_EMAIL=noreply@anthropic.com SCAFFOLD_PUSH=n scaffold/new-project.sh "$TMP/bot" bot "x" >/dev/null 2>&1 || [ -e "$TMP/bot" ]; then bad "도구 이름을 작성자로 받음"; else ok "도구 작성자 거절"; fi

# 4-1. 커밋 작성자 hook: 작성자는 사용자, 접두 커밋에는 공동 작성자 줄
p="$TMP/proj-claude-chatgpt"
as_user() { GIT_AUTHOR_NAME=tester GIT_AUTHOR_EMAIL=tester@example.com git -C "$p" "$@"; }
if [ "$(git -C "$p" config core.hooksPath)" = code/hooks ] && [ "$(git -C "$p" config user.email)" = tester@example.com ]; then
  git -C "$p" add -A
  if GIT_AUTHOR_NAME=Claude GIT_AUTHOR_EMAIL=noreply@anthropic.com git -C "$p" commit -q -m "[claude] x" >/dev/null 2>&1; then bad "hook: 도구 작성자를 통과시킴"
  elif as_user commit -q -m "[claude] x" >/dev/null 2>&1; then bad "hook: 공동 작성자 줄 없는 접두 커밋을 통과시킴"
  elif ! as_user commit -q -m "$(printf '[claude] x\n\nCo-Authored-By: Claude <noreply@anthropic.com>')" >/dev/null 2>&1; then bad "hook: 맞는 커밋을 막음"
  else ok "커밋 작성자 hook"; fi
else bad "스캐폴드가 작성자나 hook을 설정하지 않음"; fi

# 5. 스킬 설치: 프로젝트 폴더에 전부, 일부만(research-session 포함), zip
p="$TMP/proj-claude"
code/scripts/install-skills.sh claude "$p" >/dev/null 2>&1 || bad "설치 실행"
c="$(ls "$p"/.claude/skills/*/SKILL.md 2>/dev/null | wc -l)"
[ "$c" = "$(ls -d skills/*/ | wc -l)" ] && [ -f "$p/.claude/skills/.research-ops.json" ] && ok "설치 ${c}개와 설치 기록" || bad "설치 결과 ${c}개, 설치 기록 확인"
q="$TMP/only"; mkdir -p "$q"
ONLY=problem-grill code/scripts/install-skills.sh claude "$q" >/dev/null 2>&1
[ -f "$q/.claude/skills/problem-grill/SKILL.md" ] && [ -f "$q/.claude/skills/research-session/SKILL.md" ] && ok "일부 설치에 research-session 포함" || bad "일부 설치"
code/scripts/install-skills.sh zip "$TMP/zip" >/dev/null 2>&1 && [ "$(ls "$TMP/zip"/*.zip 2>/dev/null | wc -l)" -gt 0 ] && ok "zip 묶기" || bad "zip 묶기"

# 6. 금지어 검사 스크립트 자체: 없는 단어는 통과, 있는 단어는 막는다
printf 'absent-%s-%s\n' "$$" "$RANDOM" > "$TMP/none.txt"   # 이 파일에 글자 그대로 남지 않게 실행할 때 만든다
printf 'research-ops\n' > "$TMP/hit.txt"
code/scripts/check-banned.sh "$TMP/none.txt" . >/dev/null 2>&1 || bad "금지어 검사: 없는 단어에서 실패"
if code/scripts/check-banned.sh "$TMP/hit.txt" . >/dev/null 2>&1; then bad "금지어 검사: 있는 단어를 놓침"; else ok "금지어 검사 동작"; fi

# 7. 판 번호가 변경 기록에 있다
v="$(cat VERSION)"; grep -q "^## $v " CHANGELOG.md && ok "VERSION $v 이 CHANGELOG에 있음" || bad "CHANGELOG에 $v 없음"

[ "$fail" = 0 ] && echo "selftest 통과" || echo "selftest 실패"
exit "$fail"

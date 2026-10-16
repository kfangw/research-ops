#!/usr/bin/env bash
# restore-bundles.sh — git bundle 여러 개에 흩어진 가지를 저장소 하나에 모은다.
#
#   code/scripts/restore-bundles.sh <저장소> <bundle 폴더>
#
# 클라우드 세션이 회차마다 남긴 bundle(예: paper_rev18.bundle … paper_rev35.bundle)을 수정 시각 순으로 읽어
# 모든 가지를 <저장소>의 로컬 가지로 만든다. 같은 이름의 가지는 뒤 bundle이 이긴다. 앞 bundle의 머리가 뒤 머리의
# 조상이 아니면(갈라졌으면) `<가지>@<bundle 이름>`으로 남겨 잃지 않는다. 태그도 가져온다.
# 저장소의 현재 가지와 작업 트리는 건드리지 않는다. main을 어디에 둘지는 사람이 정한다(research-scaffold 6절).
set -euo pipefail
REPO="${1:?저장소}"; BDIR="${2:?bundle 폴더}"
cd "$REPO"
ls "$BDIR"/*.bundle >/dev/null 2>&1 || { echo "bundle 없음: $BDIR" >&2; exit 1; }
for b in $(ls -tr "$BDIR"/*.bundle); do
  n="$(basename "$b" .bundle)"
  git fetch -q --no-tags "$b" "+refs/heads/*:refs/bundles/$n/*" 2>/dev/null || { echo "읽지 못함: $b" >&2; continue; }
  git fetch -q --no-tags "$b" "+refs/tags/*:refs/tags/*" 2>/dev/null || true
done
declare -A latest
for b in $(ls -tr "$BDIR"/*.bundle); do
  n="$(basename "$b" .bundle)"
  for r in $(git for-each-ref --format='%(refname)' "refs/bundles/$n/"); do latest["${r#refs/bundles/$n/}"]="$n"; done
done
for br in "${!latest[@]}"; do
  n="${latest[$br]}"; tip="$(git rev-parse "refs/bundles/$n/$br")"
  if git show-ref --verify -q "refs/heads/$br"; then
    cur="$(git rev-parse "refs/heads/$br")"
    if [ "$cur" = "$tip" ]; then :
    elif git merge-base --is-ancestor "$cur" "$tip"; then
      if [ "$(git symbolic-ref --short HEAD 2>/dev/null)" = "$br" ]; then echo "현재 가지 $br: $n 으로 fast-forward 가능 (git merge --ff-only $tip)"; else git update-ref "refs/heads/$br" "$tip"; echo "$br --> $n"; fi
    else git branch -f "$br@local" "$cur"; [ "$(git symbolic-ref --short HEAD 2>/dev/null)" = "$br" ] || git update-ref "refs/heads/$br" "$tip"; echo "갈라짐 $br: 로컬은 $br@local, $n 은 $tip"; fi
  else git branch -q "$br" "$tip"; fi
  for b in $(ls -tr "$BDIR"/*.bundle); do
    m="$(basename "$b" .bundle)"; [ "$m" = "$n" ] && continue
    git show-ref --verify -q "refs/bundles/$m/$br" || continue
    h="$(git rev-parse "refs/bundles/$m/$br")"
    git merge-base --is-ancestor "$h" "$tip" || { git branch -q -f "$br@$m" "$h"; echo "갈라짐 $br@$m: $h (뒤 bundle의 조상이 아님)"; }
  done
done
git for-each-ref --format='delete %(refname)' refs/bundles | git update-ref --stdin
echo "가지 $(git branch --format='%(refname:short)' | wc -l | tr -d ' ')개"

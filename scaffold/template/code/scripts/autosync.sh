#!/usr/bin/env bash
# autosync.sh — 작업 폴더의 변경을 자동으로 커밋하고 push한다. 사용자 컴퓨터의 launchd(맥)나 cron으로 주기 실행한다.
#
#   code/scripts/autosync.sh <저장소 루트> [접두=mac]
#
# 하는 일: submodule부터 차례로, 바뀐 것이 있으면 "[<접두>-auto] 자동 저장"으로 커밋 → fetch → rebase → push.
# 하지 않는 일: force push, 이력 고침, 충돌 해결(충돌이면 rebase를 되돌리고 알림만 띄운다), detached HEAD 커밋.
# 원격에 닿지 못하면 이번은 건너뛴다. 기록은 <저장소>/_local/autosync.log (git 제외).
# 자동 저장 커밋은 백업이지 작업 단위가 아니다. 세션은 그래도 작업 단위마다 커밋하고, 시작할 때 pull --rebase로 먼저 받는다.
set -u
REPO="${1:?저장소 루트}"; WHO="${2:-mac}"
cd "$REPO" || exit 1
mkdir -p "$REPO/_local"; LOG="$REPO/_local/autosync.log"
log() { printf '%s %s\n' "$(date '+%F %T')" "$*" >> "$LOG"; }
notify() { command -v osascript >/dev/null && osascript -e "display notification \"$1\" with title \"autosync $(basename "$REPO")\"" 2>/dev/null; }

sync_one() {
  local d="$1"
  ( cd "$d" || exit 1
    local br; br="$(git symbolic-ref --short HEAD 2>/dev/null)" || { log "$d: detached HEAD, 건너뜀"; exit 0; }
    [ -e "$(git rev-parse --git-dir)/index.lock" ] && { log "$d: index.lock 있음(다른 세션 작업 중), 건너뜀"; exit 0; }
    if [ -n "$(git status --porcelain)" ]; then
      git add -A && git commit -q -m "[$WHO-auto] $(date '+%F %H:%M') 자동 저장" && log "$d: 커밋 $(git rev-parse --short HEAD) ($br)"
    fi
    git remote get-url origin >/dev/null 2>&1 || { log "$d: origin 없음, push 생략"; exit 0; }
    if ! git fetch -q origin "$br" >>"$LOG" 2>&1; then log "$d: 원격에 닿지 못함(저장소 없음, 인증, 네트워크), 이번은 건너뜀"; exit 3; fi
    if ! git rebase -q "origin/$br" >>"$LOG" 2>&1; then
      git rebase --abort 2>/dev/null; log "$d: rebase 충돌, 사람이 풀어야 함"; notify "$d: 충돌, 직접 풀어야 함"; exit 2
    fi
    if git push -q origin "$br" >>"$LOG" 2>&1; then log "$d: push $br"; else log "$d: push 실패(원격 없음이나 인증)"; exit 3; fi
  )
}

# submodule을 먼저 맞추면 본 저장소의 포인터 변경이 뒤 커밋에 함께 들어간다
git submodule foreach --quiet 'echo "$sm_path"' 2>/dev/null | while read -r sm; do sync_one "$REPO/$sm"; done
sync_one "$REPO"

#!/usr/bin/env bash
# research-ops 스킬의 설치, 새 판 확인, 갱신. 사용법은 인자 없이 돌리면 보인다.
#   install-skills.sh claude|codex [프로젝트폴더]   설치(설치 기록 .research-ops.json을 남김)
#   install-skills.sh zip <출력폴더>                claude.ai에 올릴 zip
#   install-skills.sh list                          스킬 이름과 설명
#   install-skills.sh check [스킬폴더 ...]          새 판이 있는지 확인(바꾸지 않음, 새 판 있으면 종료 코드 3)
#   install-skills.sh update [스킬폴더 ...]         저장소를 받고 사용자가 고치지 않은 스킬만 바꿈
set -euo pipefail
exec python3 "$(cd "$(dirname "$0")" && pwd)/install_skills.py" "$@"

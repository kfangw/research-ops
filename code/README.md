# code

| 파일 | 무엇 |
|---|---|
| `scripts/seal.py` | 판정 규칙 파일의 봉인과 검증. 사용법은 `docs/04-사전등록과-봉인.md`, 절차는 `preregister-seal` 스킬 |
| `scripts/install-skills.sh` | `skills/`를 Claude Code(`~/.claude/skills/`), Codex(`~/.codex/skills/`)에 설치하고 설치 기록을 남긴다. `check`로 새 판을 확인하고 `update`로 갱신한다. claude.ai용 zip도 만든다. 인자 없이 돌리면 사용법을 보인다. 본체는 `install_skills.py` |
| `scripts/selftest.sh` | 문법, 스킬 형식, 봉인, 스캐폴드, 설치, 금지어 검사를 빈 폴더에서 돌려 본다. 이 저장소를 고친 뒤와 GitHub Actions에서 돌린다 |
| `scripts/check-banned.sh` | 공개할 저장소에서 금지어(이름, 연구 이름, 개인 경로)를 파일 내용, 파일 이름, 커밋 메시지에서 찾는다. push 전 훅으로 거는 법은 스크립트 머리에 있다 |

# code

| 파일 | 무엇 |
|---|---|
| `scripts/seal.py` | 판정 규칙 파일의 봉인과 검증. 사용법은 `docs/04-사전등록과-봉인.md`, 절차는 `preregister-seal` 스킬 |
| `scripts/install-skills.sh` | `skills/`를 Claude Code(`~/.claude/skills/`), Codex(`~/.codex/skills/`)에 복사하거나 claude.ai용 zip으로 묶는다. 인자 없이 돌리면 사용법을 보인다 |
| `scripts/check-banned.sh` | 공개할 저장소에서 금지어(이름, 연구 이름, 개인 경로)를 파일 내용, 파일 이름, 커밋 메시지에서 찾는다. push 전 훅으로 거는 법은 스크립트 머리에 있다 |

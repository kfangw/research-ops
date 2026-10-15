# 변경 기록

## 0.3 (2026-10-15)

- 공개 준비. 공개판에 남는 파일에서 사람 이름, 연구 이름, 투고처, 개인 폴더 경로를 일반 표현으로 바꿨다. 스캐폴드의 기본 사용자 이름은 `git config user.name`에서 읽는다.
- 예시 기록 두 편에서 발표 전 측정값을 어림으로 바꾸고 조건의 이름을 지웠다.
- LICENSE를 확정했다. 문서는 CC BY 4.0, 스크립트와 스킬은 MIT.
- 문서, 양식, 예시, 스캐폴드 틀의 용어와 문체를 통일했다(세션 기록, 현황, 판, 바퀴, 큰 지적, 사실 대조, 심사). 산문 속 기호를 걷어 냈다.
- 관문 번호를 G0 신규성, G1 실재, G2 단순 대안, G3 자명성, G4 자료, G5 일정과 요건, G6 겹침, G7 닫힘으로 맞췄다(`docs/03-관문.md`, `templates/관문.md`, 예시).
- 문서의 스킬 목록을 새 체계로 고쳤다. 세션 절차는 `research-session`, 배치는 `research-batch`가 맡고, `research-portfolio`, `preregister-seal`, `fact-check`, `rebuttal`을 더했다. 원칙 7에 결과를 숨기지 않되 약점을 필요 이상으로 고백하지 않는다는 규칙을 더했다.

## 0.2 (2026-10-15)

- 저장소 자신을 연구 스캐폴드로 다시 입혔다. `AGENTS.md`, `CLAUDE.md`, `00-교류/`(세션별 log), `docs/승인기록·할일목록·연구계획`, `code/`, `manuscript/`, `data/`, `results/`.
- 사용자의 스캐폴드 v1을 `scaffold/`에 넣고 v1.1로 고쳤다. `--existing`의 치환이 기존 파일의 자리표시자를 덮던 문제, 기준선 해시, 비대화 실행, 특수문자.
- `protocols/exchange/`를 `protocols/구판/`으로. 현행 규약은 스캐폴드에 있다.
- `scripts/seal.py`를 `code/scripts/seal.py`로.
- `skills/research-scaffold` 추가.
- `.gitignore`에서 `*.seal.json` 제외를 뺐다. 봉인 기록은 커밋한다.

## 0.1 (2026-10-15)

첫 판. 실제 연구 프로젝트 여섯에서 쓰던 규약, 양식, 스킬, 프롬프트를 모아 개인 정보와 연구 내용을 지우고 정리했다.

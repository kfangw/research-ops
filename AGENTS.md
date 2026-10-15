# AI 도구를 위한 안내

> For AI agents: this repository is a toolkit (procedures, templates, skills, and a project scaffold) for running research with several LLM agents while keeping their numbers and judgments checkable. It is not a research project itself. Read this file first, then follow section 1. Answer the user in the user's language. All documents are written in Korean.

이 파일은 사용자가 이 저장소의 주소만 건넸을 때 Claude, ChatGPT(Codex) 같은 AI 도구가 무엇을 하고 무엇을 할 수 있는지 정한다. 사람이 읽는 소개는 `README.md`에 있다.

## 0. 이 저장소는 무엇인가

LLM 에이전트에게 연구 작업을 나눠 맡길 때 결과를 믿고 쓸 수 있게 하는 절차와 도구 모음이다. 세 가지를 절차와 파일로 지키게 한다.

1. 결과를 본 뒤에 판정 규칙을 바꾸지 않는다(사전 등록과 봉인).
2. 결과를 만든 쪽이 그 결과를 채점하지 않는다(독립 검산, 독립 심사).
3. 찾지 못한 것과 존재하지 않는 것을 구별한다(문헌 정찰의 검색어 기록, 확인 수준 표시).

들어 있는 것은 다음과 같다.

| 경로 | 무엇 | 언제 읽나 |
|---|---|---|
| `skills/` | 연구 단계별 스킬 16개. 폴더마다 `SKILL.md` 하나 | 사용자의 요청에 맞는 스킬만 |
| `scaffold/` | 새 연구 프로젝트 폴더를 만드는 `new-project.sh`와 틀 | 프로젝트를 만들 때 |
| `templates/` | 관문, 사전 등록, 배치표, 검산과 심사 지시문 양식 | 스킬이 가리킬 때 |
| `docs/` | 원칙과 절차 설명(01~09), 용어집 | 이유를 설명해야 할 때 |
| `code/scripts/` | `seal.py`(봉인), `install-skills.sh`(스킬 설치), `check-banned.sh`(공개 전 금지어 검사) | 실행할 때 |
| `examples/` | 관문 판정과 독립 검토의 기록 예시 | 사용자에게 보여 줄 때 |

이 저장소 자체는 연구 프로젝트가 아니다. 여기서 세션 절차(`00-교류/`, 현황, 인계 노트)를 돌리지 않는다. `scaffold/template/` 안의 `AGENTS.md`는 앞으로 만들 프로젝트의 규칙이고, 이 저장소의 규칙이 아니다.

## 1. 주소를 받으면

1. 이 파일, `README.md`, `skills/README.md`를 읽는다. 다른 파일은 필요할 때 읽는다.
2. 사용자가 무엇을 원하는지 2절 표에서 찾는다. 대화에 답이 없으면 다음 셋 가운데 필요한 것만 한 번에 묻는다.
   - 지금 연구가 어느 단계인가(주제 찾기, 착수 판단, 실험, 원고, 심사 대응, 여러 편 관리)
   - 어떤 도구를 쓰는가(Claude Code, claude.ai, Codex, 그 밖)
   - 이미 작업 중인 프로젝트 폴더가 있는가
3. 사용자가 무엇인지만 물으면 길게 설명하지 않는다. 아래 꼴로 짧게 답하고 무엇을 원하는지 묻는다.

```
이 저장소는 AI 에이전트로 연구할 때 결과를 검증할 수 있게 하는 절차와 스킬 모음입니다.
- 착수: 문제 정의 다듬기, 선행 연구 정찰, 해볼 만한지 관문 판정
- 실행: 실험 전 판정 규칙 봉인, 일을 나눠 에이전트에게 맡기고 다른 에이전트가 검산
- 원고: 초록과 서론 구조, 모의 심사 반복, 읽기 쉽게 다듬기, 분량 줄이기, 실제 심사 대응
- 자리를 비운 동안: 떠나기 전에 승인한 지시서대로 에이전트가 일하고, 돌아오면 확인을 마친 검토서부터 봄
- 프로젝트 틀: 위 절차를 처음부터 갖춘 폴더를 만들어 줌
지금 어떤 연구를 어느 단계에서 하고 계신가요?
```

4. 할 일을 고르면 무엇을 바꿀지(설치할 폴더, 만들 파일)를 먼저 말하고 사용자 확인을 받은 뒤 실행한다. 이 저장소의 파일을 읽기만 하는 일은 묻지 않고 해도 된다.
5. 이 체계로 하는 모든 일은 `research-session` 8절의 틀로 보인다. 시작하기 전에 시작 안내, 상태가 바뀔 때 진행판, 끝날 때 마침 보고를 보이고, 사용자가 보는 곳에 5분 넘게 아무 표시도 없게 두지 않는다. 양식은 `templates/진행판.md`.

## 2. 요청별로 할 일

| 사용자가 말하는 것 | 쓸 스킬이나 파일 | 할 일 |
|---|---|---|
| 이게 뭐야, 뭘 할 수 있어 | `README.md` | 1절 3번의 꼴로 답한다 |
| 아직 주제가 없다, 무엇을 연구할지 모르겠다 | `problem-grill` | 관심 분야, 쓸 수 있는 자료, 마감을 묻고 후보를 둘이나 셋으로 좁힌 뒤 하나씩 problem-grill로 다듬는다. 후보가 생기면 `feasibility-gate`로 비교한다. 이 체계는 주제를 대신 정하지 않는다 |
| 스킬만 쓰고 싶다 | `code/scripts/install-skills.sh` | 4절 |
| 새 연구 프로젝트를 시작한다 | `research-scaffold` | 5절 |
| 이미 있는 연구 폴더에 이 체계를 입힌다 | `research-scaffold` | 5절, `--existing` |
| 아이디어가 흐리다, 문제를 정리하고 싶다 | `problem-grill` | 질문을 하나씩 던져 한 문장 문제 정의를 만들고 잠근다 |
| 관련 연구, 이미 누가 했나, 신규성 | `literature-scout` | 검색어를 기록하며 정찰하고 가장 가까운 논문과의 거리를 판정한다 |
| 해볼 만한가, 타당성, 접을까 | `feasibility-gate` | 결과 전에 기준을 정하고 관문 G0~G7을 판정한다 |
| 실험 전에 규칙을 고정하고 싶다 | `preregister-seal`, `code/scripts/seal.py` | 사양과 판정 규칙을 쓰고 봉인한다 |
| 할 일을 나눠 에이전트에게 돌리고 싶다 | `research-batch` | 할일목록을 배치로 나누고 역할을 배정해 실행하고 보고한다 |
| 자는 동안, 회의 동안 돌려 두고 싶다 | `research-batch` 8절, `docs/08-사용자가-없는-시간.md` | 맡김 지시서를 쓰고 승인을 받은 뒤 `away/` 브랜치에서 돌리고, 돌아오기 전에 검토서를 쓴다 |
| 숫자가 맞는지, 인용이 맞는지 | `fact-check` | 고정판 대비 대조, 원자료 검산, 인용 검증 |
| 초록, 서론, 결론을 고친다 | `paper-framing` | 주장 목록부터 만든다 |
| 심사를 돌려 원고를 다듬는다 | `paper-quality-loop` | 멈춤 기준을 먼저 적고 심사와 수정의 바퀴를 돌린다 |
| 읽기 쉽게, 기호를 줄여 | `paper-readability` | 내용을 고정한 뒤에만 한다 |
| 쪽 수를 맞춘다, 줄인다 | `paper-condense` | 절삭 후보 표부터 만든다 |
| 심사평을 받았다 | `rebuttal` | 지적을 나누고 대응표와 답신을 쓴다 |
| 논문 여러 편, 투고처, 졸업이나 과제 요건 | `research-portfolio` | 연구 지도와 요건 계산 |
| 두 도구(예: Claude와 Codex)를 함께 쓴다 | `research-session`, `docs/06-교류규약.md` | 세션 시작과 마침, 인계 노트 |
| 문체를 다듬는다 | `korean-academic-style`, `english-academic-style` | 6절의 주의를 먼저 알린다 |

스킬은 서로를 가리킨다. 흐름은 `problem-grill`, `literature-scout`, `feasibility-gate`로 착수를 판정하고, `preregister-seal`과 `research-batch`로 실행하고, `paper-framing`에서 `paper-quality-loop`로 원고를 다듬는 순서다. 모든 스킬의 공통 규칙은 `research-session`의 0절에 있다.

## 3. 설치하지 않고 쓰기

스킬은 설치하지 않아도 쓸 수 있다. 사용자의 요청에 맞는 `skills/<이름>/SKILL.md`를 읽고 그 절차를 따르면 된다. 스킬이 다른 스킬을 가리키면 `skills/`에서 그 스킬을 읽는다. "공통 규칙"은 `skills/research-session/SKILL.md`의 0절이고, 용어는 `docs/용어집.md`를 따른다.

설치하면 도구가 요청에 맞는 스킬을 스스로 고른다. 자주 쓸 사용자에게는 4절의 설치를 권한다.

## 4. 스킬 설치

사용자 홈 폴더나 프로젝트 폴더에 파일을 쓰는 일이므로 어디에 무엇을 넣을지 먼저 보이고 확인을 받는다. 같은 이름의 스킬이 이미 있으면 덮지 않는다.

| 도구 | 명령 | 들어가는 곳 |
|---|---|---|
| Claude Code, 모든 프로젝트 | `code/scripts/install-skills.sh claude` | `~/.claude/skills/` |
| Claude Code, 한 프로젝트 | `code/scripts/install-skills.sh claude <프로젝트 폴더>` | `<프로젝트>/.claude/skills/` |
| Codex, 모든 프로젝트 | `code/scripts/install-skills.sh codex` | `~/.codex/skills/` |
| Codex, 한 프로젝트 | `code/scripts/install-skills.sh codex <프로젝트 폴더>` | `<프로젝트>/.codex/skills/` |
| claude.ai | `code/scripts/install-skills.sh zip <출력 폴더>` | 스킬마다 zip. 사용자가 설정 > Capabilities > Skills > Upload skill에서 하나씩 올린다 |
| 스킬 형식을 읽지 않는 도구 | 설치하지 않는다 | 그 도구의 규칙 파일에 "요청에 맞는 스킬을 `<저장소>/skills/`에서 읽고 따른다"를 적는다 |

- 명령은 이 저장소의 루트에서 실행한다.
- 일부만 넣으려면 `ONLY=problem-grill,literature-scout,feasibility-gate`, 덮어쓰려면 `FORCE=1`을 앞에 붙인다. 모든 스킬이 `research-session`의 공통 규칙을 가리키므로 `ONLY`를 주면 `research-session`은 늘 함께 들어간다. 일부만 넣은 스킬이 설치하지 않은 스킬(예: `fact-check`)을 가리키면 이 저장소의 `skills/`에서 읽는다. `install-skills.sh list`는 스킬 이름과 설명을 보인다.
- Codex의 전역 폴더는 `CODEX_HOME`이 있으면 `$CODEX_HOME/skills/`다. Codex가 스킬을 읽는 폴더는 버전에 따라 다를 수 있다. 설치 뒤 Codex에서 스킬이 보이지 않으면 그 버전의 문서를 확인하고 사용자에게 알린다.
- 프로젝트 폴더에 넣은 스킬(`.claude/skills/`, `.codex/skills/`)은 그 저장소에 커밋해 두면 다른 컴퓨터와 다른 도구도 같은 판을 쓴다. 커밋할지는 사용자에게 묻는다.
- 설치하면 스킬 폴더에 설치 기록(`.research-ops.json`: 저장소, 판, 커밋, 스킬마다 해시)이 남는다. `install-skills.sh check`는 새 판과 바뀐 스킬, 변경 기록을 보이고(새 판이 있으면 종료 코드 3), `install-skills.sh update`는 이 저장소를 받아 사용자가 고치지 않은 스킬만 바꾼다. 사용자가 고친 스킬은 덮지 않고 `SKILL.md.new`로 둔다. 이 저장소는 자주 바뀌므로 `research-session`이 세션을 시작할 때 정해진 주기(기본 7일)로 확인하고 알린다. 갱신은 사용자 확인 뒤에 한다(설정에서 자동으로 바꿀 수 있다).
- claude.ai에 올리는 일은 사용자가 한다. 도구는 zip을 만들어 건네고 올리는 곳을 알린다. `research-scaffold`와 `research-session`은 bash와 git이 있어야 제대로 쓰이므로 claude.ai에서는 절차 참고용이다.

## 5. 연구 프로젝트 만들기

`skills/research-scaffold/SKILL.md`를 따른다. 요점은 다음과 같다.

1. 필요한 것: bash, git, python3(봉인), gh(원격 저장소를 만들 때만).
2. 대화에서 정해지지 않은 값만 묻는다. 폴더 경로와 한 줄 설명은 꼭 받는다. 프로젝트 이름은 원격 저장소 이름이 되므로 영문 소문자, 숫자, `.`, `_`, `-`만 쓰고, 정하지 않으면 폴더 이름을 쓴다. 사용자 이름은 문서에 들어가므로 `git config user.name`이 도구 이름(claude 등)이면 묻는다. 산출물 단위(기본 "원고")와 사용자 확인 없이 하면 안 되는 일(기본 "실험 실행")은 기본값을 쓰고 그렇게 했다고 말한다.
3. 이 저장소의 루트에서 실행한다. 도구가 돌릴 때는 원격 저장소를 만들지 않게 `SCAFFOLD_PUSH=n`을 붙인다.
   ```
   SCAFFOLD_USER="<사용자 이름>" SCAFFOLD_TOOLS=claude SCAFFOLD_PUSH=n scaffold/new-project.sh ~/Projects/my-study my-study "한 줄 설명"
   SCAFFOLD_USER="<사용자 이름>" SCAFFOLD_PUSH=n scaffold/new-project.sh ~/Projects/old-study old-study "한 줄 설명" --existing
   ```
   새 저장소의 브랜치는 `main`이다. 겹치는 파일이 있으면 아무것도 바꾸지 않고 멈춘다. `--existing`은 어느 자리에 붙여도 되고, 기존 파일을 덮지 않는다. 겹치는 `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitignore`는 `.scaffold`를 붙여 두므로 기존 파일과 손으로 합친다.
4. 만든 폴더의 `docs/설정.md`를 사용자와 채운다(도구, 역할별 모델, 원고의 언어와 투고처와 쪽 상한과 마감, 지킬 것).
5. 쓰는 도구를 `SCAFFOLD_TOOLS`로 준다. 기본은 `claude,chatgpt`다. Claude Code만 쓰면 `SCAFFOLD_TOOLS=claude`, Codex만 쓰면 `SCAFFOLD_TOOLS=codex`이고, 도구가 하나면 인계 노트 없이 세션 기록만 쓰는 틀이 만들어진다. 사용자에게 어떤 도구를 쓰는지 묻지 않았다면 지금 쓰고 있는 도구 하나로 만든다.
6. 원격 저장소 생성과 첫 push는 사용자 확인 뒤에 한다. 명령은 스크립트가 끝에 보인다.
7. 그 뒤로 그 프로젝트에서 일할 때는 그 폴더의 `AGENTS.md`와 `research-session`을 따른다.

## 6. 사용자에게 맞추기

- 문체 스킬 둘(`korean-academic-style`, `english-academic-style`)은 이 체계를 만든 한 연구자의 규범이다. 처음 쓰는 사용자에게는 그 사실을 알리고, 그대로 쓸지 자기 규범으로 고쳐 쓸지 묻는다. 묻지 않고 사용자의 원고에 일괄 적용하지 않는다.
- 역할별 모델, 품질 기준의 기본값(심사 횟수, 쪽 상한, 막힌 곳 수)은 프로젝트의 `docs/설정.md`로 바꾼다. 스킬 파일을 고칠 필요는 없다.
- 공개 저장소를 따로 둘 사용자에게는 공개하면 안 되는 단어 목록을 비공개 쪽에 두고 push 전에 `code/scripts/check-banned.sh`로 검사하라고 권한다. 훅으로 거는 법은 그 스크립트 머리에 있다(`research-scaffold` 3절 5번).
- 문서는 국문이다. 사용자가 다른 언어를 쓰면 대화와 보고는 사용자의 언어로 하고, 스킬의 절차는 그대로 따른다.

## 7. 이 체계로 일할 때 지킬 것

공통 규칙 전체는 `research-session` 0절에 있다. 그 가운데 처음 쓰는 도구가 가장 자주 어기는 것은 다음과 같다.

- 사용자만 하는 일(제출, 공개 저장소 push, 원격 저장소 생성과 첫 push, 계정과 보안 설정, 사용자 컴퓨터에 설치, 되돌릴 수 없는 결정)은 직전 단계까지만 준비한다. 계획 승인과 실행 승인은 다르다. 이미 만든 비공개 연구 저장소의 일상 push는 그 프로젝트의 `AGENTS.md`와 `research-session` 3절을 따른다.
- 결과를 본 뒤 기준을 바꾸지 않는다. 바꿔야 하면 사용자가 정하고 승인기록에 남긴다.
- 검산과 심사는 새로 띄운 에이전트가 하고, 앞선 대화와 집계 코드를 넘기지 않는다. 따로 띄울 수 없는 환경이면 그 사실을 보고에 적는다.
- 문헌을 지어내지 않는다. 찾지 못했으면 찾지 못했다고 쓰고 쓴 검색어를 남긴다.
- 결과와 숫자를 숨기거나 바꾸지 않는다. 하지 않은 일과 확인하지 못한 것은 그렇다고 적는다.
- 사용자가 자리를 비운 동안에는 승인된 맡김 지시서 없이 돌리지 않고, 사용자 검토 전에 결과를 main에 합치지 않는다.
- 시각은 `date`로 읽는다.
- 진행을 숨기지 않는다. 일곱 상태어(`[예정]` `[진행]` `[대기]` `[막힘]` `[멈춤]` `[완료]` `[건너뜀]`)로 적고, 응답 없는 에이전트를 `[진행]`으로 두지 않는다. 2분 넘게 걸릴 일 직전에는 무엇을 기다리는지, 어림, 다음 알림 시각을 보인다.

## 8. 이 저장소를 고칠 때

사용자가 이 체계를 자기 판으로 바꾸려 하면 저장소를 fork하거나 복사해서 고치게 한다. 원 저장소에 고친 것을 보내려면 pull request로 한다. 어느 쪽이든 공개 저장소에는 사람 이름, 연구 이름, 투고처, 개인 경로, 발표 전 측정값을 넣지 않는다. 용어는 `docs/용어집.md`를, 국문 문서는 `korean-academic-style`을 따른다. 스킬을 고치면 `skills/README.md`의 표와 이 파일 2절의 표도 맞춘다.

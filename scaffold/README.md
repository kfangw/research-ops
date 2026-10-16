# research-scaffold

논문 한 편을 private GitHub 저장소 하나로 관리하는 연구 프로젝트 틀이다. AI 도구 하나로 써도 되고, 둘(예: Claude와 Codex)이 번갈아 고쳐도 된다.
원고, 교류 기록, 코드, 자료, 결과를 한 저장소에 두고, 투고용 artifact는 `code/`만 따로 뽑아 낸다.
이 틀로 프로젝트를 만드는 일은 `research-scaffold` 스킬이, 만든 뒤 매 세션의 시작과 마침은 `research-session` 스킬이 맡는다.

## 쓰는 법

새 프로젝트:

    ./new-project.sh <폴더경로> <프로젝트명> "<한 줄 설명>" "<산출물 단위>" "<금지행위>"
    예) ./new-project.sh ~/Projects/my-study my-study "어느 측정 연구의 학회 논문" 원고 "실험 실행"

저장소 루트에서 `scaffold/new-project.sh`로 불러도 된다. `--existing`은 어느 자리에 와도 된다.

쓰는 도구는 `SCAFFOLD_TOOLS`로 준다. 기본은 `claude,chatgpt`이고, `SCAFFOLD_TOOLS=claude`처럼 하나만 주면 인계 노트 없이 세션 기록만 쓰는 틀이 된다.

    SCAFFOLD_TOOLS=claude ./new-project.sh ~/Projects/my-study my-study "어느 측정 연구의 학회 논문"

이미 있는 폴더에 입히기:

    ./new-project.sh ~/Projects/old-study old-study "..." 원고 "실험 실행" --existing

`--existing`이면 기존 파일을 덮지 않고 없는 것만 넣는다. `AGENTS.md`, `CLAUDE.md`, `README.md`, `.gitignore`가 이미 있으면 `.scaffold`를 붙여 두고 사용자가 합친다. `--existing` 없이 이미 파일이 있는 폴더를 주면 멈춘다.

자리표시자 치환과 파일명의 `{{오늘}}` 바꾸기는 스크립트가 넣은 파일에만 한다. 기존 파일, 특히 일부러 자리표시자를 남겨 둔 양식이나 스킬은 건드리지 않는다.

마지막에 `gh repo create <프로젝트명> --private --source=. --remote=origin --push`를 실행할지 묻는다. `SCAFFOLD_PUSH=y` 또는 `n`으로 미리 정할 수 있고, 터미널이 아닌 곳(에이전트 실행)에서는 묻지 않고 만들지 않는다. 문서에 적을 사용자 이름은 `SCAFFOLD_USER`(기본은 `git config user.name`, 없으면 "사용자").

## 고친 것 (2026-10-16)

- 이미 있는 폴더를 옮기는 절차를 스킬 5절에 더했다. 폴더 안의 git 저장소는 submodule로, bundle의 가지는 `code/scripts/restore-bundles.sh`로 모은다. 큰 파일은 중복·원자료·산출물로 나눠 `_local/`과 `.gitignore`로 뺀다.
- 틀에 자동 저장(`autosync.sh`, launchd plist)을 넣었다. 자리표시자 `{{폴더경로}}`를 더했다.

## 고친 것 (2026-10-15)

- `--existing`에서 치환이 대상 폴더의 모든 `.md`에 걸려 기존 양식의 자리표시자를 덮던 문제. 넣은 파일 목록을 따로 적고 그 목록에만 치환한다.
- 같은 이유로 기존 파일 이름의 `{{오늘}}`까지 바꾸던 문제.
- 새 저장소에서 기준선 해시가 늘 "없음"으로 적히던 것. 첫 커밋을 가리키는 문구로 둔다.
- 터미널이 아닌 곳에서 `read`가 실패해 스크립트가 오류로 끝나던 것.
- 설명에 `|`나 `&`가 있으면 치환이 깨지던 것.
- 자리표시자에 조사가 붙어 있어(`{{산출물}}을`, `{{금지행위}}는`) 기본값 "원고", "실험 실행"에서도 "원고을", "실험 실행는"이 되던 것. 조사가 값에 붙지 않게 문장을 고쳤다.

## 폴더 구조

    AGENTS.md            Codex가 읽는 규칙. CLAUDE.md는 이 파일을 가리킨다
    CLAUDE.md
    .gitignore           비밀값, 가상환경, 원자료, 큰 결과 파일 제외
    .env.example         키 이름만. 실제 값은 .env(커밋 금지)
    README.md            프로젝트 지도
    00-교류/             두 도구의 교류. 현황.md가 단일 기준
      log/               세션 기록. 세션마다 파일 하나라 충돌이 나지 않는다
      <도구1>-to-<도구2>/ <도구2>-to-<도구1>/   인계 노트(도구가 둘일 때만)
    docs/                설정, 연구계획, 할일목록, 승인기록
      맡김/              자리를 비운 동안 맡긴 작업의 지시서와 검토서
    manuscript/          원고. 지난 판은 구판/
    code/                실험 코드. 투고용 artifact는 여기서만 뽑는다
      scripts/export-artifact.sh
      scripts/autosync.sh, scripts/launchd/autosync.plist   사용자 컴퓨터의 자동 커밋·push(설치는 사용자)
    _local/              git 제외. bundle, 압축 중복본, 자동 저장 기록
    data/                raw는 git 제외, processed는 작은 것만
    results/             raw는 git 제외, summary만 커밋

## 설계 원칙

- 기준은 GitHub main이다. 맥 폴더, Claude 클라우드, Codex 클라우드는 모두 클론이다. 세션은 pull로 시작해 push로 끝낸다.
- 브랜치는 main 하나. 같은 산출물을 동시에 고치지 않는 담당 규칙이 충돌을 막는다.
- 세션 기록은 세션마다 파일 하나로 남긴다. 한 파일 맨 위에 끼워 넣는 방식은 두 도구가 겹치면 거의 매번 충돌한다.
- 작업 저장소에는 무엇이든 넣는다. 투고용 artifact는 `code/`를 새 이력으로 뽑아 별도 저장소로 낸다. 거기에는 프로젝트 이름과 AI 흔적을 남기지 않는다.

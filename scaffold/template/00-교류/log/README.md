# 세션 대장

세션마다 파일 하나. 파일명 `YYYY-MM-DD-NN-도구.md` (NN은 그날의 일련번호, 01부터).
한 파일을 여럿이 고치지 않으므로 병합 충돌이 나지 않는다. 최근 것부터 보려면 `ls -r`.

양식:

    ---
    date: YYYY-MM-DD
    who: claude | chatgpt
    commit: abc1234   # 이 세션의 마지막 커밋. 없으면 "미커밋"
    note: claude-to-chatgpt/YYYY-MM-DD-01-주제.md   # 인계 노트. 없으면 "없음"
    ---
    (한두 줄 요약. 무엇을 했고 다음에 무엇이 남았나)

# NotebookLM MCP Runbook

목적: NotebookLM MCP 연동 상태를 점검하고, Analysis-to-Action 루틴으로 연결한다.

## 1. 등록 상태 확인
1. `codex mcp list`
2. `notebooklm` 항목이 `enabled`인지 확인

## 2. 인증/호출 점검 체크리스트
1. NotebookLM MCP에서 요구하는 인증 방식 확인
2. 필요 환경변수 등록 후 서버 재기동
3. 샘플 질의 1건 실행(결정 근거 재확인 템플릿)
4. 결과를 `docs/context/notebooklm-analysis-action-log.md`에 기록

## 3. 실패 시 대체 루틴
1. NotebookLM 웹에서 수동 질의/요약 수행
2. 결과를 L1 문서(`docs/context/*`, `docs/planning/*`)에 반영
3. `notebooklm-analysis-action-log.md`에 반영 사실 기록

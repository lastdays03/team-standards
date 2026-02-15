# team-standards

공통 운영 규칙 템플릿 저장소.

## 목적
- 새 프로젝트 시작 시 공통 규칙/컨텍스트 문서를 한 번에 적용한다.
- 프로젝트별 예외는 각 프로젝트 `docs/context/decisions.md`에 별도 기록한다.

## 구성
- `templates/AGENTS.template.md`
- `templates/docs/context/README.md`
- `templates/docs/context/ops-rules.md`
- `templates/docs/context/dev-status.md`
- `templates/docs/context/decisions.md`
- `templates/docs/context/handoff.md`
- `scripts/apply-standards.sh`
- `scripts/install.sh`

## 빠른 설치(curl)
```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install.sh | bash -s -- <target-repo-path> <project-name>
```

예시:
```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install.sh | bash -s -- ~/dev/my-new-project my-new-project
```

## 로컬 사용법
```bash
./scripts/apply-standards.sh <target-repo-path> <project-name>
```

예시:
```bash
./scripts/apply-standards.sh ~/dev/my-new-project my-new-project
```

## 업데이트 원칙
- 공통 규칙 변경은 이 저장소에서 PR로 먼저 확정한다.
- 각 프로젝트는 필요 시 동일 명령으로 재적용하고, 충돌은 프로젝트에서 머지한다.

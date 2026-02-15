# team-standards

공통 운영 규칙 템플릿 저장소.

## 목적
- 새 프로젝트 시작 시 공통 규칙/컨텍스트 문서를 한 번에 적용한다.
- 글로벌 규칙을 먼저 적용하고, 프로젝트 예외는 `docs/context/decisions.md`에 기록한다.

## 구성
- `templates/AGENTS.template.md`
- `templates/docs/context/global-rules.md`
- `templates/docs/context/README.md`
- `templates/docs/context/ops-rules.md`
- `templates/docs/context/dev-status.md`
- `templates/docs/context/decisions.md`
- `templates/docs/context/handoff.md`
- `scripts/apply-standards.sh`
- `scripts/install.sh`

## 빠른 설치(curl)
현재 폴더에 바로 설치:
```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install.sh | bash
```

현재 폴더 + 프로젝트명 지정:
```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install.sh | bash -s -- my-new-project
```

대상 경로 + 프로젝트명 지정:
```bash
curl -fsSL https://raw.githubusercontent.com/lastdays03/team-standards/main/scripts/install.sh | bash -s -- ~/dev/my-new-project my-new-project
```

## 로컬 사용법
현재 폴더에 바로 적용:
```bash
./scripts/apply-standards.sh
```

프로젝트명만 지정:
```bash
./scripts/apply-standards.sh my-new-project
```

대상 경로 + 프로젝트명 지정:
```bash
./scripts/apply-standards.sh ~/dev/my-new-project my-new-project
```

## 적용 순서
1. `docs/context/global-rules.md` 확인(글로벌 공통)
2. `AGENTS.md` 확인(레포 레벨 규칙)
3. `docs/context/ops-rules.md`/`dev-status.md`/`decisions.md`/`handoff.md` 운영 시작

## 업데이트 원칙
- 공통 규칙 변경은 이 저장소에서 PR로 먼저 확정한다.
- 각 프로젝트는 필요 시 동일 명령으로 재적용하고, 충돌은 프로젝트에서 머지한다.

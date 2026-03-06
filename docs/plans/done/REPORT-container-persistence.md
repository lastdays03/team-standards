# 컨테이너 재시작 시 환경 유지 분석 보고서

**작성일:** 2026-03-05
**대상:** code-server 컨테이너 (lscr.io/linuxserver/code-server:latest 기반)

---

## 1. 아키텍처 요약

```
Host
├── ./config  →  /config (볼륨 마운트, abc 유저 홈 $HOME=/config)
├── ./project →  /config/workspace (볼륨 마운트, 프로젝트 소스)
└── Docker Compose
     ├── dind (Docker-in-Docker, docker-data 볼륨)
     └── code-server (개발 환경)
```

**영속성 원리:**
- **이미지 레이어** (`/usr`, `/etc`, `/usr/local` 등): Dockerfile의 RUN/COPY 명령으로 생성. 이미지 재빌드 시 재생성되지만, 런타임에 수동 설치한 것은 유실됨.
- **/config 볼륨**: 호스트의 `./config`을 마운트. 컨테이너와 독립적으로 항상 유지.
- **런타임 변경 사항** (`/etc`, `/usr` 등 볼륨 외 경로): 컨테이너 재생성(down/up, build) 시 유실.

---

## 2. 유지되는 환경

### 2.1 Dockerfile 이미지 레이어 — 이미지 재빌드해도 유지

| 항목 | 경로 | 출처 |
|------|------|------|
| Python 3.12.3 | `/usr/bin/python3` | Dockerfile apt 설치 |
| Node.js 22.14.0 | `/usr/local/bin/node` | Dockerfile 바이너리 직접 설치 |
| npm 10.9.2 | `/usr/local/bin/npm` | Node.js 번들 |
| corepack 0.31.0 | `/usr/local/bin/corepack` | Node.js 번들 |
| uv 0.10.6 | `/usr/local/bin/uv` | Dockerfile COPY --from |
| uvx | `/usr/local/bin/uvx` | Dockerfile COPY --from |
| Docker CLI 27.4.1 | `/usr/local/bin/docker` | Dockerfile 바이너리 직접 설치 |
| Docker Compose v5.1.0 | `/usr/local/lib/docker/cli-plugins/` | Dockerfile 바이너리 직접 설치 |
| vim 9.1 | `/usr/bin/vim` | Dockerfile apt 설치 |
| tmux 3.4 | `/usr/bin/tmux` | Dockerfile apt 설치 |
| build-essential, libpq-dev | 시스템 경로 | Dockerfile apt 설치 |
| Playwright 시스템 의존성 | `/usr/lib/` | Dockerfile apt 설치 (libnss3, libgbm1 등 15개) |
| git 2.43.0 | `/usr/bin/git` | base 이미지 s6-init 스크립트 |
| nano | `/usr/bin/nano` | base 이미지 s6-init 스크립트 |
| sudo | `/usr/bin/sudo` | base 이미지 s6-init 스크립트 |
| curl | `/usr/bin/curl` | base 이미지 기본 포함 |
| abc 유저 sudo 권한 | `/etc/sudoers.d/abc-nopasswd` | Dockerfile 설정 |

### 2.2 /config 볼륨 — 항상 유지 (컨테이너와 무관)

| 항목 | 경로 | 크기 |
|------|------|------|
| 프로젝트 소스코드 | `/config/workspace/` | 2.3G |
| Claude Code 바이너리 | `/config/.local/share/claude/versions/` | 227M (정리 후) |
| Claude Code 설정/이력/플러그인 | `/config/.claude/` | 324M |
| VS Code 확장 (14개) | `/config/extensions/` | ~1.4G (정리 후) |
| code-server 데이터/설정 | `/config/data/` | ~15M (캐시 정리 후) |
| npm 글로벌 패키지 (pnpm, codex) | `/config/.npm-global/` | 105M |
| DB Client (JDBC) | `/config/.dbclient/` | 16M |
| OpenAI Codex 설정 | `/config/.codex/` | 932K |
| uv 캐시 | `/config/.cache/uv/` | - |
| pnpm 캐시 | `/config/.cache/pnpm/` | - |
| npm 캐시 | `/config/.npm/` | - |
| Git 인증 (GitHub 토큰) | `/config/.git-credentials` | - |
| Git 설정 (credential helper) | `/config/.gitconfig` | - |
| GitHub CLI 인증 (lastdays03) | `/config/.config/gh/hosts.yml` | - |
| SSH known_hosts | `/config/.ssh/known_hosts` | - |
| npm 설정 (prefix) | `/config/.npmrc` | - |
| bash 설정 (PATH 커스텀) | `/config/.bashrc` | - |
| tmux 설정 (mouse on) | `/config/.tmux.conf` | - |
| bash 히스토리 | `/config/.bash_history` | - |
| VS Code settings.json | `/config/data/User/settings.json` | - |
| code-server config | `/config/.config/code-server/config.yaml` | - |

---

## 3. 유지되지 않는 환경

### 3.1 🔴 이미지 재빌드 시 유실 — Dockerfile에 없는 런타임 설치 항목

apt history log (`/var/log/apt/history.log`) 분석 결과, 다음 3개 패키지가 **컨테이너 런타임에 수동 설치**되었으며 Dockerfile에 정의되어 있지 않다.

| 패키지 | 설치일 | 설치 경로 | 설치 명령 | 영향 |
|--------|--------|----------|----------|------|
| **xclip** | 02-28 | `/usr/bin/xclip` | `apt install -y xclip` | 클립보드 연동. 없어도 개발에 큰 지장 없음 |
| **wget** | 03-02 | `/usr/bin/wget` | `apt-get install wget -y` | curl로 대체 가능하나, 스크립트에서 wget 사용 시 실패 |
| **gh** (apt) | 03-03 | `/usr/bin/gh` (v2.87.3) | `apt install gh -y -qq` | GitHub CLI. /config/bin/gh도 있으나 PATH 우선순위가 다름 |

**추가 유실 항목 (gh 관련):**

| 항목 | 경로 | 설명 |
|------|------|------|
| GitHub CLI apt 소스 | `/etc/apt/sources.list.d/github-cli.list` | apt repo 설정 |
| GitHub CLI apt 소스 (중복) | `/etc/apt/sources.list.d/github-cli-stable.list` | apt repo 설정 |
| GPG 키 | `/etc/apt/keyrings/githubcli-archive-keyring.gpg` | apt 서명 키 |

> **gh CLI 참고:**
> - `/usr/bin/gh` (v2.87.3, apt 설치) ← 현재 PATH에서 실행되는 유일한 gh
> - `/config/bin/gh`는 PATH에 없어 미사용 상태였으며, **정리 완료 (03-05 삭제, 48MB 회수)**
>
> 이미지 재빌드 시 `/usr/bin/gh`가 사라지면 gh 명령을 사용할 수 없다. Dockerfile에 gh 설치를 추가해야 한다.

### 3.2 🟡 프로젝트 의존성 — 현재 미설치 상태

| 항목 | 경로 | 상태 | 복구 명령 |
|------|------|------|----------|
| backend Python venv | `backend/.venv/` | **없음** | `uv venv && uv pip install -e .[dev]` |
| frontend node_modules | `frontend/node_modules/` | **없음** | `pnpm install` |
| Playwright 브라우저 | `/config/.cache/ms-playwright/` | **비어있음** (시스템 의존성만 존재) | `pnpm exec playwright install chromium` |
| pre-commit | - | **미설치** | `pip3 install pre-commit && pre-commit install` |

> 참고: venv와 node_modules가 있었다면 /config/workspace 볼륨에 있으므로 재시작 후에도 유지된다. 현재는 설치 자체가 되어 있지 않은 상태.

### 3.3 🟠 컨테이너 재생성 시 항상 유실되는 런타임 상태

| 항목 | 설명 |
|------|------|
| 실행 중인 프로세스 | uvicorn, pnpm dev, tmux 등 모든 프로세스 종료 |
| tmux 세션 | 모든 세션 소멸 |
| /tmp 파일 | 임시 파일 전부 삭제 (VSCODE_IPC_HOOK 등) |
| 환경변수 (런타임 주입) | Docker Compose env로 재주입되므로 실질적 영향 없음 |

---

## 4. /config 볼륨 내 도구의 정확한 동작 분석

Dockerfile에 없지만 /config에 설치되어 **볼륨 덕분에 유지되는** 항목들의 정확한 상태:

| 도구 | 설치 위치 | PATH 포함 | 이미지 재빌드 후 동작 |
|------|----------|:---------:|---------------------|
| **pnpm** 10.30.3 | `/config/.npm-global/bin/pnpm` | ✅ (.bashrc에서 추가) | ✅ 정상 작동 |
| **codex** (OpenAI) | `/config/.npm-global/bin/codex` | ✅ (.bashrc에서 추가) | ✅ 정상 작동 |
| **claude** 2.1.69 | `/config/.local/bin/claude` | ✅ (.bashrc에서 추가) | ✅ 정상 작동 |
| ~~**gh** (수동)~~ | ~~`/config/bin/gh`~~ | - | **삭제 완료** (03-05, PATH에 없어 미사용이었음) |

> **핵심:** `.bashrc`에 설정된 PATH는 `/config/.local/bin:/config/.npm-global/bin:$PATH` 이다.
> gh는 `/usr/bin/gh` (apt 설치)만 사용 중이며, Dockerfile에 없으므로 재빌드 시 재설치 필요.

---

## 5. 잠재적 위험 요소

### 5.1 디스크 정리 완료 (03-05 실시)

**정리 전:** 88% (5.5GB 여유) → **정리 후:** 85% (7.0GB 여유) — **약 1.5GB 회수**

| 항목 | 절약 | 상태 |
|------|------|------|
| Claude Code 구버전 4개 (2.1.62/63/66/68) | ~885MB | ✅ 삭제 완료 |
| VS Code 구 확장 3개 (claude-code 2.1.66, rainbow-csv 3.3.0, chatgpt 0.4.78) | ~100MB | ✅ 삭제 완료 |
| `/config/bin/gh` (미사용 중복 바이너리) | 48MB | ✅ 삭제 완료 |
| VS Code CachedExtensionVSIXs (.trash) | ~428MB | ✅ 삭제 완료 |

현재 Claude Code 버전:
```
/config/.local/share/claude/versions/
└── 2.1.69  (227MB)  ← 유일한 버전, 현재 심볼릭 링크 대상
```

### 5.2 gh CLI apt source 중복

```
/etc/apt/sources.list.d/github-cli.list        ← 03-02 생성
/etc/apt/sources.list.d/github-cli-stable.list  ← 03-03 생성
```

동일 내용의 apt source가 두 번 등록됨. 이미지 재빌드 시 자연 정리되지만, Dockerfile에 추가할 경우 하나만 등록해야 함.

---

## 6. 환경 분류 매트릭스

| 시나리오 | 이미지 레이어 | 런타임 apt 설치 | /config 볼륨 | 런타임 프로세스 |
|---------|:----------:|:------------:|:-----------:|:------------:|
| `docker compose restart` | ✅ 유지 | ✅ 유지 | ✅ 유지 | ❌ 소멸 |
| `docker compose stop && start` | ✅ 유지 | ✅ 유지 | ✅ 유지 | ❌ 소멸 |
| `docker compose down && up` | ✅ 유지* | ❌ **유실** | ✅ 유지 | ❌ 소멸 |
| `docker compose build && up` | ✅ 재빌드 | ❌ **유실** | ✅ 유지 | ❌ 소멸 |
| `docker compose build --no-cache` | ✅ 재생성 | ❌ **유실** | ✅ 유지 | ❌ 소멸 |
| 볼륨 삭제 후 up | ✅ 유지 | ❌ 유실 | ❌ **전체 소멸** | ❌ 소멸 |

> *`down && up`은 컨테이너를 삭제/재생성하므로 이미지 레이어 외 런타임 변경(apt 설치 등)은 유실됨.
> `restart`는 동일 컨테이너를 재시작하므로 런타임 설치도 유지됨.

---

## 7. Dockerfile 개선 제안

### 7.1 누락 패키지 추가

```dockerfile
# ── 런타임에 수동 설치했던 패키지 ──
RUN apt-get update && apt-get install -y --no-install-recommends \
    xclip wget \
    && rm -rf /var/lib/apt/lists/*

# ── GitHub CLI ──
RUN (type -p wget >/dev/null || apt-get install wget -y) \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       | tee /etc/apt/sources.list.d/github-cli-stable.list > /dev/null \
    && apt-get update && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*
```

### 7.2 선택적 개선

| 항목 | 현재 | 제안 | 이유 |
|------|------|------|------|
| pnpm | /config/.npm-global에 npm으로 설치 | 현재 방식 유지 | /config에 있어 유지됨. 변경 불필요 |
| pre-commit | 미설치 | `RUN pip3 install pre-commit` | CLAUDE.md에서 사용 명시 |

---

## 8. 재빌드 후 복구 체크리스트

이미지 재빌드(`docker compose build`) 후 Dockerfile에 위 패키지를 추가하지 않은 경우:

```bash
# 1. 런타임 apt 패키지 재설치
sudo apt-get update
sudo apt-get install -y xclip wget

# 2. gh CLI 재설치
(type -p wget >/dev/null || sudo apt-get install wget -y) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
     | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
     | sudo tee /etc/apt/sources.list.d/github-cli-stable.list > /dev/null \
  && sudo apt-get update && sudo apt-get install gh -y

# 3. Backend 개발 환경
cd /config/workspace/team-standards/backend
uv venv && source .venv/bin/activate
uv pip install -e .[dev]

# 4. Frontend 개발 환경
cd /config/workspace/team-standards/frontend
pnpm install

# 5. Playwright 브라우저 (E2E 테스트 필요시)
pnpm exec playwright install chromium

# 6. pre-commit (린팅 필요시)
pip3 install pre-commit
cd /config/workspace/team-standards && pre-commit install
```

---

## 9. 결론

### 유실 위험 요약

| 위험도 | 항목 | 경로 | 시나리오 |
|:-----:|------|------|---------|
| 🔴 | **xclip** | `/usr/bin/xclip` | down/up, build 시 유실 |
| 🔴 | **wget** | `/usr/bin/wget` | down/up, build 시 유실 |
| 🔴 | **gh CLI** (apt) | `/usr/bin/gh` | down/up, build 시 유실 |
| 🔴 | **gh apt source + GPG 키** | `/etc/apt/sources.list.d/`, `/etc/apt/keyrings/` | down/up, build 시 유실 |
| 🟡 | backend venv | `workspace/.../backend/.venv/` | 현재 미설치 (설치 시 볼륨에 유지됨) |
| 🟡 | frontend node_modules | `workspace/.../frontend/node_modules/` | 현재 미설치 (설치 시 볼륨에 유지됨) |
| 🟡 | Playwright 브라우저 | `/config/.cache/ms-playwright/` | 현재 미설치 (설치 시 볼륨에 유지됨) |
| 🟡 | pre-commit | - | 현재 미설치 |

### 완료된 조치 (03-05)

| 조치 | 상태 | 회수 용량 |
|------|:----:|----------|
| `/config/bin/gh` 삭제 (미사용 중복) | ✅ | 48MB |
| Claude Code 구버전 4개 삭제 | ✅ | ~885MB |
| VS Code 구 확장 3개 삭제 | ✅ | ~100MB |
| CachedExtensionVSIXs 정리 | ✅ | ~428MB |
| **합계** | | **~1.5GB** |

### 남은 권장 조치

1. Dockerfile에 `xclip`, `wget`, `gh` 추가하여 이미지 레이어로 고정
2. 프로젝트 의존성(venv, node_modules)은 필요 시 설치 — 볼륨 경로이므로 한번 설치하면 유지됨

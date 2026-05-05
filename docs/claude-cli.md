# Claude CLI (claude --help)

> 기준일: 2026-05-05  
> 버전 확인: `claude --version`

```
Usage: claude [options] [command] [prompt]
```

Claude Code - 기본적으로 대화형 세션을 시작하며, `-p/--print` 옵션으로 비대화형 출력 가능

---

## 주요 옵션

### 세션 제어

| 옵션 | 설명 |
|------|------|
| `-c, --continue` | 현재 디렉토리의 최근 대화 이어하기 |
| `-r, --resume [value]` | 세션 ID로 대화 재개, 또는 인터랙티브 픽커 열기 |
| `--fork-session` | 재개 시 새 세션 ID 생성 (`--resume`, `--continue`와 함께 사용) |
| `-n, --name <name>` | 세션 표시 이름 설정 |
| `--session-id <uuid>` | 특정 세션 ID 지정 |
| `--no-session-persistence` | 세션을 디스크에 저장하지 않음 (`--print`와 함께) |
| `-w, --worktree [name]` | git worktree를 생성하고 세션 시작 |

### 모델 및 성능

| 옵션 | 설명 |
|------|------|
| `--model <model>` | 모델 지정 (예: `sonnet`, `opus`, `claude-sonnet-4-6`) |
| `--effort <level>` | 노력 수준: `low`, `medium`, `high`, `xhigh`, `max` |
| `--fallback-model <model>` | 기본 모델 과부하 시 자동 폴백 모델 (`--print`와 함께) |
| `--agent <agent>` | 현재 세션의 에이전트 지정 |

### 출력 형식

| 옵션 | 설명 |
|------|------|
| `-p, --print` | 응답 출력 후 종료 (파이프 등 비대화형 사용) |
| `--output-format <format>` | 출력 형식: `text`(기본), `json`, `stream-json` |
| `--input-format <format>` | 입력 형식: `text`(기본), `stream-json` |
| `--include-partial-messages` | 스트리밍 중 부분 메시지 포함 (`--print`, `stream-json`과 함께) |
| `--json-schema <schema>` | 구조화된 출력을 위한 JSON Schema 지정 |

### 권한 및 보안

| 옵션 | 설명 |
|------|------|
| `--permission-mode <mode>` | 권한 모드: `acceptEdits`, `auto`, `bypassPermissions`, `default`, `dontAsk`, `plan` |
| `--dangerously-skip-permissions` | 모든 권한 확인 우회 (샌드박스 전용 권장) |
| `--allow-dangerously-skip-permissions` | 권한 우회 옵션 활성화 (기본값 아님) |
| `--allowedTools <tools...>` | 허용할 도구 목록 (예: `"Bash(git *) Edit"`) |
| `--disallowedTools <tools...>` | 거부할 도구 목록 |
| `--tools <tools...>` | 사용 가능한 도구 목록 지정 (`""`: 전체 비활성화, `"default"`: 전체 활성화) |

### 시스템 프롬프트

| 옵션 | 설명 |
|------|------|
| `--system-prompt <prompt>` | 세션용 시스템 프롬프트 지정 |
| `--append-system-prompt <prompt>` | 기본 시스템 프롬프트에 추가 |

### MCP 및 플러그인

| 옵션 | 설명 |
|------|------|
| `--mcp-config <configs...>` | JSON 파일 또는 문자열로 MCP 서버 로드 |
| `--strict-mcp-config` | `--mcp-config`의 MCP 서버만 사용 |
| `--plugin-dir <path>` | 세션 전용 플러그인 디렉토리 또는 `.zip` 로드 |

### 기타

| 옵션 | 설명 |
|------|------|
| `--add-dir <directories...>` | 도구 접근을 허용할 추가 디렉토리 |
| `--bare` | 최소 모드: hooks, LSP, 자동 메모리 등 비활성화 |
| `-d, --debug [filter]` | 디버그 모드 활성화 (카테고리 필터 지원) |
| `--verbose` | 상세 출력 모드 |
| `--ide` | 실행 시 IDE 자동 연결 |
| `--chrome` | Claude in Chrome 통합 활성화 |
| `--max-budget-usd <amount>` | API 호출 최대 지출 금액 제한 (`--print`와 함께) |
| `--betas <betas...>` | 베타 헤더 포함 (API 키 사용자 전용) |
| `-v, --version` | 버전 출력 |
| `-h, --help` | 도움말 출력 |

---

## 하위 커맨드 (Commands)

| 커맨드 | 설명 |
|--------|------|
| `agents` | 백그라운드 및 설정된 에이전트 관리 |
| `auth` | 인증 관리 |
| `auto-mode` | 자동 모드 분류기 설정 확인 |
| `doctor` | Claude Code 자동 업데이터 상태 점검 |
| `install [target]` | 네이티브 빌드 설치 (`stable`, `latest`, 또는 특정 버전) |
| `mcp` | MCP 서버 설정 및 관리 |
| `plugin\|plugins` | Claude Code 플러그인 관리 |
| `project` | Claude Code 프로젝트 상태 관리 |
| `setup-token` | 장기 인증 토큰 설정 (Claude 구독 필요) |
| `ultrareview [target]` | 멀티 에이전트 클라우드 코드 리뷰 실행 |
| `update\|upgrade` | 업데이트 확인 및 설치 |

---

## 사용 예시

```bash
# 대화형 세션 시작
claude

# 특정 모델로 시작
claude --model opus
claude --model claude-sonnet-4-6

# 비대화형 단일 응답
claude -p "이 코드를 리뷰해줘"

# 이전 대화 이어하기
claude --continue

# 세션 ID로 재개
claude --resume <session-id>

# 스트리밍 JSON 출력
claude -p --output-format stream-json "질문"

# 도구 제한
claude --allowedTools "Bash(git *) Read"

# 최대 비용 제한
claude -p --max-budget-usd 0.50 "질문"

# git worktree에서 새 세션
claude --worktree feature-branch

# 멀티 에이전트 코드 리뷰
claude ultrareview
claude ultrareview 123  # PR 번호
```

---

## 현재 모델 및 토큰 확인

전용 CLI 커맨드는 없으며, **대화형 세션 내 슬래시 커맨드**로 확인해야 합니다.

| 슬래시 커맨드 | 설명 |
|-------------|------|
| `/model` | 현재 세션에서 사용 중인 모델 확인 및 변경 |
| `/cost` | 현재 세션의 누적 토큰 사용량 및 비용 확인 |
| `/status` | 세션 상태 정보 확인 (모델, 설정 등) |

```bash
# 세션 시작 후 슬래시 커맨드로 확인
claude
> /model    # 현재 모델 확인
> /cost     # 토큰 사용량 및 비용 확인
```

> 세션 외부(CLI 레벨)에서 현재 모델이나 토큰을 조회하는 커맨드는 제공되지 않음.  
> 모델 지정은 시작 시 `--model` 옵션으로만 가능: `claude --model sonnet`

---

## 참고 링크

- [Claude Code 공식 문서](https://docs.anthropic.com/en/docs/claude-code)
- [MCP 서버 설정](https://docs.anthropic.com/en/docs/claude-code/mcp)

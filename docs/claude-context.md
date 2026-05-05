# Claude Code 현재 컨텍스트 정리

> 작성일: 2026-05-05

---

## 1. 컨텍스트란?

Claude Code 세션에서 "컨텍스트"는 Claude가 현재 대화에서 알고 있는 모든 정보를 의미합니다.  
컨텍스트는 크게 **자동 주입 정보**와 **대화 중 누적 정보**로 나뉩니다.

---

## 2. 컨텍스트 확인 방법

| 방법 | 명령 / 위치 | 내용 |
|------|------------|------|
| 시스템 프롬프트 | Claude Code 내부 자동 주입 | 환경, 모델, 날짜, 사용자 이메일 등 |
| git 상태 | `git status`, `git log` | 현재 브랜치, 커밋 히스토리 |
| 메모리 시스템 | `~/.claude/projects/<path>/memory/` | 이전 대화에서 저장된 장기 기억 |
| CLAUDE.md | 프로젝트 루트 | 프로젝트별 지속 지침 |
| `system-reminder` 태그 | 각 메시지에 자동 포함 | 스킬 목록, 지연 도구 목록, 날짜/이메일 등 |

---

## 3. 현재 세션 컨텍스트 (2026-05-05 기준)

### 3.1 환경 정보

| 항목 | 값 |
|------|----|
| 작업 디렉토리 | `/Users/gunhaa/dev/claude_code` |
| 플랫폼 | macOS (darwin 25.3.0) |
| 셸 | zsh |
| git 사용자 | gunhaa |
| 원격 저장소 | https://github.com/gunhaa/claude_code.git |
| 현재 브랜치 | main |

### 3.2 모델 정보

| 항목 | 값 |
|------|----|
| 현재 모델 | claude-sonnet-4-6 (Claude Sonnet 4.6) |
| 지식 컷오프 | 2025년 8월 |
| 최신 Claude 패밀리 | Claude 4.X |
| 주요 모델 ID | Opus 4.7: `claude-opus-4-7` / Sonnet 4.6: `claude-sonnet-4-6` / Haiku 4.5: `claude-haiku-4-5-20251001` |

### 3.3 사용자 정보

| 항목 | 값 |
|------|----|
| 이메일 | wh8299@gmail.com |
| 오늘 날짜 | 2026-05-05 |

### 3.4 git 상태

```
브랜치: main (clean - 변경사항 없음)
최근 커밋: a0c2150 docs: add Claude models and CLI reference documentation
```

### 3.5 프로젝트 파일 구조

```
/Users/gunhaa/dev/claude_code/
└── docs/
    ├── claude-cli.md       # Claude CLI 참조 문서
    ├── claude-models.md    # Claude 모델 참조 문서
    └── claude-context.md   # 이 파일
```

---

## 4. 자동 주입되는 컨텍스트 항목

Claude Code는 매 세션마다 다음 정보를 자동으로 컨텍스트에 포함합니다.

- **gitStatus**: 대화 시작 시점의 git 상태 스냅샷 (브랜치, 최근 커밋)
- **currentDate**: 오늘 날짜
- **userEmail**: 사용자 이메일
- **system-reminder**: 사용 가능한 스킬 목록, 지연 도구 목록
- **환경 정보**: OS, 셸, 작업 디렉토리, 모델 ID

---

## 5. 장기 메모리 시스템

Claude Code는 대화 간 기억을 유지하기 위해 파일 기반 메모리를 사용합니다.

- **위치**: `~/.claude/projects/<프로젝트경로>/memory/`
- **인덱스 파일**: `MEMORY.md` (각 메모리 파일의 포인터)
- **메모리 유형**:

| 유형 | 설명 |
|------|------|
| `user` | 사용자 역할, 선호, 지식 수준 |
| `feedback` | 사용자가 준 피드백 및 행동 지침 |
| `project` | 현재 프로젝트의 목표, 마감, 결정 사항 |
| `reference` | 외부 시스템(Linear, Grafana 등) 위치 정보 |

> 현재 이 프로젝트의 메모리 디렉토리는 비어 있습니다.

---

## 6. 사용 가능한 스킬 (Skill 도구)

| 스킬 이름 | 설명 |
|-----------|------|
| `update-config` | settings.json 설정 변경, 훅 구성 |
| `keybindings-help` | 키보드 단축키 커스터마이징 |
| `simplify` | 변경된 코드 품질 리뷰 및 개선 |
| `fewer-permission-prompts` | 권한 프롬프트 줄이기 위한 허용 목록 추가 |
| `loop` | 반복 실행 작업 설정 |
| `schedule` | 원격 에이전트 스케줄링 |
| `claude-api` | Claude API / Anthropic SDK 앱 개발 |
| `init` | CLAUDE.md 초기화 |
| `review` | PR 코드 리뷰 |
| `security-review` | 보안 검토 |

---

## 7. 지연 도구 (ToolSearch로 스키마 로드 필요)

다음 도구들은 이름만 알려진 상태이며, 사용 전 `ToolSearch`로 스키마를 로드해야 합니다.

`AskUserQuestion`, `CronCreate`, `CronDelete`, `CronList`, `EnterPlanMode`, `EnterWorktree`, `ExitPlanMode`, `ExitWorktree`, `Monitor`, `NotebookEdit`, `PushNotification`, `RemoteTrigger`, `TaskCreate`, `TaskGet`, `TaskList`, `TaskOutput`, `TaskStop`, `TaskUpdate`, `WebFetch`, `WebSearch`, `mcp__ide__executeCode`, `mcp__ide__getDiagnostics`

---

## 8. 컨텍스트 한계

- 컨텍스트 창이 꽉 차면 오래된 메시지는 자동으로 압축됩니다.
- `gitStatus`는 대화 시작 시점의 스냅샷이므로 이후 변경사항은 반영되지 않습니다.
- 메모리 파일이 오래되면 내용이 현재 코드와 맞지 않을 수 있으므로 항상 실제 파일을 우선 확인합니다.

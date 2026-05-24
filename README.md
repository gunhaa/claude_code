# claude_code

Claude Code 사용 레퍼런스 저장소입니다.  
Claude Code의 동작 원리, 설정 방법, 효과적인 사용 팁을 정리하고, 새 프로젝트에 바로 사용할 수 있는 보일러플레이트를 제공합니다.

---

## 폴더 구조

```
claude_code/
├── CLAUDE.md              # 이 저장소에 대한 Claude 작업 지침
├── README.md              # 이 파일
│
├── docs/                  # Claude Code 동작 및 설정 레퍼런스 문서
│   ├── claude-models.md           # Claude 모델 종류 및 ID 정리
│   ├── claude-cli.md              # Claude CLI 명령어 레퍼런스
│   ├── claude-context.md          # 세션 컨텍스트 구성 요소 정리
│   ├── claude-file-loading-order.md  # CLAUDE.md 로드 순서 및 계층 구조
│   ├── claude-vs-readme.md        # CLAUDE.md vs README.md 비교
│   └── claude-md-tips.md          # 효과적인 CLAUDE.md 작성 팁
│
├── boilerplate/           # 새 프로젝트 시작 시 복사할 템플릿
│   ├── CLAUDE.md              # 항목만 있는 메인 지침 템플릿
│   ├── CLAUDE.local.md        # 개인 설정 템플릿 (gitignore 권장)
│   └── .claude/rules/
│       ├── testing.md         # 테스트 규칙 템플릿
│       ├── git.md             # Git 워크플로우 템플릿
│       └── style.md           # 코드 스타일 템플릿
│
├── tips/                  # 영상 시리즈 치트시트 (basic / intermediate / advanced)
│   ├── README.md
│   ├── basic.md
│   ├── intermediate.md
│   └── advanced.md
│
└── feedback/              # 레거시. 컨텍스트 복원은 /memory 시스템 사용
    └── lessons-learned.md
```

---

## 빠른 시작

새 프로젝트에 보일러플레이트 적용:

```bash
cp -r boilerplate/. /path/to/new-project/
```

복사 후 `CLAUDE.md`의 각 항목을 프로젝트에 맞게 채우고,  
`CLAUDE.local.md`는 `.gitignore`에 추가하세요.

---

## 권장 워크플로우

상황별 워크플로우 요약입니다. 상세 내용은 [docs/claude-workflow.md](docs/claude-workflow.md)를 참고하세요.

| 상황 | 워크플로우 |
|------|-----------|
| 단순 기능 하나 추가 | Plan Mode → 작은 변경 → 테스트 → 커밋 반복 |
| 컨텍스트가 불어남 | `/compact` 또는 `/clear` + **한 세션 = 한 피처** 원칙 |
| 할 일이 많고 며칠에 걸침 | 프로젝트 루트에 `TODO.md` 작성 후 세션마다 업데이트 |
| 복잡한 멀티 모듈 작업 | WAT 프레임워크 — Workflow 글로 정의 → Sub-Agent 병렬 → 원자적 도구 |
| 반복 작업 자동화 | `.claude/skills/`에 SKILL.md 작성 + Hooks로 이벤트 연결 |
| 여러 기능 동시 개발 | `claude -w <branch>` Git Worktree 병렬 인스턴스 |

---

## docs 문서 목록

| 문서 | 내용 |
|------|------|
| [claude-workflow.md](docs/claude-workflow.md) | 상황별 권장 워크플로우 |
| [claude-shortcuts.md](docs/claude-shortcuts.md) | 단축키 & 슬래시 명령어 |
| [claude-memory.md](docs/claude-memory.md) | /memory 시스템, Lazy Loading, MCP 토큰 관리 |
| [claude-skills.md](docs/claude-skills.md) | Skills 시스템 (SKILL.md 작성법, 저장 위치) |
| [claude-agents.md](docs/claude-agents.md) | Sub-Agent 시스템 (내장 5종, 커스텀, 패턴) |
| [claude-hooks.md](docs/claude-hooks.md) | Hooks 자동화 (이벤트 타입, JSON 구조, 예시) |
| [claude-models.md](docs/claude-models.md) | Claude 모델 ID, 특징, 선택 기준 |
| [claude-cli.md](docs/claude-cli.md) | CLI 옵션 레퍼런스 |
| [claude-context.md](docs/claude-context.md) | 세션 컨텍스트 구성 요소 |
| [claude-file-loading-order.md](docs/claude-file-loading-order.md) | CLAUDE.md 로드 순서 |
| [claude-vs-readme.md](docs/claude-vs-readme.md) | CLAUDE.md vs README.md 비교 |
| [claude-md-tips.md](docs/claude-md-tips.md) | 효과적인 CLAUDE.md 작성 팁 |

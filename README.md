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
└── feedback/              # 실사용 중 발견한 팁 및 개선 사항
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

## docs 문서 목록

| 문서 | 내용 |
|------|------|
| [claude-models.md](docs/claude-models.md) | Claude 모델 ID, 특징, 선택 기준 |
| [claude-cli.md](docs/claude-cli.md) | CLI 명령어 및 옵션 |
| [claude-context.md](docs/claude-context.md) | 세션 컨텍스트 구성 요소 |
| [claude-file-loading-order.md](docs/claude-file-loading-order.md) | CLAUDE.md 로드 순서 |
| [claude-vs-readme.md](docs/claude-vs-readme.md) | CLAUDE.md vs README.md 비교 |
| [claude-md-tips.md](docs/claude-md-tips.md) | 효과적인 CLAUDE.md 작성 팁 |

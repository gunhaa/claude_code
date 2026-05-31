# agentic-workflow

기획→디자인→코딩→리뷰 4단계 에이전트와 자동 로깅 hook이 즉시 동작하는 Claude Code 워크플로우 보일러플레이트.

---

## 빠른 시작

```bash
# 1. 보일러플레이트 복사 (점 포함 — 숨김 파일까지)
cp -r boilerplate/agentic-workflow/. /path/to/new-project/

# 2. hook 실행 권한 부여
cd /path/to/new-project
chmod +x .claude/hooks/*.sh

# 3. 의존성 (jq 필요)
brew install jq    # macOS
# sudo apt install jq  # Debian/Ubuntu

# 4. Claude Code 실행
claude
```

이게 전부입니다. 첫 프롬프트를 보내면 `logs/prompts.jsonl` 파일이 자동 생성되고, 파일을 수정하면 `logs/file-changes.jsonl`에 기록됩니다.

---

## 폴더 구조

```
.
├── README.md                       # 이 파일 — 보일러플레이트 사용법
├── CLAUDE.md                       # Claude Code가 매 세션 로드하는 동작 지침
├── .gitignore                      # logs/*.jsonl 보호
├── .claude/
│   ├── settings.json               # hook 등록
│   ├── agents/
│   │   ├── planner.md              # 기획 (sonnet)
│   │   ├── designer.md             # 목업 디자인 (sonnet)
│   │   ├── coder.md                # 구현 (opus)
│   │   └── reviewer.md             # 코드 리뷰 (opus)
│   └── hooks/
│       ├── log-prompt.sh           # 사용자 프롬프트 로깅
│       └── log-file-change.sh      # 파일 변경 로깅
└── logs/                            # JSONL 로그 (git에서 제외)
```

---

## 4개 에이전트

| 에이전트 | 모델 | 트리거 표현 | 권한 |
|---------|------|------------|------|
| `planner` | sonnet | "기능 만들자", "어떻게 설계", "스펙 정리" | Read, Grep, Glob, WebSearch |
| `designer` | sonnet | "화면", "UI", "레이아웃", "와이어프레임" | Read, Grep, Glob, WebSearch |
| `coder` | opus | "구현해", "코드 작성해", plan 승인 후 자동 | Read, Edit, Write, Bash, Grep, Glob |
| `reviewer` | opus | "리뷰해", "검토", 코드 변경 직후 | Read, Grep, Glob, Bash |

수정/추가/삭제는 `.claude/agents/<name>.md`의 YAML frontmatter를 편집하면 됩니다.

---

## 2개 hook

| Hook | 이벤트 | 출력 파일 | 기록 내용 |
|------|--------|-----------|----------|
| `log-prompt.sh` | `UserPromptSubmit` | `logs/prompts.jsonl` | `{ts, session_id, cwd, prompt}` |
| `log-file-change.sh` | `PostToolUse(Write\|Edit)` | `logs/file-changes.jsonl` | `{ts, session_id, tool, file, action}` |

각 줄은 독립 JSON 객체 (JSON Lines 포맷).

---

## 기본 사용 흐름

1. **Plan Mode 진입** — `Shift+Tab` (또는 그냥 자연어로 "계획해줘")
2. **planner 자동 호출** — "X 기능 추가하고 싶어" → 사양 정리됨
3. **designer 자동 호출** (UI 작업이면) — "사용자 화면도" → 와이어프레임
4. **Plan 승인** → coder가 구현 시작
5. **reviewer 자동 호출** — 변경 직후 품질·보안 점검

UI가 없는 백엔드 작업이면 designer는 건너뜁니다.

---

## 로그 활용 예시

```bash
# 가장 최근 프롬프트 5개
tail -5 logs/prompts.jsonl | jq

# 특정 세션의 모든 파일 변경
jq -c 'select(.session_id == "abc123")' logs/file-changes.jsonl

# 오늘 변경한 파일 목록 (중복 제거)
jq -r 'select(.ts | startswith("'$(date -u +%F)'")) | .file' logs/file-changes.jsonl | sort -u

# 프롬프트 빈도 분석
jq -r '.prompt' logs/prompts.jsonl | wc -l
```

---

## 주의사항

- **민감 정보**: 프롬프트에 토큰·비밀번호·내부 코드가 그대로 적힐 수 있습니다. `.gitignore`로 `logs/*.jsonl`이 이미 보호되어 있지만, 백업·공유 시 주의하세요.
- **jq 필수**: 미설치 시 hook이 조용히 실패합니다 (`exit 0` 유지). 로그가 안 쌓이면 `which jq`로 확인.
- **터미널 권한**: macOS는 첫 실행 시 셸 스크립트 실행을 차단할 수 있습니다. `xattr -d com.apple.quarantine .claude/hooks/*.sh` 로 해제.
- **CLAUDE.md 채우기**: 프로젝트별 빌드/테스트 명령은 `CLAUDE.md`의 "필수 명령어" 섹션에 직접 채워 주세요.

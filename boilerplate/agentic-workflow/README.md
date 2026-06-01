# agentic-workflow

기획→디자인→코딩→리뷰에 비평→해결을 더한 6개 에이전트와 자동 로깅 hook 4종이 즉시 동작하는 Claude Code 워크플로우 보일러플레이트.

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
│   │   ├── reviewer.md             # 코드 리뷰 (opus)
│   │   ├── critic.md               # 비평·최악 시나리오 분석 (opus)
│   │   └── resolver.md             # 비평 받아 해결책 설계 (opus)
│   └── hooks/
│       ├── log-prompt.sh           # 사용자 프롬프트 로깅
│       ├── log-file-change.sh      # 파일 변경 로깅
│       ├── log-agent.sh            # 서브에이전트 호출 로깅
│       └── log-plan.sh             # Plan 진입·질문·확정 로깅
└── logs/                            # JSONL 로그 (git에서 제외)
```

---

## 6개 에이전트

| 에이전트 | 모델 | 트리거 표현 | 권한 |
|---------|------|------------|------|
| `planner` | sonnet | "기능 만들자", "어떻게 설계", "스펙 정리" | Read, Grep, Glob, WebSearch |
| `designer` | sonnet | "화면", "UI", "레이아웃", "와이어프레임" | Read, Grep, Glob, WebSearch |
| `coder` | opus | "구현해", "코드 작성해", plan 승인 후 자동 | Read, Edit, Write, Bash, Grep, Glob |
| `reviewer` | opus | "리뷰해", "검토", 코드 변경 직후 | Read, Grep, Glob, Bash |
| `critic` | opus | "이거 괜찮을까", "리스크 분석", "최악의 경우", 중요 결정 직전 | Read, Grep, Glob, Bash, WebSearch |
| `resolver` | opus | "어떻게 해결", "대안 마련", critic 판정 ⛔/⚠️ 직후, 막혔을 때 | Read, Grep, Glob, Bash, WebSearch |

`reviewer` vs `critic`: reviewer는 **작성된 코드의 품질**을 보고, critic은 **결정·설계 자체**를 의심하며 최악의 시나리오를 분석한다(읽기 전용, 확정된 비판적 태도). `resolver`는 critic의 비판을 입력으로 받아 **견고한 해결 경로**를 설계해 coder에게 넘긴다.

수정/추가/삭제는 `.claude/agents/<name>.md`의 YAML frontmatter를 편집하면 됩니다.

---

## 4개 hook

| Hook | 이벤트 | 출력 파일 | 기록 내용 |
|------|--------|-----------|----------|
| `log-prompt.sh` | `UserPromptSubmit` | `logs/prompts.jsonl` | `{ts, session_id, cwd, prompt}` |
| `log-file-change.sh` | `PostToolUse(Write\|Edit)` | `logs/file-changes.jsonl` | `{ts, session_id, tool, file, action}` |
| `log-agent.sh` | `PostToolUse(Agent\|Task)` | `logs/agents.jsonl` | `{ts, session_id, subagent_type, description, prompt, result_preview}` |
| `log-plan.sh` | `PostToolUse(EnterPlanMode\|ExitPlanMode\|AskUserQuestion)` | `logs/plan.jsonl` | `{ts, session_id, kind, ...}` (진입/질문·답변/확정) |

각 줄은 독립 JSON 객체 (JSON Lines 포맷). `log-agent.sh`로 어떤 서브에이전트가 무슨 일을 했는지, `log-plan.sh`로 Plan 진행·질의응답·확정 plan을 추적할 수 있습니다.

---

## 기본 사용 흐름

1. **Plan Mode 진입** — `Shift+Tab` (또는 그냥 자연어로 "계획해줘")
2. **planner 자동 호출** — "X 기능 추가하고 싶어" → 사양 정리됨
3. **designer 자동 호출** (UI 작업이면) — "사용자 화면도" → 와이어프레임
4. **Plan 승인** → coder가 구현 시작
5. **reviewer 자동 호출** — 변경 직후 품질·보안 점검

UI가 없는 백엔드 작업이면 designer는 건너뜁니다.

### 어려운 문제 분기 (critic → resolver)

리스크가 큰 결정·설계이거나, 접근이 막히거나, "이거 정말 괜찮은가" 검증이 필요할 때:

```
plan / 설계 / 막힌 지점
  → critic 호출 — 숨은 가정 공격 + 최악의 시나리오 + 확정 판정(⛔/⚠️/✅)
  → (⛔ 또는 ⚠️이면) resolver 호출 — 비판을 1:1로 막는 해결 경로 확정
  → coder가 resolver의 해결 plan을 구현
```

critic은 "잘 될 이유"가 아니라 **"무너질 이유"**를 찾고, resolver는 그 비판을 받아 **하나의 견고한 경로를 확정**합니다. 단순·저위험 작업이면 이 분기를 건너뛰고 바로 coder로 갑니다.

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

# 서브에이전트별 호출 횟수
jq -r '.subagent_type' logs/agents.jsonl | sort | uniq -c | sort -rn

# 확정된 plan 본문만 모아 보기
jq -c 'select(.kind == "plan_exit") | {ts, plan_preview}' logs/plan.jsonl
```

---

## 주의사항

- **민감 정보**: 프롬프트에 토큰·비밀번호·내부 코드가 그대로 적힐 수 있습니다. `.gitignore`로 `logs/*.jsonl`이 이미 보호되어 있지만, 백업·공유 시 주의하세요.
- **jq 필수**: 미설치 시 hook이 조용히 실패합니다 (`exit 0` 유지). 로그가 안 쌓이면 `which jq`로 확인.
- **터미널 권한**: macOS는 첫 실행 시 셸 스크립트 실행을 차단할 수 있습니다. `xattr -d com.apple.quarantine .claude/hooks/*.sh` 로 해제.
- **CLAUDE.md 채우기**: 프로젝트별 빌드/테스트 명령은 `CLAUDE.md`의 "필수 명령어" 섹션에 직접 채워 주세요.

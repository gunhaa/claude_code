# agentic-workflow 보일러플레이트 — 설계 근거

`boilerplate/agentic-workflow/` 패키지가 **왜 이런 구성인지** 정리한 문서입니다. 이 분석은 적용 프로젝트로 복사되지 않으며, claude_code 저장소(설계자 본인용)에만 보관합니다.

판단 근거는 모두 [`claude-workflow.md` 섹션 8](claude-workflow.md)의 외부 하네스 vs 내장 기능 비교에서 가져왔습니다.

---

## 1. 왜 Plan Mode가 기본인가

`superpowers`, `cursor-plan` 같은 외부 플러그인 대신 **내장 Plan Mode**를 강제 워크플로우로 채택했습니다.

- **설치 의존성 0**: superpowers는 `/plugin install superpowers@claude-plugins-official` 한 줄이지만, 적용 프로젝트의 모든 팀원이 동일하게 설치·동기화해야 함. 내장 Plan Mode는 Claude Code만 깔려 있으면 즉시 동작.
- **권한 모델 = 안전 모드**: Plan Mode는 본질적으로 권한 모드(수정 차단)라서, `Shift+Tab` 한 번이면 "탐색해도 파일이 안 바뀐다"가 보장됨. 의도치 않은 사이드 이펙트 차단.
- **CLAUDE.md로 강제**: "새 작업은 무조건 Plan Mode로 시작"을 명문화하면, sub-agent 호출 시점도 자연스럽게 plan 단계에 정렬됨.

**superpowers를 쓰면 더 좋은 경우**: 설계 자체를 길게 다듬고 결정 근거를 `docs/plans/`에 영구 보관하고 싶을 때. 본 보일러플레이트는 "복붙 즉시 동작"이 1순위라 외부 의존성을 넣지 않았음. 필요하면 사용자가 추가로 설치하면 됨 (보일러플레이트와 충돌 없음).

---

## 2. 왜 직접 정의한 4개 sub-agent인가

`oh-my-claudecode` (OMC) 같은 멀티-에이전트 오케스트레이션 플러그인이 있지만, 내장 `/agents` 기능으로 4개를 사전 정의하는 방향을 택했습니다.

| 비교 축 | OMC | 본 보일러플레이트 (내장 sub-agent 4개) |
|--------|-----|----------|
| 사전 요구 | tmux + codex CLI + gemini CLI + npm | 없음 (Claude Code만) |
| 설정 시간 | 계정·키 세팅 포함 수십 분 | `cp` + `chmod` 두 줄 |
| 모델 다양성 | Claude + Gemini + Codex | Claude 단독 |
| 병렬도 | 19 agents / 36 skills 대규모 | 4 agents, 메인이 필요 시 동시 호출 |
| 학습 곡선 | 높음 | 낮음 (YAML+Markdown 한 장) |

**판단**: 적용 대상이 "다른 개인/소규모 프로젝트 루트"이므로 OMC는 과투자. 단, 비용 절감(30~50% 보고 사례)·대규모 병렬이 필요한 시점에는 OMC 도입을 검토 (본 보일러플레이트와 양립 가능 — OMC가 내장 sub-agent를 잡아먹지 않음).

---

## 3. 왜 이 4개 역할(기획·디자인·코딩·리뷰)인가

일반적인 기능 개발 흐름의 **자연스러운 단계**를 분해한 것입니다.

```
요구사항 → 사양 (planner)
       → 화면 설계 (designer, UI 작업만)
       → 구현 (coder)
       → 검증 (reviewer)
```

- **planner**: 모호한 요구를 사양으로 변환. 코드 작성 금지(읽기 권한만)로 "기획 단계 침범" 방지.
- **designer**: UI/UX 와이어프레임. 백엔드 전용 작업이면 description 매칭 실패로 자동 스킵됨 (낭비 없음).
- **coder**: 유일하게 쓰기 권한(Edit/Write/Bash). 다른 에이전트와 권한이 분리되어, 의도하지 않은 수정 차단.
- **reviewer**: 읽기 권한만. coder의 결과물을 독립적으로 점검. 자기 비판 회피.

**왜 이보다 더 잘게 쪼개지 않았나**: 5개 이상 되면 Claude가 description 매칭에 혼란을 겪고 결국 직접 처리하는 경우가 늘어남(claude-agents.md 권고). 4개가 책임 분리와 호출 정확도 사이의 균형점.

---

## 4. 왜 sonnet/opus 분배인가

| 에이전트 | 모델 | 근거 |
|---------|------|------|
| planner | sonnet | 수렴적 분해·구조화 작업. 깊은 추론보다 도메인 지식·정리력이 중요 |
| designer | sonnet | UI 패턴은 비교적 정형화. 와이어프레임은 창의보다 일관성 |
| coder | opus | 정확한 구현·엣지 케이스 처리·테스트 작성에 깊은 추론 필요 |
| reviewer | opus | 미세한 버그·보안 이슈 발견에 강한 추론 능력 필수 |

**비용 관점**: 모든 작업을 opus로 돌리면 비용 부담이 큼. planner/designer를 sonnet으로 내려도 품질 저하 거의 없음 (이 단계는 사용자 피드백 루프가 짧아 잘못된 출력이 빨리 보정됨).

---

## 5. 왜 두 종류 hook인가

claude-workflow.md 섹션 8.3에서 분석한 `UserPromptSubmit` + `Stop` 조합 대신, **`UserPromptSubmit` + `PostToolUse(Write|Edit)`** 조합을 채택했습니다.

| Hook | 목적 | 차별점 |
|------|------|--------|
| `UserPromptSubmit` → `prompts.jsonl` | 회고·프롬프트 품질 분석 | 섹션 8.3과 동일 |
| `PostToolUse(Write\|Edit)` → `file-changes.jsonl` | "어떤 프롬프트가 어떤 파일을 바꿨는지" 매핑 | 섹션 8.3은 응답 본문(Stop) 기록 — 본 보일러플레이트는 파일 변경 추적이 더 실용적 |

**왜 `Stop`을 안 썼나**: 응답 본문은 `transcript_path` JSONL에 이미 보존됨 (Claude Code 내장). 별도로 다시 떠서 쌓는 건 디스크 낭비.

**왜 diff 본문을 안 적나**: git이 모든 diff를 이미 추적함. hook의 파일 경로 기록은 "git이 모르는 정보(어느 세션/프롬프트가 시켰는지)"를 보완하는 역할에 한정. 가벼움 유지.

**`session_id`로 두 로그 조인**: 한 세션에서 "프롬프트 → 어떤 파일이 바뀌었나" 추적 가능. JOIN 한 줄로 끝.

```bash
jq -s 'group_by(.session_id) | map({session: .[0].session_id,
       prompts: map(select(.kind=="prompt")),
       changes: map(select(.kind=="file_change"))})' \
  logs/prompts.jsonl logs/file-changes.jsonl
```

---

## 6. 타협과 한계

- **민감 정보 그대로 기록**: 프롬프트·파일 경로에 비밀이 섞일 수 있음. 마스킹 hook을 끼우거나 `.gitignore`에 강하게 의존. 본 보일러플레이트는 후자만 적용 (단순함 우선).
- **jq 의존**: hook이 jq를 호출하므로 미설치 환경에선 조용히 실패. README에 명시.
- **타 OS 지원**: 셸 스크립트는 bash 기준. Windows는 WSL/Git Bash 필요. 본 보일러플레이트는 macOS/Linux 가정.
- **에이전트 description 한국어**: 한국어 트리거 표현에 맞춤. 영어 프로젝트에선 description을 영어로 바꿔야 자동 매칭이 잘 작동.

---

## 변경 시 체크리스트

이 보일러플레이트를 수정·확장할 때 일관성 유지를 위한 점검 포인트:

- [ ] 새 sub-agent 추가 시 description의 트리거 표현이 기존 4개와 겹치지 않는지
- [ ] 새 hook 추가 시 `exit 0` 유지 (비-0 반환 시 Claude 동작에 영향)
- [ ] `logs/` 경로 변경 시 `.gitignore`도 같이 수정
- [ ] CLAUDE.md의 "기본 워크플로우" 흐름 그림이 실제 에이전트 트리거 표현과 일치하는지

---

## 참고

- [claude-workflow.md §8](claude-workflow.md) — 외부 하네스 vs 내장 기능 비교 (원천 분석)
- [claude-agents.md](claude-agents.md) — Sub-Agent 형식과 권한 모델
- [claude-hooks.md](claude-hooks.md) — Hook 이벤트와 settings.json 구조
- [boilerplate/agentic-workflow/README.md](../boilerplate/agentic-workflow/README.md) — 사용자 가이드

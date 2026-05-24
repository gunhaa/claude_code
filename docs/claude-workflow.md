# Claude Code 권장 워크플로우

tips/ 시리즈(basic → intermediate → advanced)의 핵심 워크플로우를 상황별로 정리한 실전 가이드입니다.

---

## 1. 기본 코딩 루프

모든 작업의 기반이 되는 최소 단위 워크플로우입니다.

```
Plan Mode 진입 (Shift+Tab)
  → 작업 설명 & 계획 확인
  → Accept Mode 전환 (Shift+Tab)
    → 코드 변경 (작은 단위)
    → 테스트 실행
    → 린트/포맷 확인
    → 커밋
  → 다음 변경으로 반복
```

**핵심 원칙**
- Plan 없이 바로 실행하면 엉뚱한 파일을 대량 수정하는 사고가 납니다.
- 작은 단위로 커밋해야 문제가 생겼을 때 마지막 커밋으로 돌아올 수 있습니다.
- Thinking 로그를 보다가 잘못된 가정을 발견하면 즉시 `Escape`로 중단하세요.

---

## 2. 컨텍스트 관리 워크플로우

### 한 세션 = 한 피처

신선한 컨텍스트가 부풀어진 컨텍스트보다 항상 낫습니다.

```
Plan Mode에서 전체 작업을 단계별로 설계
  → /clear (또는 새 세션)
  → 1단계만 구현 → 커밋
  → /clear
  → 2단계 구현 → 커밋
  → ...반복
```

| 명령어 | 용도 |
|--------|------|
| `/clear` | 컨텍스트 완전 초기화. 새 작업 시작 시. |
| `/compact` | 대화 압축, 맥락 유지. 세션 내 이어서 할 때. |
| `/context` | 현재 토큰 사용량 확인. 80% 이상이면 정리 시점. |

### Lazy Loading — CLAUDE.md 토큰 절약

CLAUDE.md에 상세 내용을 직접 쓰지 않고, 참조만 남깁니다.

```markdown
# CLAUDE.md
## 프로젝트 문서
- API 스펙: @docs/api-spec.md
- DB 스키마: @docs/db-schema.md
- 코딩 컨벤션: @docs/conventions.md
```

Claude는 해당 파일이 필요할 때만 읽습니다. `src/auth/CLAUDE.md`처럼 폴더별로 분리하면 관련 작업 시에만 로드되어 컨텍스트 오염을 방지합니다.

---

## 3. TODO.md 기반 다중 태스크 워크플로우

여러 세션에 걸쳐 작업 연속성을 유지하는 방법입니다.

```markdown
# TODO.md
- [ ] 결제 기능 구현 (Stripe 연동)
- [ ] 랜딩 페이지 CTA 수정
- [x] 인증 버그 수정
```

**실전 흐름:**
1. 하루 시작 — 할 일을 TODO.md에 체크리스트로 작성
2. `"TODO.md 읽고 첫 번째 항목부터 시작해"` 지시
3. 세션 종료 시 `"TODO.md 업데이트해줘"` → 진행 상황 자동 반영

---

## 4. WAT 프레임워크 — 복잡한 프로젝트 관리

Workflows · Agents · Tools 세 축으로 복잡한 작업을 관리합니다.

### W — Workflow 먼저 글로 정의

코드를 쓰기 전에 작업 흐름을 plain text로 정의합니다. 10분 투자로 수시간의 삽질을 줄입니다.

```
"블로그에 댓글 기능 추가. 순서:
1. comments 테이블 스키마 설계 및 마이그레이션
2. 댓글 CRUD API 엔드포인트 구현
3. 프론트엔드 댓글 컴포넌트 구현
4. 각 단계마다 테스트 작성 및 통과 확인"
```

### A — Sub-Agent 병렬 처리

독립적인 작업은 Sub-Agent에 위임해 병렬로 처리합니다.

```
메인 Claude (coordinator)
  ├── Sub-Agent A: 테스트 작성 및 실행
  ├── Sub-Agent B: 관련 문서 업데이트
  └── Sub-Agent C: 린트 및 타입 체크
```

> Sub-Agent는 다른 Sub-Agent를 생성할 수 없습니다. 메인에서 체인으로 연결하세요.

**Sub-Agent 사용 판단 기준**

| 질문 | Yes | No |
|------|-----|----|
| 작업이 독립적인가? | Sub-Agent 사용 | 메인 대화에서 직접 |
| 대량 출력으로 컨텍스트 오염 우려? | Sub-Agent 사용 | 메인 대화에서 직접 |

### T — 작고 원자적인 도구 조합

하나의 거대한 스크립트보다 단일 책임의 작은 스크립트 여러 개가 낫습니다.

```bash
scripts/build.sh      # 빌드만
scripts/test.sh       # 테스트만
scripts/migrate.sh    # DB 마이그레이션만
scripts/deploy.sh     # 배포만
```

---

## 5. 고급 자동화 파이프라인 — Skills + Hooks 조합

반복 작업을 자동화하는 풀 파이프라인입니다.

### Skills — 재사용 가능한 프롬프트 시스템

`.claude/skills/<name>/SKILL.md`에 작업 매뉴얼을 정의하면 `/skill-name`으로 호출하거나 자동 트리거됩니다.

```yaml
---
name: code-review
description: "코드 리뷰 실행. 'PR 리뷰', '코드 검토' 요청 시 트리거."
---

## 절차
1. git diff로 변경사항 확인
2. 보안, 성능, 가독성 순서로 리뷰
3. 🔴 크리티컬 / 🟡 경고 / 🟢 제안으로 분류 출력
```

### Hooks — 이벤트 기반 자동 실행

도구 호출·세션 종료 등 이벤트에 셸 명령을 연결합니다.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [{ "type": "command", "command": "npm run lint --silent" }]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [{ "type": "command", "command": "terminal-notifier -message '작업 완료'" }]
      }
    ]
  }
}
```

| 이벤트 | 타이밍 | 활용 예시 |
|--------|--------|-----------|
| `PreToolUse` | 도구 호출 직전 | 위험한 명령 차단, 입력값 검증 |
| `PostToolUse` | 도구 실행 직후 | 자동 린트·포맷, 후처리 |
| `Notification` | 응답 대기 시 | 알림 전송, 로깅 |
| `Stop` | 에이전트 턴 종료 | 보고서 생성, 상태 저장 |

### 실전 8단계 파이프라인 예시

1차 피드백 10개 항목 처리를 수동 반나절 → 30분으로 단축한 예시입니다.

| 순서 | 기능 | 시너지 |
|------|------|--------|
| 1 | 음성 입력 `/voice` | 복잡한 피드백 10개를 30초에 전달 |
| 2 | 커스텀 MCP (plan_review) | 경쟁 모델로 플랜 품질 검증 |
| 3 | Sub-Agent 병렬 실행 | 프론트/백엔드 동시 작업 |
| 4 | Skills `/batch` | 핵심 파일 병렬 수정 |
| 5 | Bash 스크립트 | pytest + typecheck + lint 원커맨드 |
| 6 | Stop Hook | 작업 완료 자동 알림 |
| 7 | code-reviewer 에이전트 | 전체 변경사항 품질 검증 |
| 8 | Skills `/client-report` | 클라이언트 보고서 자동 생성 |

---

## 6. Git Worktree 병렬 작업

동일 저장소에서 여러 기능을 동시에 진행합니다.

```bash
# 네이티브 지원 (추천)
claude -w feature-auth      # worktree 생성 + 브랜치 체크아웃 + 세션 시작 자동

# 멀티 인스턴스
# 탭 1: "Feature-Auth"  탭 2: "Bug-Fix"  탭 3: "Refactor"
```

변경 없이 세션 종료 시 worktree가 자동으로 정리됩니다.

---

## 7. 디버깅 워크플로우

- **에러 로그는 해석 없이 통째로** 붙여넣기. 직접 해석하면 오히려 정보가 빠집니다.
- `/export`로 대화를 내보내 다른 AI(ChatGPT, Gemini)에게 비평을 요청합니다.
  - `"이 대화에서 Claude가 놓치고 있는 것이나 잘못된 접근이 있으면 지적해줘"`
- 막히면 새 세션에서 `/memory`로 컨텍스트를 복원한 뒤 재접근합니다.

---

## 빠른 참조 — 상황별 워크플로우 선택

| 상황 | 추천 워크플로우 |
|------|----------------|
| 단순 기능 하나 추가 | 기본 코딩 루프 (섹션 1) |
| 긴 세션에서 컨텍스트가 불어남 | `/compact` → `/clear` + 한 세션 = 한 피처 (섹션 2) |
| 할 일이 많고 며칠에 걸쳐 진행 | TODO.md 워크플로우 (섹션 3) |
| 복잡한 멀티 모듈 프로젝트 | WAT 프레임워크 (섹션 4) |
| 반복 작업 자동화 필요 | Skills + Hooks 파이프라인 (섹션 5) |
| 여러 기능 동시 개발 | Git Worktree (섹션 6) |
| 에러 디버깅 | 섹션 7 |

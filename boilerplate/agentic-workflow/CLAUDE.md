# CLAUDE.md

## 프로젝트 개요

- 프로젝트명:
- 목적:
- 주요 기술 스택:
- 로컬 실행:

---

## 기본 워크플로우 — 반드시 지킨다

**새 작업은 무조건 Plan Mode로 시작한다.**

```
Plan Mode 진입 (Shift+Tab)
  → planner가 요구사항 정리
  → (UI 작업이면) designer가 와이어프레임
  → 사용자가 plan 승인
  → Accept Mode 전환
    → coder가 구현 → 테스트 → 린트
    → reviewer가 변경사항 자동 검토
  → 다음 변경으로 반복
```

Plan 없이 즉시 코드 수정은 금지. 작은 변경이라도 한 줄짜리 plan부터.

---

## 에이전트 호출 규칙

- `planner` — 요구사항이 모호하거나, "기능 만들자/스펙 정리" 표현이 있을 때
- `designer` — UI/화면/레이아웃이 필요할 때. 백엔드 전용이면 호출하지 않음
- `coder` — plan 승인 후, 또는 "구현해" 표현이 있을 때
- `reviewer` — 코드 변경 직후 자동, 또는 "리뷰" 표현이 있을 때

상세 정의는 `.claude/agents/*.md` 참조.

---

## 로깅

- `logs/prompts.jsonl` — 모든 사용자 프롬프트 (UserPromptSubmit hook)
- `logs/file-changes.jsonl` — Write/Edit로 변경된 파일 (PostToolUse hook)

`logs/*.jsonl`은 `.gitignore`로 보호됨.

---

## 필수 명령어

```bash
# 빌드
# 예: npm run build / ./gradlew build / cargo build

# 테스트 (전체)
# 예: npm test / pytest / go test ./...

# 테스트 (단일 파일)
# 예: npm test -- src/auth/login.test.ts / pytest tests/test_auth.py

# 린트
# 예: npm run lint / flake8 . / golangci-lint run

# 포맷
# 예: npm run format / black . / gofmt -w .

# 로컬 실행
# 예: npm run dev / uvicorn main:app --reload
```

---

## 아키텍처

- 디렉토리 구조:

```
src/
  # 주요 디렉토리 설명 작성
```

- 주요 모듈/레이어:
- 참조: @README.md

---

## 반드시 지킬 것

- 모든 작업은 Plan Mode로 시작한다.
- 코드 변경 후 반드시 테스트와 린트를 통과시킨 뒤 커밋한다.
- 새 기능은 테스트를 함께 작성한다.

---

## 절대 하지 말 것

- Plan 없이 코드 수정·파일 생성
- 테스트·린트 실패 상태로 커밋
- `--no-verify`로 커밋 훅 우회
- `logs/` 디렉토리 내용을 git에 커밋
- 프로덕션 데이터 직접 수정

---

## 참조

- @README.md

# CLAUDE.md

## 프로젝트 개요

- 프로젝트명:
- 목적:
- 주요 기술 스택:
- 로컬 실행:

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

## 코드 스타일

@.claude/rules/style.md

---

## 테스트 & 린트

@.claude/rules/testing.md

---

## Git 워크플로우

@.claude/rules/git.md

---

## 반드시 지킬 것

- 코드 변경 후 반드시 테스트와 린트를 통과시킨 뒤 커밋한다.
- 새 기능은 테스트를 함께 작성한다.

---

## 절대 하지 말 것

- 테스트·린트 실패 상태로 커밋하지 않는다.
- `--no-verify`로 커밋 훅을 우회하지 않는다.
- 프로덕션 데이터를 직접 수정하지 않는다.

---

## 파일 읽기 규칙

1. 파일을 읽기 전 `wc -l <파일>` 로 줄 수를 확인한다.
2. 내용을 모르는 파일은 `head -10 <파일>` 로 미리보기한다.
3. 위 두 명령의 데이터만으로 작업을 명확히 수행할 수 없을 때만 Read 도구로 직접 접근한다.
4. Read 도구 사용 시 `limit` / `offset` 을 활용해 필요한 범위만 읽는다.

---

## 참조 파일

- @README.md
- @package.json

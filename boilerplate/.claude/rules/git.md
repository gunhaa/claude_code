# Git 워크플로우 규칙

---

## 브랜치 전략

```
main        → 배포 가능한 안정 브랜치. 직접 push 금지.
develop     → 통합 브랜치 (있는 경우)
feature/*   → 새 기능 (예: feature/user-auth)
fix/*       → 버그 수정 (예: fix/login-redirect)
chore/*     → 설정·의존성 등 코드 외 변경
```

브랜치 네이밍: `<타입>/<kebab-case-설명>`

---

## 커밋 메시지 형식 (Conventional Commits)

```
<타입>: <50자 이내 한 줄 요약>

[선택] 본문 — 왜(Why) 변경했는지 설명. 무엇(What)은 코드가 설명함.
```

**타입 목록**

| 타입 | 사용 시점 |
|------|-----------|
| `feat` | 새 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서만 변경 |
| `style` | 포맷·세미콜론 등 로직 변경 없음 |
| `refactor` | 기능 변경 없는 코드 개선 |
| `test` | 테스트 추가·수정 |
| `chore` | 빌드·의존성·설정 변경 |
| `perf` | 성능 개선 |

**커밋 예시**
```
feat: 이메일 인증 기능 추가
fix: 로그인 후 리다이렉트 경로 오류 수정
docs: API 인증 엔드포인트 설명 추가
refactor: 결제 모듈 의존성 역전 적용
```

---

## 작업 흐름

```bash
# 1. 브랜치 생성
git checkout -b feature/my-feature

# 2. 작은 단위로 커밋 (테스트·린트 통과 후)
git add <파일>
git commit -m "feat: 기능 설명"

# 3. PR 생성 전 최신화
git fetch origin
git rebase origin/main   # 또는 merge — 팀 규칙에 따름

# 4. PR 생성 → 리뷰 → merge
```

---

## 커밋 단위 원칙

- **하나의 커밋 = 하나의 논리적 변경**. 여러 기능을 한 커밋에 섞지 않는다.
- 커밋 후 되돌리기 쉬운 크기로 유지한다.
- WIP(작업 중) 커밋은 PR 전에 `git rebase -i`로 정리한다.

---

## PR 규칙

- PR 제목은 커밋 메시지 형식을 따른다.
- 변경 규모가 크면 단계별로 나눠 PR을 올린다.
- 리뷰어 지정 필수 (팀 설정에 따름).
- CI(테스트·린트) 통과 후 merge.

---

## 금지 사항

- `main` / `develop` 브랜치에 직접 push 금지
- `git push --force` (force-with-lease는 허용)
- `--no-verify`로 커밋 훅 우회 금지
- 민감 정보(API 키, 비밀번호)를 코드에 포함하여 커밋 금지

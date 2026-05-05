# CLAUDE.md vs README.md — 언제 무엇을 쓸 것인가

> 출처: Claude Code 공식 문서 (docs.anthropic.com/en/claude-code)

---

## 결론 먼저

**Claude Code는 공식적으로 `CLAUDE.md`를 권장합니다.**  
`README.md`는 Claude Code가 세션 시작 시 자동으로 읽지 않으므로, AI 지침용으로 사용하면 Claude가 그 내용을 모릅니다.

---

## 1. 두 파일의 근본적인 차이

| 구분 | CLAUDE.md | README.md |
|------|----------|----------|
| 읽는 대상 | **Claude (AI)** | **인간 개발자** |
| 자동 로드 | 세션 시작 시 **자동** | **자동 로드 없음** |
| 목적 | Claude에게 줄 지속적인 지침 | 프로젝트 개요, 설치법, 사용법 |
| 컨텍스트 비용 | 매 세션마다 토큰 소비 | 없음 |

---

## 2. 각 파일에 담을 내용

### CLAUDE.md에 담을 것 (Claude가 알아야 할 것)
- 빌드 / 테스트 / 린트 명령어
- 코드 스타일 규칙 (들여쓰기, 네이밍 컨벤션)
- 아키텍처 결정사항 (어떤 폴더에 무엇이 들어가는지)
- 커밋 / PR 워크플로우 규칙
- 금지 행동 ("절대 XX하지 말 것")
- 필수 환경 변수, 개발 환경 요구사항

### README.md에 담을 것 (인간이 알아야 할 것)
- 프로젝트 개요 및 목적
- 설치 및 설정 방법
- 사용 예제
- 라이선스, 기여 가이드
- 프로젝트 구조 설명

---

## 3. README와 CLAUDE.md를 함께 쓰는 패턴

README에 이미 프로젝트 정보가 있다면, CLAUDE.md에서 `@` 문법으로 참조할 수 있습니다.  
Claude가 필요할 때 해당 파일을 읽습니다 (세션 시작 시 일괄 로드되지 않음).

```markdown
# CLAUDE.md

프로젝트 개요는 @README.md 참조, 사용 가능한 명령은 @package.json 참조.

## 빌드 & 테스트
- 커밋 전 반드시 `npm test` 실행
- 들여쓰기: 2 스페이스
```

---

## 4. AGENTS.md는 어떻게?

공식 문서 명시:

> "Claude Code reads `CLAUDE.md`, not `AGENTS.md`. If your repository already uses `AGENTS.md` for other coding agents, create a `CLAUDE.md` that imports it."

다른 AI 에이전트가 `AGENTS.md`를 쓴다면, `CLAUDE.md`에서 `@AGENTS.md`로 import해 공유하세요.

---

## 5. CLAUDE.md 크기 권장사항

공식 문서:

> "Target under 200 lines per CLAUDE.md file. Longer files consume more context and reduce adherence."

- **200줄 이하** 유지 권장
- 지침이 많아지면 `.claude/rules/*.md`로 분산하거나 `@파일명` import로 필요할 때만 로드

---

## 6. 요약

```
AI 지침 → CLAUDE.md   (Claude가 매 세션마다 자동으로 읽음)
프로젝트 설명 → README.md  (인간 개발자가 읽음, Claude는 자동 탐색 안 함)
```

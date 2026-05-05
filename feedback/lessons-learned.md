# Feedback Loop — 대화 컨텍스트 복원용

대화가 길어져 앞 내용이 압축된 경우, 이 파일을 먼저 읽어 맥락을 복원한다.  
WebSearch로 확인한 사실, 대화 중 결정된 방향, 재탐색 비용이 큰 핵심 정보를 기록한다.

---

## 이 저장소의 목적과 구조

Claude Code 사용 레퍼런스 저장소. 사용자: gunhaa (wh8299@gmail.com)  
원격: https://github.com/gunhaa/claude_code.git / 브랜치: main

```
docs/        → Claude Code 동작 레퍼런스 (질문 답변 후 저장, 커밋/푸시는 허가 후)
boilerplate/ → 새 프로젝트 복사용 CLAUDE.md 템플릿
feedback/    → 이 파일. 컨텍스트 압축 대비 피드백 루프용
```

---

## 확정된 작업 규칙

- commit/push는 사용자의 명시적 허가 후에만 실행한다. 파일 저장 후 반드시 물어볼 것.
- Claude Code 동작 관련 질문 → docs/ 에 저장 → 허가 요청.
- 확실하지 않은 내용 → WebSearch 검색 후 출처와 함께 답변.

---

## WebSearch로 확인한 주요 사실 (출처: docs.anthropic.com)

### CLAUDE.md 로드 순서
세션 시작 시 자동 로드되는 순서 (낮음 → 높음 우선순위):
```
시스템 전역 (/Library/Application Support/ClaudeCode/CLAUDE.md)
→ 사용자 전역 (~/.claude/CLAUDE.md)
→ 프로젝트 (./CLAUDE.md 또는 ./.claude/CLAUDE.md)
→ 로컬 개인 (./CLAUDE.local.md)
```
- 하위 디렉토리 CLAUDE.md는 **지연 로드**: 해당 폴더 파일을 읽는 시점에만 로드됨.
- `.claude/rules/*.md`는 frontmatter `paths:` 조건에 매칭될 때만 로드됨.

### README.md vs CLAUDE.md
- **README.md는 Claude가 세션 시작 시 자동으로 읽지 않는다.**
- AI 지침은 반드시 CLAUDE.md에 작성해야 효과가 있음.
- CLAUDE.md에서 `@README.md` 문법으로 참조하면 필요할 때 읽음.
- `AGENTS.md`도 Claude Code가 인식하지 않음. 필요 시 CLAUDE.md에서 `@AGENTS.md`로 import.

### 세션 시작 시 자동 로드되는 컨텍스트 항목
```
1. System prompt (~4,200 tokens)
2. MEMORY.md (최초 200줄 또는 25KB — 이후 잘림)
3. 환경 정보: 작업 디렉토리, 플랫폼, 셸, OS, 모델 ID
4. Git 정보: 브랜치, 상태, 최근 커밋 (세션 시작 시점 스냅샷)
5. CLAUDE.md 전체 (계층 구조 순서대로)
6. .claude/rules/*.md (경로 매칭된 파일만)
```

### CLAUDE.md 작성 원칙 (공식 권장)
- **200줄 이하** 유지. 초과 시 `.claude/rules/`로 분리.
- 구체적 명령어 사용. "잘 해라" 대신 `npm test && npm run lint`.
- 금지 사항은 "절대 하지 말 것"으로 명시해야 강하게 적용됨.
- 이유(Why)를 함께 써야 예외 상황 판단이 가능함.

---

## 이번 대화에서 생성된 파일 목록

| 파일 | 내용 |
|------|------|
| `CLAUDE.md` | 작업 지침 (문서화, git 허가, 검색, feedback 규칙) |
| `docs/claude-context.md` | 세션 컨텍스트 구성 요소 정리 |
| `docs/claude-file-loading-order.md` | CLAUDE.md 로드 순서 및 계층 구조 |
| `docs/claude-vs-readme.md` | CLAUDE.md vs README.md 비교 |
| `docs/claude-md-tips.md` | 효과적인 CLAUDE.md 작성 팁 10가지 |
| `boilerplate/CLAUDE.md` | 항목만 있는 메인 지침 템플릿 |
| `boilerplate/CLAUDE.local.md` | 개인 설정 템플릿 |
| `boilerplate/.claude/rules/*.md` | 테스트/git/스타일 규칙 템플릿 |
| `README.md` | 저장소 개요 |
| `feedback/lessons-learned.md` | 이 파일 |

---

## 추가 기록

<!-- 대화 진행 중 새로 확인한 중요 정보를 여기에 추가 -->

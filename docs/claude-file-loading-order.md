# Claude Code 파일 탐색 및 로드 순서

> 출처: Claude Code 공식 문서 (docs.anthropic.com)

---

## 1. CLAUDE.md vs README.md — 어느 것을 먼저 읽나?

| 파일 | 로드 방식 |
|------|----------|
| `CLAUDE.md` | **세션 시작 시 자동으로 로드** (명시적으로 명령하지 않아도 됨) |
| `README.md` | 자동 로드 **아님** — Claude가 필요하다고 판단하거나 사용자가 요청할 때만 읽음 |

**결론: CLAUDE.md가 우선이며, README.md는 자동 탐색 대상이 아닙니다.**

---

## 2. CLAUDE.md 로드 순서 (계층 구조)

파일 시스템 루트에서 현재 작업 디렉토리까지 **모두 발견되어 순서대로 연결**됩니다 (하나만 로드되는 것이 아님).

```
로드 순서 (위 → 아래, 아래로 갈수록 나중에 읽힘)

1. 관리형 정책 (Organization-wide)
   - macOS:   /Library/Application Support/ClaudeCode/CLAUDE.md
   - Linux:   /etc/claude-code/CLAUDE.md
   - Windows: C:\Program Files\ClaudeCode\CLAUDE.md

2. 사용자 전역 (User-level)
   - ~/.claude/CLAUDE.md

3. 프로젝트 루트 (Project-level)
   - ./CLAUDE.md
   - ./.claude/CLAUDE.md

4. 로컬 개인 설정 (gitignore 권장)
   - ./CLAUDE.local.md
```

### 하위 디렉토리 CLAUDE.md
- **지연 로드(lazy load)**: Claude가 해당 디렉토리의 파일을 읽을 때 그 시점에 로드됨.
- 세션 시작 시 일괄 로드되지 않음.

---

## 3. 지침 파일 권장 파일명

| 파일명 | 목적 | 공유 여부 |
|--------|------|----------|
| `CLAUDE.md` | 팀 공유 프로젝트 지침 | git에 포함 |
| `.claude/CLAUDE.md` | 동일 (대안 위치) | git에 포함 |
| `.claude/rules/*.md` | 경로별 모듈식 규칙 | git에 포함 |
| `CLAUDE.local.md` | 개인 전용 지침 | gitignore 권장 |
| `~/.claude/CLAUDE.md` | 모든 프로젝트에 적용되는 개인 전역 지침 | 개인만 사용 |

**`CLAUDE.md`가 유일하게 자동 인식되는 파일명입니다.**  
`AGENTS.md` 등 다른 파일명은 지원되지 않습니다. 공유가 필요하면 CLAUDE.md에서 `@AGENTS.md` 형식으로 import하세요.

---

## 4. 세션 시작 시 자동으로 컨텍스트에 포함되는 항목

```
자동 로드 순서:
1. System prompt (~4,200 tokens)
2. Auto memory (MEMORY.md) — 최초 200줄 또는 25KB
3. 환경 정보 (~280 tokens): 작업 디렉토리, 플랫폼, 셸, OS 버전
4. Git 정보: 현재 브랜치, 상태, 최근 커밋
5. CLAUDE.md 파일 전체 (계층 구조 순서대로)
6. .claude/rules/*.md (경로 조건에 매칭되는 파일만)
7. 사용자 입력
```

> MEMORY.md는 200줄 이후 잘림. CLAUDE.md는 제한 없이 전체 로드되나 200줄 이하 유지 권장.

---

## 5. 요약

- **지침 파일명은 `CLAUDE.md`가 정답** — 유일하게 자동 인식됨.
- README.md는 Claude가 자동으로 탐색하지 않음.
- CLAUDE.md는 계층별로 여러 개를 둘 수 있고 모두 합쳐서 적용됨.
- 하위 디렉토리 CLAUDE.md는 해당 디렉토리 파일을 읽을 때 지연 로드됨.

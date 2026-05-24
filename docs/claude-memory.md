# Claude Code /memory 시스템

---

## /memory란?

Claude와 대화하면서 쌓인 지식을 **로컬 마크다운 파일**에 자동으로 저장하는 시스템입니다.  
프로젝트의 기관 기억(institutional memory)이 됩니다.

```
저장 위치: ~/.claude/projects/<project-path>/memory/
인덱스:    ~/.claude/projects/<project-path>/memory/MEMORY.md
자동 로드: 세션 시작 시 MEMORY.md 첫 200줄 자동 로드
```

---

## 사용 방법

| 방법 | 설명 |
|------|------|
| `"기억해줘"` | 대화 중 중요한 내용을 메모리에 저장 |
| `/memory` | 저장된 메모리 확인 및 편집 |
| 자동 저장 | Claude가 판단해 중요 정보를 자동으로 기록 |

**개인 메모리 vs 팀 공유 지식**

| 용도 | 저장 위치 |
|------|-----------|
| 개인 메모리, 세션 간 맥락 | `/memory` 시스템 (`~/.claude/projects/.../memory/`) |
| 팀 공유 규칙, 아키텍처 지침 | `CLAUDE.md` (Git에 커밋) |

---

## 메모리 파일 구조

인덱스(`MEMORY.md`) + 타입별 개별 파일로 구성합니다.

```markdown
<!-- MEMORY.md (인덱스) -->
- [Project Context](project-context.md) — 저장소 목적, 구조
- [Work Rules](feedback-work-rules.md) — 커밋 규칙, 문서화 규칙
- [Reference: Loading Order](reference-loading.md) — CLAUDE.md 로드 순서
```

개별 파일 frontmatter:

```markdown
---
name: project-context
description: 저장소 목적과 구조 요약
metadata:
  type: project  # user | feedback | project | reference
---

내용...
```

---

## CLAUDE.md Lazy Loading — 토큰 절약

CLAUDE.md에 상세 내용을 직접 쓰지 않고 **참조만** 남깁니다.  
Claude는 해당 파일이 실제로 필요할 때만 읽습니다.

```markdown
# CLAUDE.md — 나쁜 예 (매 세션마다 수천 토큰 소모)
## API 엔드포인트
- POST /api/auth/login - 로그인...
- GET /api/users/:id - 유저 조회...
- ... (50개 더)
```

```markdown
# CLAUDE.md — 좋은 예 (Lazy Loading)
## 프로젝트 문서
- API 스펙: @docs/api-spec.md
- DB 스키마: @docs/db-schema.md
- 코딩 컨벤션: @docs/conventions.md
```

**폴더별 CLAUDE.md 분리**: `src/auth/CLAUDE.md`, `src/payments/CLAUDE.md`처럼 도메인별로 나누면 해당 폴더 작업 시에만 로드됩니다.

---

## MCP 토큰 모니터링

MCP를 여러 개 연결하면 **도구 설명만으로도 토큰을 크게 소비**합니다.

- `/context`로 주기적으로 사용량 확인
- 안 쓰는 MCP는 `/mcp`에서 비활성화
- Notion, Linear 같이 도구 설명이 큰 MCP는 자주 쓰는 기능만 **커스텀 MCP로 래핑**하면 토큰 절약 + 응답 품질 향상

---

## Mermaid 아키텍처 정리

CLAUDE.md(또는 별도 파일)에 Mermaid 다이어그램으로 아키텍처를 정리하면  
Claude가 프로젝트 구조를 한눈에 파악합니다.

```
graph LR
    A[클라이언트] --> B[API 게이트웨이]
    B --> C[인증 서비스]
    B --> D[주문 서비스]
    D --> E[결제 서비스]
```

`docs/architecture.md`에 정리하고 CLAUDE.md에서 `@docs/architecture.md`로 참조하는 것을 권장합니다.

---

## 무거운 작업 스크립트 오프로드

무거운 데이터 처리를 대화 안에서 시키면 컨텍스트가 오염됩니다.  
Claude에게 **스크립트를 작성**하게 하고, 결과 요약만 받으세요.

| 상황 | 프롬프트 예시 |
|------|--------------|
| DB 마이그레이션 검증 | "10만 행 CSV 파싱 후 무결성 검증 스크립트 작성. 결과는 summary.json으로" |
| 로그 분석 | "수백 MB 로그에서 에러 패턴 추출 스크립트. report.md로 정리" |
| API 응답 비교 | "v1 vs v2 응답 차이 비교 스크립트. diff를 api-diff.json으로" |

# Claude Code Sub-Agent 시스템

---

## Sub-Agent란?

메인 Claude 안에서 **별도의 작업 공간을 가진 도우미**를 띄우는 기능입니다.  
각 Sub-Agent는 독립적인 지시사항·도구·권한을 갖고, 작업 결과는 Sub-Agent 쪽에만 남고 메인에는 **요약만** 돌아옵니다.

**핵심 장점**

- **병렬 처리** — 독립적인 작업을 동시에 실행해 전체 소요 시간 단축
- **컨텍스트 보호** — 대량 출력이 메인 컨텍스트를 오염시키지 않음
- **전문화** — 각 에이전트에 특정 역할과 권한만 부여

> Sub-Agent는 다른 Sub-Agent를 생성할 수 없습니다. 메인에서 체인으로 연결하세요.

---

## 내장 Sub-Agent 5종

| Sub-Agent | 모델 | 권한 | 용도 |
|-----------|------|------|------|
| **Explore** | Haiku | 읽기 전용 | 코드 탐색, 파일 검색, 구조 파악 |
| **Plan** | 상속 | 읽기 전용 | Plan Mode에서 계획 수립 연구 |
| **General-purpose** | 상속 | 모든 도구 | 탐색 + 수정이 필요한 복잡한 다단계 작업 |
| **Bash** | 상속 | Bash만 | 별도 컨텍스트에서 터미널 명령 실행 |
| **Claude Code Guide** | Haiku | 읽기 전용 | Claude Code 기능 질문 답변 |

---

## 커스텀 에이전트 만들기

### `/agents` 명령어

1. `/agents` 입력
2. **Create new agent** 선택
3. User-level(모든 프로젝트) 또는 Project-level 선택
4. **Generate with Claude** → 에이전트 설명 입력
5. 도구 선택 · 모델 선택 → 저장

### 에이전트 파일 형식 (YAML + Markdown)

```yaml
---
name: code-reviewer
description: "코드 리뷰 전문가. 품질, 보안, 모범 사례를 검토."
tools: Read, Grep, Glob, Bash
model: sonnet
---

호출되면:
1. git diff로 최근 변경 확인
2. 수정된 파일에 집중하여 리뷰

피드백 우선순위:
- 🔴 크리티컬 (반드시 수정)
- 🟡 경고 (수정 권장)
- 🟢 제안 (개선 고려)
```

---

## 저장 위치 & 범위

| 저장 위치 | 적용 범위 |
|-----------|-----------|
| `~/.claude/agents/` | 내 모든 프로젝트 |
| `.claude/agents/` | 이 프로젝트만 (Git 공유 가능) |
| `--agents` CLI 플래그 | 현재 세션만 (일회용) |

```bash
# CLI 일회성 에이전트 정의
claude --agents '{
  "quick-reviewer": {
    "description": "빠른 코드 리뷰어",
    "prompt": "변경된 코드를 리뷰하고 핵심 이슈만 보고하세요.",
    "tools": ["Read", "Grep", "Glob"],
    "model": "haiku"
  }
}'
```

---

## Sub-Agent 사용 판단 기준

| 판단 질문 | Sub-Agent 사용 | 메인 대화 사용 |
|-----------|---------------|---------------|
| 작업이 독립적인가? | ✅ 결과만 받으면 됨 | 왔다 갔다 상호작용 필요 |
| 대량 출력으로 컨텍스트 오염 우려? | ✅ 요약만 받기 | 출력이 가벼우면 불필요 |

---

## 실전 패턴

**병렬 연구** — 독립적인 모듈을 각각 별도 Sub-Agent로 동시 분석

```
메인 Claude
  ├── Sub-Agent A: auth 모듈 분석
  ├── Sub-Agent B: payment 모듈 분석
  └── Sub-Agent C: notification 모듈 분석
```

**에이전트 체인** — 순차 연결

```
code-reviewer → security-checker → optimizer
```

**대량 출력 격리** — 테스트 실행이나 로그 분석처럼 출력이 많은 작업을 위임하고 요약만 수신

**Git Worktree 병렬 작업**

```bash
claude -w feature-auth    # worktree 생성 + 브랜치 체크아웃 + 세션 시작 자동
claude -w feature-payment
```

변경 없이 세션 종료 시 worktree가 자동 정리됩니다.

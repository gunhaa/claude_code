# ⚡ Claude Code 고급 자동화 & 확장 치트시트

<aside>
📌

이 페이지는 **Claude Code 고급 자동화 & 확장 마스터** 영상의 핵심 내용을 정리한 치트시트입니다.
스킬, Sub-Agent, Hooks, 고급 팁까지 — 파워유저로 가는 길을 담았습니다.

</aside>

# 1. Skills — AI에게 주는 업무 매뉴얼

## 🎯 1-1. Skills란?

반복되는 프롬프트를 `SKILL.md` 파일에 정의하여 AI에게 **업무 매뉴얼**처럼 전달하는 기능입니다. 한 번 만들면 자동 트리거 또는 `/skill-name`으로 호출하여 매번 같은 품질의 결과를 얻을 수 있습니다.

<aside>
💡

**프롬프트 vs Skills 비교**
• 프롬프트: 매번 입력, 결과 들쭉날쭉, 공유 어려움
• Skills: 한 번 만들면 자동 호출, 품질 일관, 팀 공유 가능

프롬프트가 "한 번의 지시"라면, Skills는 **"재사용 가능한 업무 시스템"**입니다.

</aside>

**Skills를 쓰는 3가지 이유**

- **반복 자동화** — 같은 프롬프트를 매번 입력하지 않아도 됨. `/ppt`만 치면 끝
- **품질 일관성** — 순서, 형식, 체크리스트가 정해져 있어 누가 실행하든 같은 기준
- **팀 공유** — Git에 올려서 팀원과 공유하면 팀 전체가 같은 자동화 사용

## 📂 1-2. 스킬 구조와 로딩 방식

```
.claude/skills/
└── ppt-generator/            ← 스킬 폴더
    ├── SKILL.md               ← 핵심 파일 (필수)
    ├── template.md            ← 템플릿 (선택)
    ├── examples/              ← 예제 (선택)
    └── scripts/               ← 스크립트 (선택)
```

<aside>
⚡

**2단계 로딩 방식**
1단계: 스킬 이름과 description만 로드 (항상, ~50-100바이트)
2단계: 실제 호출 시 [SKILL.md](http://SKILL.md) 본문 + 참고 파일 전체 로드

평소에는 가볍게, 쓸 때만 전체를 불러오는 구조입니다. 자동 정리(컴팩션) 시 전체 내용은 정리되고 설명만 남습니다.

</aside>

<aside>
📂

[**CLAUDE.md](http://CLAUDE.md) vs Skills vs MCP vs Sub-Agent 비교**

</aside>

| 비교 항목 | [CLAUDE.md](http://CLAUDE.md) | Skills | MCP 도구 | Sub-Agent |
| --- | --- | --- | --- | --- |
| **평소 공간** | 전체 내용 매번 | 설명만 (~50-100B) | 전체 설명 매번 | 에이전트 설명 매번 |
| **안 쓸 때 부담** | 항상 있음 | **거의 없음** | 항상 있음 | 항상 있음 |
| **언제 쓰면 좋은가** | 핵심 규칙 | 반복 작업 | 외부 서비스 연동 | 대량 탐색/분석 |

## ✍️ 1-3. [SKILL.md](http://SKILL.md) 작성법

```yaml
---
name: ppt-generator
description: "PPT 발표자료 자동 생성. 'PPT 만들어줘',
  '발표자료 작성', '슬라이드 제작' 요청 시 트리거."
---

## 목적
주제와 핵심 내용을 입력하면 PPT 발표자료를 자동 생성합니다.

## 절차
1. 발표 주제, 대상 청중, 발표 시간 확인
2. 목차 및 슬라이드 구성 설계
3. 각 슬라이드별 내용 작성
4. .pptx 파일로 출력

## 자체 검증 체크리스트
- [ ] 슬라이드 수가 적절한가?
- [ ] 핵심 메시지가 있는가?
- [ ] 시각 자료 지시사항이 포함되었는가?
```

<aside>
💡

**description 작성 팁**
✅ 좋은 예: "PPT 발표자료 자동 생성. 'PPT 만들어줘', '발표자료 작성' 요청 시 트리거."
❌ 나쁜 예: "문서를 생성하는 스킬" (너무 추상적)

핵심 기능이 첫 문장에, 사용자가 쓸 법한 표현 3개 이상 포함할 것.

</aside>

## 🛠️ 1-4. 스킬 만들기

- **방법 1 — 수동:** `mkdir -p ~/.claude/skills/ppt-generator` → [SKILL.md](http://SKILL.md) 작성
- **방법 2 — skill-creator 플러그인 (추천):** `/install-plugin skill-creator` 설치 후 "스킬 만들어줘"라고 말하면 자동 트리거

<aside>
💡

skill-creator는 description 최적화, frontmatter 설정, 지원 파일 구성까지 **스킬 작성 모범 사례를 자동 적용**해서 [SKILL.md](http://SKILL.md)를 만들어줍니다.

</aside>

## 📍 1-5. 스킬 저장 위치

| 위치 | 경로 | 적용 대상 |
| --- | --- | --- |
| **Enterprise** | 관리 설정 | 조직의 모든 사용자 |
| **Personal** | `~/.claude/skills/<name>/SKILL.md` | 내 모든 프로젝트 |
| **Project** | `.claude/skills/<name>/SKILL.md` | 이 프로젝트만 (Git 공유 가능) |
| **Plugin** | `<plugin>/skills/<name>/SKILL.md` | 플러그인 활성화된 곳 |

<aside>
💡

**우선순위:** Enterprise > Personal > Project. Plugin 스킬은 `plugin-name:skill-name`으로 네임스페이스가 분리되어 충돌이 없습니다.
팀 공유: `.claude/skills/`를 Git에 커밋하면 팀원이 pull 받는 순간 바로 사용 가능합니다.

</aside>

---

# 2. Sub-Agent & 병렬 실행

## 🤖 2-1. Sub-Agent란?

메인 Claude 안에서 **별도의 작업 공간을 가진 도우미**를 하나 더 띄우는 것입니다. 각 Sub-Agent는 자기만의 지시사항, 도구, 권한을 갖고 있으며, 조사 결과는 Sub-Agent 쪽에만 남고 메인에는 **요약만** 돌아옵니다.

<aside>
⚡

**핵심 장점 4가지**
• 병렬 처리 — 여러 작업을 동시에 실행해 전체 소요 시간 단축
• 컨텍스트 보호 — 메인 에이전트의 컨텍스트를 오염시키지 않음
• 전문화 — 각 Sub-Agent에 전문 역할 부여
• 재사용 — 한 번 만든 에이전트를 여러 워크플로우에서 활용

</aside>

<aside>
⚠️

**Do's & Don'ts**
✅ 독립적인 작업을 병렬로 분배
✅ 명확한 역할과 범위 지정
✅ 결과를 메인에서 통합 처리
❌ 의존성 있는 작업을 무리하게 병렬화
❌ 하나의 Sub-Agent에 너무 많은 역할
❌ Sub-Agent 간 직접 통신 시도 (불가)

⚠️ Sub-Agent는 **다른 Sub-Agent를 생성할 수 없습니다**. 메인에서 체인으로 연결하세요.

</aside>

## 📋 2-2. 내장 Sub-Agent 5종

| Sub-Agent | 모델 | 권한 | 용도 |
| --- | --- | --- | --- |
| **Explore** | Haiku (빠름) | 읽기전용 | 코드 탐색, 파일 검색, 구조 파악 |
| **Plan** | 상속 | 읽기전용 | Plan Mode에서 계획 수립 연구 |
| **General-purpose** | 상속 | 모든 도구 | 탐색+수정 필요한 복잡한 다단계 작업 |
| **Bash** | 상속 | Bash만 | 별도 컨텍스트에서 터미널 명령 실행 |
| **Claude Code Guide** | Haiku | 읽기전용 | Claude Code 기능 질문 답변 |

## 🔧 2-3. 커스텀 에이전트 만들기

**`/agents` 명령어 단계별 가이드:**

1. `/agents` 입력
2. **Create new agent** 선택
3. **User-level** (모든 프로젝트) 또는 **Project-level** (현재 프로젝트만) 선택
4. **Generate with Claude** 선택 → 에이전트 설명 입력
5. 도구 선택 (Read-only / 전체 도구)
6. 모델 선택 (Sonnet, Opus, Haiku, 상속)
7. 배경색 선택 → 저장 → 즉시 사용 가능

```yaml
# 에이전트 파일 구조 (YAML + Markdown)
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

## 📍 2-4. 에이전트 저장 위치 & 범위

| 어디에 저장? | 어디서 쓸 수 있나? | 언제 이렇게 쓰나? |
| --- | --- | --- |
| `~/.claude/agents/` | **내 모든 프로젝트**에서 사용 가능 | 나만 쓰는 개인용 에이전트 |
| `.claude/agents/` | **이 프로젝트에서만** 사용 가능 | 팀과 공유할 프로젝트 전용 |
| 플러그인의 `agents/` | **플러그인 활성화된 곳**에서만 | 플러그인 제공 에이전트 |
| `--agents` CLI 플래그 | **지금 이 세션에서만** (일회용) | 자동화 스크립트/CI에서 즉석 사용 |

```bash
# CLI에서 즉석으로 에이전트 정의 (일회성)
claude --agents '{
  "quick-reviewer": {
    "description": "빠른 코드 리뷰어",
    "prompt": "변경된 코드를 리뷰하고 핵심 이슈만 보고하세요.",
    "tools": ["Read", "Grep", "Glob"],
    "model": "haiku"
  }
}'
```

## ⚡ 2-5. 실전 패턴

- **대량 출력 격리** — 테스트/로그 분석처럼 출력이 많은 작업을 위임하고 요약만 받기
- **병렬 연구** — 독립적인 모듈을 각각 별도 Sub-Agent로 동시 분석
- **에이전트 체인** — code-reviewer → optimizer 순서로 순차 연결
- **에이전트 재개** — 완료 후에도 이전 컨텍스트를 유지한 채 이어서 작업 가능

## 🧭 2-6. Sub-Agent vs 메인 대화 판단 기준

| 판단 질문 | Yes → 추천 | No → 추천 |
| --- | --- | --- |
| **작업이 독립적인가?** | Sub-Agent (결과만 받으면 됨) | 메인 대화 (왔다 갔다 필요) |
| **컨텍스트 오염 우려?** | Sub-Agent (대량 출력 격리) | 메인 대화 (가벼우면 분리 불필요) |

<aside>
💡

쉽게 비유하면 **"직접 하기 vs 심부름 시키기"**입니다.
간단한 건 직접, 시간 오래 걸리는 건 심부름 시키고 결과만 받기.

</aside>

---

# 3. Hooks — 자동화 엔진

## ⚡ 3-1. Hook이란?

Claude Code의 **자동화 엔진**입니다. 이벤트가 발생하면 matcher가 조건을 검사하고, 조건이 맞으면 지정된 액션이 자동으로 실행됩니다.

<aside>
🔄

**이벤트 → Hook 감지 → 액션 실행**
파일 저장, 도구 호출, 알림 수신 등의 이벤트 발생
→ matcher가 조건 검사 (와일드카드 * 또는 특정 패턴)
→ lint 실행, format 적용, 알림 전송 등 자동 실행

</aside>

## 🔧 3-2. Hook 만들기

- **방법 1 — Claude에게 요청 (추천):** "알림 Hook 만들어줘"라고 말하면 settings.json에 자동 추가
- **방법 2 — settings.json 직접 편집:** `~/.claude/settings.json` (개인용) 또는 `.claude/settings.json` (프로젝트용)

## 📝 3-3. Hook JSON 구조

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title 'Claude Code' -message '알림이 있습니다' && afplay /System/Library/Sounds/Ping.aiff &"
          }
        ]
      }
    ]
  }
}
```

**JSON 구조 분해:**

- **이벤트 타입** (`Notification`) — 언제 실행할지
- **matcher** (`*`) — 어떤 상황에 매칭할지 (와일드카드 = 전부)
- **hooks 배열** — 실행할 Hook 목록 (여러 개 가능)
- **command** — 실제 실행할 셸 명령어

## 📋 3-4. 이벤트 타입

| 이벤트 | 타이밍 | 설명 |
| --- | --- | --- |
| **PreToolUse** | 도구 호출 직전 | 입력값 검증, 승인/차단/수정 가능 |
| **PostToolUse** | 도구 실행 직후 | 결과 검증, 후처리 (린트, 포맷팅 등) |
| **Notification** | 사용자 응답 대기 시 | 알림 전송, 로깅, 외부 서비스 연동 |
| **Stop** | 에이전트 턴 종료 시 | 최종 정리, 보고서 생성, 상태 저장 |

<aside>
⚠️

Hook 실행 중 Claude는 멈춰서 기다립니다. **timeout**을 꼭 설정하고, 무거운 작업은 백그라운드(`&`)로 돌리세요.

</aside>

---

# 4. 고급 팁 & 생산성 극대화

## 🖥️ 4-1. 멀티 인스턴스 운영

터미널 탭 여러 개를 열고 **각 탭에서 다른 Claude 인스턴스**를 돌리세요. 탭 이름을 바꿔두면 한눈에 관리 가능합니다.

```
탭 1: "Feature-Auth" — 인증 기능 개발
탭 2: "Bug-Fix" — 버그 수정
탭 3: "Refactor" — 리팩토링
```

## 🌳 4-2. Git Worktree로 병렬 작업

하나의 Git 저장소에서 **여러 개의 작업 디렉토리**를 만드는 기능입니다. 커밋 히스토리는 공유하면서 파일 시스템은 완전히 분리됩니다.

```bash
# 수동 worktree
git worktree add ../project-feature-auth feature/auth

# Claude Code 네이티브 지원 (추천)
claude --worktree feature-auth
claude -w feature-auth

# Sub-Agent에서 격리
isolation: worktree  # 에이전트 설정에 추가
```

<aside>
💡

`claude -w` 한 줄이면 워크트리 생성 → 브랜치 체크아웃 → 세션 시작까지 자동.
변경 없으면 세션 종료 시 자동 정리됩니다.

</aside>

## 🎤 4-3. 음성 입력 (/voice)

`/voice`로 음성 입력 모드 활성화. **Push-to-talk** (스페이스바) 방식이며 한국어 포함 20개 이상 언어를 지원합니다. 복잡한 요구사항을 키보드로 5분 걸릴 프롬프트를 말로 1분에 전달할 수 있습니다.

## 🔧 4-4. MCP 대신 로컬 Bash 스크립트

간단한 작업이라면 MCP 대신 **로컬 bash 스크립트**가 훨씬 가볍습니다. MCP 연결 없이 바로 실행되고 컨텍스트 공간도 절약됩니다.

```bash
# scripts/check-db.sh
#!/bin/bash
psql -h localhost -U dev -d mydb -c "SELECT count(*) FROM users;"
```

Claude에게 "[check-db.sh](http://check-db.sh) 실행해"라고 하면 끝. MCP 연결 불필요.

## 🏗️ 4-5. 커스텀 MCP 서버 빌드

Claude가 작업 중에 **자동으로 호출**해야 하는 도구가 필요하면 MCP 서버를 만드세요.

- 예시: Plan Review MCP 서버
    
    Plan 모드에서 계획을 세우면 Gemini API에 보내서 리뷰를 받고 결과를 반환하는 MCP 서버입니다.
    
    **요청 프롬프트:**
    "Gemini API를 사용하는 plan-review MCP 서버를 만들어줘. `review_plan` tool 하나만 있으면 돼. plan 텍스트를 받아서 Gemini에 리뷰를 요청하고 결과를 반환하게."
    
    Claude가 MCP 서버 코드를 작성하고 `settings.json`에 등록까지 도와줍니다.
    

---

# 5. 통합 데모 요약 — 1차 피드백 한큐에 수정하기

클라이언트 1차 피드백 10개 항목을 8단계 파이프라인으로 한큐에 처리하는 실전 워크플로우입니다. 수동이면 반나절 → Claude Code 파이프라인으로 **30분**.

<aside>
📋

**8단계 파이프라인** — 코드 수정부터 클라이언트 보고까지, 1인 개발자의 풀 워크플로우

</aside>

| 순서 | 기능 | 시너지 |
| --- | --- | --- |
| 1 | **음성 입력** | 복잡한 피드백 10개를 30초에 전달 |
| 2 | **커스텀 MCP** (review_plan) | 경쟁 모델로 플랜 품질 검증 |
| 3 | **Sub-Agent 병렬 실행** | 프론트/백엔드 동시 작업 |
| 4 | **번들 스킬** (/batch) | P1 4개 파일 병렬 수정 |
| 5 | **로컬 Bash 스크립트** | pytest + typecheck + lint 원커맨드 |
| 6 | **Hooks** | 작업 완료 자동 알림 |
| 7 | **코드 리뷰 에이전트** | 전체 변경사항 품질 검증 |
| 8 | **커스텀 스킬** (client-report) | 클라이언트 보고서 자동 생성 |

---

<aside>
🎬

이 시리즈는 총 3편입니다.
1편: 입문 → 2편: 실전 워크플로우 → **3편: 고급 자동화 & 확장 (현재)**
스킬, Sub-Agent, Hooks를 조합하면 1인 개발자가 팀급 생산성을 낼 수 있습니다.

</aside>
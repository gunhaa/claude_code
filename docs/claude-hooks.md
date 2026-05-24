# Claude Code Hooks

---

## Hooks란?

이벤트가 발생하면 지정된 셸 명령을 자동 실행하는 **자동화 엔진**입니다.

```
이벤트 발생 → matcher 조건 검사 → 셸 명령 실행
```

예시: 파일을 저장할 때마다 자동으로 lint 실행, 세션 종료 시 알림 전송.

> Hook 실행 중 Claude는 멈추고 기다립니다. 무거운 작업은 백그라운드(`&`)로 돌리고 **timeout**을 설정하세요.

---

## 이벤트 타입 4종

| 이벤트 | 타이밍 | 주요 활용 |
|--------|--------|-----------|
| `PreToolUse` | 도구 호출 직전 | 위험한 명령 차단, 입력값 검증, 승인/수정 |
| `PostToolUse` | 도구 실행 직후 | 자동 lint·포맷, 결과 후처리 |
| `Notification` | 사용자 응답 대기 시 | 알림 전송, 로깅, 외부 서비스 연동 |
| `Stop` | 에이전트 턴 종료 시 | 보고서 생성, 최종 정리, 상태 저장 |

---

## 설정 방법

**방법 1 — Claude에게 요청 (추천)**

```
"파일 수정 후 자동으로 lint 실행하는 Hook 만들어줘"
```

Claude가 `settings.json`에 직접 추가합니다.

**방법 2 — settings.json 직접 편집**

| 파일 | 적용 범위 |
|------|-----------|
| `~/.claude/settings.json` | 개인 전체 |
| `.claude/settings.json` | 이 프로젝트만 (Git 공유 가능) |

---

## JSON 구조

```json
{
  "hooks": {
    "<이벤트타입>": [
      {
        "matcher": "<매칭 패턴>",
        "hooks": [
          {
            "type": "command",
            "command": "<실행할 셸 명령>"
          }
        ]
      }
    ]
  }
}
```

- **matcher**: `*` (전부) 또는 도구 이름 (`Write`, `Bash` 등) 패턴
- **hooks 배열**: 하나의 matcher에 여러 명령 등록 가능

---

## 실용 예시

### 파일 저장 후 자동 lint

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          { "type": "command", "command": "npm run lint --silent" }
        ]
      }
    ]
  }
}
```

### 세션 종료 시 알림 (macOS)

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title 'Claude Code' -message '작업 완료' && afplay /System/Library/Sounds/Ping.aiff &"
          }
        ]
      }
    ]
  }
}
```

### 위험한 명령 차단 (PreToolUse)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "echo '${TOOL_INPUT}' | grep -q 'rm -rf' && exit 1 || exit 0" }
        ]
      }
    ]
  }
}
```

---

## 로컬 Bash 스크립트 활용

간단한 반복 작업은 MCP 대신 **로컬 bash 스크립트**가 훨씬 가볍습니다.

```bash
# scripts/check-db.sh
#!/bin/bash
psql -h localhost -U dev -d mydb -c "SELECT count(*) FROM users;"
```

Claude에게 `"check-db.sh 실행해"`라고 하면 됩니다. MCP 연결 불필요, 컨텍스트 공간도 절약됩니다.

---

## 커스텀 MCP 서버 빌드

로컬 Bash 스크립트로 해결하기 어렵거나, Claude가 작업 중 **자동으로 호출**해야 하는 도구가 필요하면 커스텀 MCP 서버를 만드세요.

**언제 MCP 서버를 만드는가**

| 상황 | 권장 방식 |
|------|-----------|
| 단순 반복 명령 | 로컬 Bash 스크립트 |
| 외부 API 연동 (Stripe, GitHub 등) | MCP 서버 |
| Claude가 자동 판단해서 호출해야 하는 도구 | MCP 서버 |
| 복잡한 상태 관리가 필요한 도구 | MCP 서버 |

**예시: Plan Review MCP 서버**

Plan Mode에서 계획을 세우면 Gemini API로 보내 리뷰를 받고 결과를 반환하는 서버입니다.

```
"Gemini API를 사용하는 plan-review MCP 서버를 만들어줘.
 review_plan tool 하나만 있으면 돼.
 plan 텍스트를 받아서 Gemini에 리뷰를 요청하고 결과를 반환하게."
```

Claude가 서버 코드 작성부터 `settings.json` 등록까지 도와줍니다.

**MCP 서버 등록 위치**

```json
// ~/.claude/settings.json 또는 .claude/settings.json
{
  "mcpServers": {
    "plan-review": {
      "command": "node",
      "args": ["/path/to/plan-review-server/index.js"]
    }
  }
}
```

---

## Skills + Hooks 조합 패턴

반복 작업 전체를 자동화하는 구조입니다.

```
사용자: /code-review
  → Skills: 리뷰 절차 로드 & 실행
    → PostToolUse Hook: 변경 파일 자동 lint
      → Stop Hook: 리뷰 완료 알림 전송
```

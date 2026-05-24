# Claude Code Skills 시스템

---

## Skills란?

반복되는 프롬프트를 `SKILL.md` 파일에 정의하여 AI에게 **재사용 가능한 업무 매뉴얼**을 전달하는 기능입니다.  
`/skill-name`으로 호출하거나 description에 지정한 표현이 감지되면 자동으로 트리거됩니다.

| 비교 | 일반 프롬프트 | Skills |
|------|--------------|--------|
| 입력 | 매번 타이핑 | `/skill-name` 한 번 |
| 품질 | 들쭉날쭉 | 체크리스트 기반 일관됨 |
| 공유 | 어려움 | Git으로 팀 전체 공유 |

---

## 파일 구조

```
.claude/skills/
└── ppt-generator/
    ├── SKILL.md        ← 핵심 파일 (필수)
    ├── template.md     ← 출력 템플릿 (선택)
    ├── examples/       ← 예제 (선택)
    └── scripts/        ← 스크립트 (선택)
```

**2단계 로딩 방식**

- 평소: 스킬 이름과 description만 로드 (~50–100 bytes)
- 호출 시: SKILL.md 본문 + 참고 파일 전체 로드

컨텍스트 압축(compaction) 후에는 설명만 남고 본문은 정리됩니다. MCP보다 가벼운 이유가 여기에 있습니다.

---

## SKILL.md 작성법

```yaml
---
name: ppt-generator
description: "PPT 발표자료 자동 생성. 'PPT 만들어줘', '발표자료 작성', '슬라이드 제작' 요청 시 트리거."
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

**description 작성 팁**

- 핵심 기능을 첫 문장에 명시
- 사용자가 실제로 쓸 법한 표현 3개 이상 포함
- 나쁜 예: `"문서를 생성하는 스킬"` (너무 추상적)
- 좋은 예: `"PPT 발표자료 자동 생성. 'PPT 만들어줘', '발표자료 작성' 요청 시 트리거."`

---

## 스킬 만들기

**방법 1 — 수동**

```bash
mkdir -p .claude/skills/my-skill
# SKILL.md 직접 작성
```

**방법 2 — skill-creator 플러그인 (추천)**

```
/install-plugin skill-creator
"스킬 만들어줘"
```

description 최적화, frontmatter 설정, 지원 파일 구성까지 모범 사례를 자동 적용합니다.

---

## 저장 위치 & 범위

| 위치 | 경로 | 적용 범위 |
|------|------|-----------|
| Personal | `~/.claude/skills/<name>/SKILL.md` | 내 모든 프로젝트 |
| Project | `.claude/skills/<name>/SKILL.md` | 이 프로젝트만 (Git 공유 가능) |
| Enterprise | 관리 설정 | 조직의 모든 사용자 |
| Plugin | `<plugin>/skills/<name>/SKILL.md` | 플러그인 활성화된 곳 |

**우선순위**: Enterprise > Personal > Project  
Plugin 스킬은 `plugin-name:skill-name`으로 네임스페이스가 분리되어 충돌이 없습니다.

---

## CLAUDE.md · Skills · MCP · Sub-Agent 비교

| 항목 | CLAUDE.md | Skills | MCP | Sub-Agent |
|------|-----------|--------|-----|-----------|
| 평소 토큰 부담 | 항상 전체 로드 | 설명만 (~100B) | 항상 전체 로드 | 설명 매번 로드 |
| 언제 쓰면 좋은가 | 핵심 규칙 | 반복 작업 | 외부 서비스 연동 | 대량 탐색/분석 |

# Claude 모델 및 토큰 제한 정리

> 기준일: 2026-05-05  
> 출처: [Anthropic Models Overview](https://docs.anthropic.com/en/docs/about-claude/models), [Anthropic Pricing](https://docs.anthropic.com/en/docs/about-claude/pricing)

---

## 최신 모델 (Latest Models)

| 항목 | Claude Opus 4.7 | Claude Sonnet 4.6 | Claude Haiku 4.5 |
|------|----------------|-------------------|------------------|
| **API ID** | `claude-opus-4-7` | `claude-sonnet-4-6` | `claude-haiku-4-5-20251001` |
| **별칭(Alias)** | `claude-opus-4-7` | `claude-sonnet-4-6` | `claude-haiku-4-5` |
| **컨텍스트 윈도우** | 1M 토큰 | 1M 토큰 | 200K 토큰 |
| **최대 출력** | 128K 토큰 | 64K 토큰 | 64K 토큰 |
| **입력 가격** | $5 / MTok | $3 / MTok | $1 / MTok |
| **출력 가격** | $25 / MTok | $15 / MTok | $5 / MTok |
| **Extended Thinking** | 없음 | 지원 | 지원 |
| **Adaptive Thinking** | 지원 | 지원 | 없음 |
| **속도** | 보통 | 빠름 | 가장 빠름 |
| **지식 기준일** | 2026년 1월 | 2025년 8월 | 2025년 2월 |
| **학습 데이터 기준일** | 2026년 1월 | 2026년 1월 | 2025년 7월 |

> **Batch API 확장 출력 (베타):** `output-300k-2026-03-24` 헤더 사용 시 Opus 4.7, Opus 4.6, Sonnet 4.6은 최대 **300K 출력 토큰** 지원  
> **Opus 4.7 주의사항:** 새로운 토크나이저 사용으로 동일 텍스트 기준 최대 35% 더 많은 토큰 소비

---

## 플랫폼별 모델 ID

| 모델 | AWS Bedrock ID | GCP Vertex AI ID |
|------|---------------|-----------------|
| Claude Opus 4.7 | `anthropic.claude-opus-4-7` | `claude-opus-4-7` |
| Claude Sonnet 4.6 | `anthropic.claude-sonnet-4-6` | `claude-sonnet-4-6` |
| Claude Haiku 4.5 | `anthropic.claude-haiku-4-5-20251001-v1:0` | `claude-haiku-4-5@20251001` |

---

## 레거시 모델 (Legacy Models)

| 모델 | API ID | 컨텍스트 | 최대 출력 | 입력 가격 | 출력 가격 |
|------|--------|---------|---------|---------|---------|
| Claude Opus 4.6 | `claude-opus-4-6` | 1M | 128K | $5 / MTok | $25 / MTok |
| Claude Sonnet 4.5 | `claude-sonnet-4-5-20250929` | 200K | 64K | $3 / MTok | $15 / MTok |
| Claude Opus 4.5 | `claude-opus-4-5-20251101` | 200K | 64K | $5 / MTok | $25 / MTok |
| Claude Opus 4.1 | `claude-opus-4-1-20250805` | 200K | 32K | $15 / MTok | $75 / MTok |
| ~~Claude Sonnet 4~~ (deprecated) | `claude-sonnet-4-20250514` | 200K | 64K | $3 / MTok | $15 / MTok |
| ~~Claude Opus 4~~ (deprecated) | `claude-opus-4-20250514` | 200K | 32K | $15 / MTok | $75 / MTok |

> **Deprecated 모델 종료일:** Claude Sonnet 4, Claude Opus 4 → **2026년 6월 15일** 서비스 종료

---

## 전체 가격표

### 표준 API

| 모델 | 입력 | 출력 | 캐시 Write (5분) | 캐시 Write (1시간) | 캐시 Hit |
|------|------|------|----------------|-----------------|---------|
| Claude Opus 4.7 | $5 / MTok | $25 / MTok | $6.25 / MTok | $10 / MTok | $0.50 / MTok |
| Claude Opus 4.6 | $5 / MTok | $25 / MTok | $6.25 / MTok | $10 / MTok | $0.50 / MTok |
| Claude Sonnet 4.6 | $3 / MTok | $15 / MTok | $3.75 / MTok | $6 / MTok | $0.30 / MTok |
| Claude Sonnet 4.5 | $3 / MTok | $15 / MTok | $3.75 / MTok | $6 / MTok | $0.30 / MTok |
| Claude Haiku 4.5 | $1 / MTok | $5 / MTok | $1.25 / MTok | $2 / MTok | $0.10 / MTok |
| Claude Haiku 3.5 | $0.80 / MTok | $4 / MTok | $1 / MTok | $1.6 / MTok | $0.08 / MTok |

### Batch API (50% 할인)

| 모델 | Batch 입력 | Batch 출력 |
|------|-----------|-----------|
| Claude Opus 4.7 | $2.50 / MTok | $12.50 / MTok |
| Claude Opus 4.6 | $2.50 / MTok | $12.50 / MTok |
| Claude Sonnet 4.6 | $1.50 / MTok | $7.50 / MTok |
| Claude Sonnet 4.5 | $1.50 / MTok | $7.50 / MTok |
| Claude Haiku 4.5 | $0.50 / MTok | $2.50 / MTok |

---

## 주요 기능 설명

### Prompt Caching
자주 사용하는 프롬프트(시스템 프롬프트, 문서 등)를 캐싱하여 비용과 지연 시간 절감.

| 캐시 작업 | 가격 배수 | 유효 기간 |
|---------|---------|---------|
| 캐시 Write (5분) | 기본 입력의 1.25배 | 5분 |
| 캐시 Write (1시간) | 기본 입력의 2배 | 1시간 |
| 캐시 Read (Hit) | 기본 입력의 0.1배 (90% 절감) | Write와 동일 |

### 웹 검색 도구
- 요금: **$10 / 1,000 searches** (토큰 비용 별도)

### Web Fetch 도구
- 추가 요금 없음 (토큰 비용만 부과)

### Fast Mode (베타, Opus 4.6 한정)
- 입력: $30 / MTok, 출력: $150 / MTok (표준의 6배)

---

## Rate Limits (등급별)

| 등급 | 설명 |
|-----|------|
| Tier 1 | 신규 사용자 기본 제한 |
| Tier 2 | 성장하는 애플리케이션 |
| Tier 3 | 규모 있는 애플리케이션 |
| Tier 4 | 최대 표준 제한 |
| Enterprise | 협상을 통한 커스텀 제한 |

> 세부 Rate Limits: [Rate Limits 문서](https://docs.anthropic.com/en/api/rate-limits)

---

## 모델 선택 가이드

- **가장 복잡한 추론 / 에이전트 코딩** → `claude-opus-4-7`
- **속도와 지능의 균형** → `claude-sonnet-4-6`
- **가장 빠른 응답 / 비용 효율** → `claude-haiku-4-5`

---

## 참고 링크

- [Models Overview](https://docs.anthropic.com/en/docs/about-claude/models)
- [Pricing](https://docs.anthropic.com/en/docs/about-claude/pricing)
- [Rate Limits](https://docs.anthropic.com/en/api/rate-limits)
- [Prompt Caching](https://docs.anthropic.com/en/build-with-claude/prompt-caching)
- [Extended Thinking](https://docs.anthropic.com/en/docs/build-with-claude/extended-thinking)
- [Batch Processing](https://docs.anthropic.com/en/build-with-claude/batch-processing)

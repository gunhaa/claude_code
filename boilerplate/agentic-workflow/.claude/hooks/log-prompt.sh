#!/usr/bin/env bash
# UserPromptSubmit hook — 사용자 프롬프트를 JSONL로 기록.
# 출력: $CLAUDE_PROJECT_DIR/logs/prompts.jsonl
set -u

INPUT=$(cat)
TS=$(date -u +%FT%TZ)
LOG_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/logs"
mkdir -p "$LOG_DIR"

echo "$INPUT" | jq -c --arg ts "$TS" '{
  ts: $ts,
  kind: "prompt",
  session_id,
  cwd,
  prompt
}' >> "$LOG_DIR/prompts.jsonl"

exit 0

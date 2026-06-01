#!/usr/bin/env bash
# PostToolUse(Agent|Task) hook — 서브에이전트 사용을 JSONL로 기록.
# 출력: $CLAUDE_PROJECT_DIR/logs/agents.jsonl
set -u

INPUT=$(cat)
TS=$(date -u +%FT%TZ)
LOG_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/logs"
mkdir -p "$LOG_DIR"

echo "$INPUT" | jq -c --arg ts "$TS" '
  def coalesce_text:
    if type == "string" then .
    elif type == "array" then (map(.text? // tostring) | join("\n"))
    else tostring end;
  {
    ts: $ts,
    kind: "agent",
    session_id,
    subagent_type: .tool_input.subagent_type,
    description: .tool_input.description,
    prompt: .tool_input.prompt,
    result_preview: ((.tool_response | coalesce_text)[0:1000])
  }' >> "$LOG_DIR/agents.jsonl"

exit 0

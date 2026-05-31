#!/usr/bin/env bash
# PostToolUse(Write|Edit) hook — 변경된 파일 경로를 JSONL로 기록.
# 출력: $CLAUDE_PROJECT_DIR/logs/file-changes.jsonl
set -u

INPUT=$(cat)
TS=$(date -u +%FT%TZ)
LOG_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/logs"
mkdir -p "$LOG_DIR"

echo "$INPUT" | jq -c --arg ts "$TS" '{
  ts: $ts,
  kind: "file_change",
  session_id,
  tool: .tool_name,
  file: (.tool_input.file_path // .tool_input.notebook_path),
  action: (if .tool_name == "Write" then "write" else "edit" end)
}' >> "$LOG_DIR/file-changes.jsonl"

exit 0

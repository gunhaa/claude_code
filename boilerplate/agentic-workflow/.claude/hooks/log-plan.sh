#!/usr/bin/env bash
# PostToolUse(EnterPlanMode|ExitPlanMode|AskUserQuestion) hook —
# Plan 모드 진입·질문/답변·확정을 JSONL로 기록.
# 출력: $CLAUDE_PROJECT_DIR/logs/plan.jsonl
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
  {ts: $ts, session_id} +
  (
    if .tool_name == "AskUserQuestion" then {
      kind: "plan_question",
      questions: [ .tool_input.questions[]? | {
        header,
        question,
        options: [ .options[]?.label ]
      } ],
      answers: (.tool_response | coalesce_text)
    }
    elif .tool_name == "ExitPlanMode" then {
      kind: "plan_exit",
      plan_file: .tool_input.planFilePath,
      plan_preview: ((.tool_input.plan // "")[0:800])
    }
    else {
      kind: "plan_enter"
    }
    end
  )' >> "$LOG_DIR/plan.jsonl"

exit 0

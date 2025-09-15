#!/usr/bin/env bash
set -euo pipefail

# Activate Python virtual environment
if [ ! -f ".venv/bin/activate" ]; then
  echo "Error: Python venv not found at .venv/. Create it and install dependencies." >&2
  exit 1
fi
# shellcheck disable=SC1091
source .venv/bin/activate

# Load environment variables from .env if present
if [ -f ".env" ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set -a
fi

# Ensure required variables are set
: "${VERTEX_AI_PROJECT:?Set VERTEX_AI_PROJECT in environment or .env}"
: "${VERTEX_AI_LOCATION:?Set VERTEX_AI_LOCATION in environment or .env}"
: "${GRADER_OPENAI_API_KEY:?Set GRADER_OPENAI_API_KEY in environment or .env}"

export VERTEX_AI_PROJECT
export VERTEX_AI_LOCATION
export GRADER_OPENAI_API_KEY

python3 axlearn/open_api/evaluator.py \
  --model gemini-2.0-flash \
  --input_file tool_use_self_correct_20240712.jsonl \
  --client_name gemini



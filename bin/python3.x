#!/usr/bin/env bash
# https://github.com/astral-sh/uv/issues/6265#issuecomment-2368306002
# Create Python aliases:
# ln -s $(which python3.x) $HOME/bin/python3.9
# ln -s $(which python3.x) $HOME/bin/python3.10
# ln -s $(which python3.x) $HOME/bin/python3.11
# ln -s $(which python3.x) $HOME/bin/python3.12
# ln -s $(which python3.x) $HOME/bin/python3.13
set -euo pipefail

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

if [[ "${SCRIPT_NAME}" =~ ^python3\.[0-9]+$ ]]; then
  PYTHON_VERSION="${SCRIPT_NAME#python}"
else
  2>&1 echo "Error: Invalid script name: ${SCRIPT_NAME}"
  exit 1
fi

exec uv run --no-project --python "${PYTHON_VERSION}" --python-preference only-managed --no-config python "$@"

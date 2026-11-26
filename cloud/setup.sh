#!/usr/bin/env bash
set -euo pipefail
env_dir="$HOME/icma-asr"
if ! command -v uv >/dev/null 2>&1; then
    python3 -m venv "$HOME/icma-bootstrap"
    "$HOME/icma-bootstrap/bin/python" -m pip install uv
    export PATH="$HOME/icma-bootstrap/bin:$PATH"
fi
uv venv --allow-existing "$env_dir"
uv pip install --python "$env_dir/bin/python" faster-whisper
"$env_dir/bin/python" - <<'PY'
from pathlib import Path
from faster_whisper import WhisperModel
from huggingface_hub import snapshot_download

directory = Path.home() / 'icma-models' / 'whisper-medium'
snapshot_download('Systran/faster-whisper-medium', local_dir=str(directory))
WhisperModel(str(directory), device='cpu', compute_type='int8', local_files_only=True)
print('Multilingual Whisper loaded successfully.')
PY

#!/usr/bin/env sh

if [ ! -f requirements.txt ]; then
  exit 0
fi

if command -v python >/dev/null 2>&1; then
  echo "[hooks] requirements.txt changed. Syncing dependencies..."
  if ! python -m pip install -r requirements.txt; then
    echo "[hooks] WARNING: Could not sync dependencies automatically."
    echo "[hooks] Run manually: python -m pip install -r requirements.txt"
  fi
else
  echo "[hooks] WARNING: python not found. Run manually: python -m pip install -r requirements.txt"
fi

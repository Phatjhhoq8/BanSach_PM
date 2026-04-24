#!/usr/bin/env bash
set -euo pipefail

export MONO_IOMAP=all

mkdir -p /app/Source/img/books

echo "Starting Premium Books Web Forms app on port 8080"
exec xsp4 --address 0.0.0.0 --port 8080 --applications=/:/app/Source --nonstop

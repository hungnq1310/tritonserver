#!/bin/bash

set -x;

for f in /entry.d/*.py; do
  python3 "$f"
done

tritonserver --model-repository=/models
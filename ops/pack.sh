#!/usr/bin/env bash
set -euo pipefail
VER="${1:-$(date +'%Y.%m.%d_%H%M%S')}"
ART="release-${VER}.tar.gz"
tar -czf "$ART" -C scripts .
echo "$ART"

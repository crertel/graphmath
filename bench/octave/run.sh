#!/usr/bin/env bash
# Cross-check every public graphmath function against Octave reference math.
set -euo pipefail
cd "$(dirname "$0")/../.."
out="${1:-$(mktemp -t graphmath-cases-XXXX.m)}"
mix run bench/octave/gen_cases.exs "$out"
octave-cli --no-gui bench/octave/check.m "$out"

#!/bin/bash
# Shared utilities for demo scripts

# Draw a perfectly aligned box around lines of text.
# Usage: box "line 1" "line 2" "line 3"
box() {
  local max=0 line
  for line in "$@"; do
    if [[ ${#line} -gt $max ]]; then max=${#line}; fi
  done
  local w=$((max + 4))
  printf '  ┌'; printf '─%.0s' $(seq 1 "$w"); printf '┐\n'
  for line in "$@"; do printf "  │  %-${max}s  │\n" "$line"; done
  printf '  └'; printf '─%.0s' $(seq 1 "$w"); printf '┘\n'
}

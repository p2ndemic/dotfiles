#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
#  fuzzel-cliphist.sh — Clipboard history picker using cliphist and Fuzzel
# ══════════════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
#  Configuration
# ══════════════════════════════════════════════════════════════════════════════

# ── Font used in the fuzzel window (FontConfig format) ────────────────────────
FONT="BlexMono Nerd Font Mono:size=14"

# ── Window anchor position on screen ──────────────────────────────────────────
# Options: top-left | top | top-right | left | center | right | bottom-left | bottom | bottom-right
ANCHOR="bottom-right"

# ══════════════════════════════════════════════════════════════════════════════
#  Functions: Fuzzel Wrapper
# ══════════════════════════════════════════════════════════════════════════════

# ── Run fuzzel with predefined arguments ──────────────────────────────────────
# ── --with-nth=2: display column 2 of cliphist output (the content), ──────────
# ── while passing the full line (id + content) downstream ─────────────────────
fuzzel_run() {
    fuzzel \
        --dmenu \
        --with-nth=2 \
        --font="$FONT" \
        --hide-prompt \
        --anchor="$ANCHOR" \
        --width=40 \
        --vertical-pad=12 \
        --line-height=18 \
        --selection-radius=6
}

# ══════════════════════════════════════════════════════════════════════════════
#  Main Execution
# ══════════════════════════════════════════════════════════════════════════════

# ── Pipeline: list → pick → decode → copy to clipboard ────────────────────────
# ── Note: exec cannot be used here — it only replaces the shell with a single ─
# ── single process, while a pipeline spawns multiple processes simultaneously ─
cliphist list | fuzzel_run | cliphist decode | wl-copy

#!/usr/bin/env bash
# Disable laptop panel (eDP-1) when an external monitor is connected,
# re-enable it when alone. Avoids a black screen on unplug.

set -euo pipefail

externals="DP-1|HDMI-A-1|DP-2|HDMI-A-2"

apply() {
    # Single-screen policy: if any external (DP*/HDMI*) is connected, use it
    # exclusively and turn the laptop panel off. When alone, turn eDP-1 back on.
    if hyprctl monitors all -j | python3 -c '
import sys, json, re
ext = re.compile(r"^(DP-|HDMI-)")
mons = json.load(sys.stdin)
sys.exit(0 if any(ext.match(m["name"]) for m in mons) else 1)
'; then
        hyprctl keyword monitor "eDP-1, disable"
    else
        hyprctl keyword monitor "eDP-1, preferred, auto, 1"
    fi
}

if [ "${1:-}" = "--apply-only" ]; then
    apply
    exit 0
fi

apply  # run once at startup

# react to hotplug events via Hyprland's event socket (.socket2)
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
exec python3 -u -c '
import socket, sys, subprocess, os
sock = sys.argv[1]
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(sock)
buf = b""
while True:
    data = s.recv(4096)
    if not data:
        break
    buf += data
    while b"\n" in buf:
        line, buf = buf.split(b"\n", 1)
        ev = line.decode(errors="replace")
        if ev.startswith("monitoradded") or ev.startswith("monitorremoved"):
            subprocess.run([os.path.expanduser("~/.config/hypr/scripts/laptop-display.sh"), "--apply-only"])
' "$SOCK"

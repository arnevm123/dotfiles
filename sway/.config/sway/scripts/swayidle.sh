#!/usr/bin/env bash
# ─── Configuration ────────────────────────────────────────────────────────────

# Screen locker command
LOCKER="gtklock -d -S"

# Time (seconds) before the screen locks
LOCK_TIMEOUT=200

# When already locked, turn off display after this many seconds of inactivity
DISPLAY_OFF_TIMEOUT=5

# Mute audio when display turns off while locked (true/false)
MUTE_ON_LOCK=true

# Pause media when display turns off while locked (true/false)
PAUSE_ON_LOCK=true

# Command used to pause media (e.g. playerctl, mpc, spotifycli)
PAUSE_CMD="playerctl pause"

# ─── Helpers ──────────────────────────────────────────────────────────────────

display_off() { swaymsg "output * dpms off"; }
display_on() { swaymsg "output * dpms on"; }

lock() { $LOCKER; }

on_locked_idle() {
	if pgrep -x "${LOCKER%% *}" >/dev/null; then
		$MUTE_ON_LOCK && pactl set-sink-mute @DEFAULT_SINK@ 1
		$PAUSE_ON_LOCK && $PAUSE_CMD
		display_off
	fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────

exec swayidle -w \
	timeout "$LOCK_TIMEOUT" "$(declare -f lock); lock" \
	resume "$(declare -f display_on); display_on" \
	timeout "$DISPLAY_OFF_TIMEOUT" "$(declare -f on_locked_idle); on_locked_idle" \
	resume "$(declare -f display_on); display_on" \
	before-sleep "$(declare -f lock); lock"

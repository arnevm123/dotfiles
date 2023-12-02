#!/usr/bin/env bash

# Fetch display output information and format it
get_display_info() {
	swaymsg -t get_outputs | jq -r '
        .[] | {
            # active,
            # make,
            # model,
            # serial,
            name,
            mode_width: .current_mode.width,
            mode_height: .current_mode.height,
            mode_refresh: ( .current_mode.refresh / 1000 ),
            pos_x: .rect.x,
            pos_y: .rect.y,
            scale,
            transform
        }
        | "output \"\(.name)\" position \(.pos_x),\(.pos_y) mode \(.mode_width)x\(.mode_height)@\(.mode_refresh) scale \(.scale) transform \(.transform)"
        # | "output \"\(.make) \(.model) \(.serial)\" position \(.pos_x),\(.pos_y) mode \(.mode_width)x\(.mode_height)@\(.mode_refresh) scale \(.scale) transform \(.transform) \(.active)"
    '
}

# Main script
display_info=$(get_display_info)
echo "$display_info"

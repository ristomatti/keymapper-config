#!/usr/bin/env zsh

values=$(xdotool getactivewindow getwindowgeometry --shell | awk -F= '/WINDOW/{print $NF}/WIDTH/||/HEIGHT/{print $NF/2}')
xdotool mousemove --window ${(f)values}

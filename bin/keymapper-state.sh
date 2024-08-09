#!/usr/bin/env bash

# shellcheck disable=SC2012

set -euo pipefail

trap cleanup SIGINT SIGTERM ERR EXIT

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ -e "${config_dir}/keymapper/keymapper.conf" ]]; then
  config_file="${config_dir}/keymapper/keymapper.conf"
else
  config_file="${config_dir}/keymapper.conf"
fi

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/keymapper/virtual"

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT

  echo "Releasing xdotool key locks..." >&2
  xdotool keyup Ctrl || true
  xdotool keyup Alt || true
  xdotool keyup Shift || true

  echo "Ensuring entr is not left running..." >&2
  pkill -f "$state_dir" 2> /dev/null || true

  echo "Cleaning up state dir..."
  fd -tf . "${state_dir}" -X rm || true
}

echo "Creating state dir..." >&2
mkdir -p "${state_dir}"

# Clean up the keymapper state on config changes
echo "Watching config file for changes..."
ls "${config_file}" | entr -pns "fd -tf . \"${state_dir}\" -X rm"


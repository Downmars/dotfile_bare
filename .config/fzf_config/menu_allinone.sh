#!/usr/bin/env bash
# menu_allinone.sh - Comprehensive Function Menu

# Load configuration file (if available)
CONFIG="${XDG_CONFIG_HOME:-~/.config}/fzf_config/.fzfmenurc"
if [ -f "$CONFIG" ]; then
  source "$CONFIG"
fi

# Define menu options
options=(
  "Open File"
  "Manage Git"
  "Manage Tasks"
  "Manage Processes"
  "Change Directory"
  "Open Website"
  "Launch Application"
  "Exit"
)

# Display menu using fzf
choice=$(printf "%s\n" "${options[@]}" | fzf $FZF_OPTS --height=40% --reverse --prompt="Select an action: ")

# Execute corresponding action based on selection
case "$choice" in
"Open File")
  ~/.config/fzf_config/fopen.sh
  notify-send "Operation Complete" "File opened"
  ;;
"Manage Git")
  ~/.config/fzf_config/fgit.sh
  notify-send "Operation Complete" "Git branches managed"
  ;;
"Manage Tasks")
  ~/.config/fzf_config/ftask.sh
  notify-send "Operation Complete" "Tasks managed"
  ;;
"Manage Processes")
  ~/.config/fzf_config/fkill.sh
  notify-send "Operation Complete" "Processes managed"
  ;;
"Change Directory")
  ~/.config/fzf_config/fbookmark.sh
  notify-send "Operation Complete" "Directory changed"
  ;;
"Open Website")
  ~/.config/fzf_config/fweb.sh
  notify-send "Operation Complete" "Website opened"
  ;;
"Launch Application")
  ~/.config/fzf_config/fapp.sh
  notify-send "Operation Complete" "Application launched"
  ;;
"Exit")
  exit 0
  ;;
*)
  echo "Unrecognized option"
  ;;
esac

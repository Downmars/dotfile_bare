#!/usr/bin/env bash
# fopen_fd_bat.sh - 使用 fd 和 bat 快速打开文件

selected=$(fd --type f --hidden --follow | fzf --preview 'bat --style=numbers --color=always {}' --height=40%)
if [ -n "$selected" ]; then
  nvim "$selected"
fi

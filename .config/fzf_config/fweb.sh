#!/usr/bin/env bash
# fweb.sh - 使用 fzf 选择并打开网站

site=$(cat ~/.websites | fzf --height=40% --reverse --preview 'echo {2}' | awk '{print $2}')
if [ -n "$site" ]; then
  xdg-open "$site"
fi

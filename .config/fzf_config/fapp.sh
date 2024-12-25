#!/usr/bin/env bash
# fapp.sh - 使用 fzf 作为应用启动器

# 获取可执行文件列表
apps=$(ls /usr/share/applications | grep '\.desktop$' | sed 's/\.desktop$//')

selected=$(echo "$apps" | fzf --height=40% --reverse --prompt="启动应用: " | head -n 1)
if [ -n "$selected" ]; then
  nohuo gtk-launch "$selected" >/dev/null 2>&1 &
  disown
fi

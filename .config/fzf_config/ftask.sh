#!/usr/bin/env bash
# ftask.sh - 使用 fzf 选择并管理任务

task list | fzf --height=40% --reverse --preview 'task info {1}' | awk '{print $1}' | xargs -I{} task {} status

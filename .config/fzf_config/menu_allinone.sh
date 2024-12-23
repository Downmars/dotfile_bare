#!/usr/bin/env bash
# menu_allinone.sh - 综合功能菜单

# 加载配置文件（如果有）
CONFIG="${XDG_CONFIG_HOME:-~/.config}/fzf_config/fzfmenurc"
if [ -f "$CONFIG" ]; then
  source "$CONFIG"
fi

# 定义菜单选项
options=(
  "打开文件"
  "管理 Git"
  "管理任务"
  "管理进程"
  "切换目录"
  "打开网站"
  "启动应用"
  "退出"
)

# 使用 fzf 显示菜单
choice=$(printf "%s\n" "${options[@]}" | fzf $FZF_OPTS --height=40% --reverse --prompt="选择操作: ")

# 根据选择执行相应操作
case "$choice" in
"打开文件")
  ~/.config/fzf_config/fopen_fd_bat.sh
  notify-send "操作完成" "文件已打开"
  ;;
"管理 Git")
  ~/.config/fzf_config/fgit_branch.sh
  notify-send "操作完成" "Git 分支已管理"
  ;;
"管理任务")
  ~/.config/fzf_config/ftask.sh
  notify-send "操作完成" "任务已管理"
  ;;
"管理进程")
  ~/.config/fzf_config/fkill_htop.sh
  notify-send "操作完成" "进程已管理"
  ;;
"切换目录")
  ~/.config/fzf_config/fbookmark.sh
  notify-send "操作完成" "目录已切换"
  ;;
"打开网站")
  ~/.config/fzf_config/fweb.sh
  notify-send "操作完成" "网站已打开"
  ;;
"启动应用")
  ~/.config/fzf_config/fapp.sh
  notify-send "操作完成" "应用已启动"
  ;;
"退出")
  exit 0
  ;;
*)
  echo "未识别的选项"
  ;;
esac

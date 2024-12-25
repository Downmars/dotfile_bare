#!/usr/bin/env bash
# fopen_fd_bat.sh - 使用 fd 和 bat 快速打开文件，根据文件的 MIME 类型使用不同的工具，通过配置文件管理映射

# 配置文件路径
CONFIG_FILE="$HOME/.config/fzf_config/fopen_config/fopen_mime.conf"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found: $CONFIG_FILE"
  exit 1
fi

# 检查所需工具是否已安装
required_tools=(fd fzf bat file xsel chafa)
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    echo "Error: $tool is not installed. Please install it and try again."
    exit 1
  fi
done

# 读取配置文件并构建关联数组
declare -A MIME_COMMANDS

while IFS='=' read -r mime_pattern command; do
  # 忽略空行和注释行
  [[ "$mime_pattern" =~ ^#.*$ ]] && continue
  [[ -z "$mime_pattern" || -z "$command" ]] && continue
  # 去除可能的空格
  mime_pattern=$(echo "$mime_pattern" | xargs)
  command=$(echo "$command" | xargs)
  # 添加到关联数组
  MIME_COMMANDS["$mime_pattern"]="$command"
done <"$CONFIG_FILE"

# 默认打开命令
DEFAULT_OPEN_COMMAND="xdg-open"

# 构建 fzf 的预览命令
PREVIEW_CMD='mime=$(file --mime-type -b {}); \
if [[ $mime =~ ^image/ ]]; then \
  chafa --clear -s 80 {}; \
else \
  bat --style=numbers --color=always {}; \
fi'

# 使用 fd 查找文件，并通过 fzf 选择
selected=$(fd --type f --hidden --follow | fzf --preview "$PREVIEW_CMD" --height=90% --layout=default --info=inline)

# 如果有选择，则根据 MIME 类型打开
if [ -n "$selected" ]; then
  # 获取文件的 MIME 类型
  mime_type=$(file --mime-type -b "$selected")

  # 初始化打开命令为空
  open_cmd=""

  # 遍历配置中的 MIME 类型模式，查找匹配的命令
  for pattern in "${!MIME_COMMANDS[@]}"; do
    # 将模式中的 '*' 转换为正则表达式
    regex="^${pattern//\*/.*}$"
    if [[ "$mime_type" =~ $regex ]]; then
      open_cmd="${MIME_COMMANDS[$pattern]}"
      break
    fi
  done

  # 如果未找到匹配的命令，使用默认命令
  if [ -z "$open_cmd" ]; then
    open_cmd="$DEFAULT_OPEN_COMMAND"
  fi

  # 检查命令是否是自定义函数
  if declare -F "$open_cmd" >/dev/null; then
    # 调用自定义函数，并将其放入后台运行
    "$open_cmd" "$selected" &
    disown
  else
    # 检查命令是否存在
    if command -v "$open_cmd" &>/dev/null; then
      # 使用对应的命令打开文件，并隐藏终端
      nohup "$open_cmd" "$selected" >/dev/null 2>&1 &
      disown
    else
      echo "Error: Command '$open_cmd' not found. Please install it or update the configuration file."
      exit 1
    fi
  fi
fi

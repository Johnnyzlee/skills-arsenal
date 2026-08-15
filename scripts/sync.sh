#!/usr/bin/env bash
# sync.sh — 把仓库内的 skill 软链到所有检测到的工具目录
#
# 机制说明:
#   1. 目标路径是各工具在 macOS/Linux 上的约定配置目录(硬编码)
#   2. 每个目标配一个"工具检测"条件(命令是否存在 / 应用是否安装)
#   3. 只对"工具确实存在"的目录建立软链;未检测到的工具跳过并提示
#   4. 绝不删除任何目录里其他来源的 skill,也不碰已存在的真实目录
#
# 用法:
#   ./scripts/sync.sh            同步到全部已检测到的工具
#   ./scripts/sync.sh --dry-run  只打印将执行的操作,不做修改
#   SKILLS_TARGET_DIR=~/xxx ./scripts/sync.sh  只同步到指定目录(单工具,不做检测)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

if [[ -n "${SKILLS_TARGET_DIR:-}" ]]; then
  TARGET_DIRS=("$SKILLS_TARGET_DIR")
else
  TARGET_DIRS=(
    "$HOME/.config/opencode/skills"
    "$HOME/.claude/skills"
    "$HOME/.codex/skills"
    "$HOME/.config/zed/skills"
    "$HOME/.hermes/skills"
    "$HOME/.cursor/skills"
    "$HOME/.agents/skills"
  )
fi

# 工具检测:目录存在不代表工具装了(可能是残留/新建)。
# 用"命令存在 或 应用已安装 或 配置目录已存在"判断,
# 避免在没装工具的电脑上凭空建目录。
tool_installed() {
  case "$1" in
    "$HOME/.config/opencode/skills") command -v opencode >/dev/null 2>&1 || [[ -d "/Applications/OpenCode.app" ]] || [[ -d "$HOME/.config/opencode" ]] ;;
    "$HOME/.claude/skills")          command -v claude >/dev/null 2>&1 || [[ -d "/Applications/Claude.app" ]] || [[ -d "$HOME/.claude" ]] ;;
    "$HOME/.codex/skills")           command -v codex >/dev/null 2>&1 || [[ -d "$HOME/.codex" ]] ;;
    "$HOME/.config/zed/skills")      command -v zed >/dev/null 2>&1 || [[ -d "/Applications/Zed.app" ]] || [[ -d "$HOME/.config/zed" ]] ;;
    "$HOME/.hermes/skills")          command -v hermes >/dev/null 2>&1 || [[ -d "$HOME/.hermes" ]] ;;
    "$HOME/.cursor/skills")          command -v cursor >/dev/null 2>&1 || [[ -d "/Applications/Cursor.app" ]] || [[ -d "$HOME/.cursor" ]] ;;
    "$HOME/.agents/skills")          [[ -d "$HOME/.agents" ]] ;;
    *)                               return 1 ;;
  esac
}

collect_skills() {
  local category_dir skill_dir name
  for category_dir in "$REPO_DIR"/*/; do
    local category
    category="$(basename "$category_dir")"
    [[ "$category" == "scripts" ]] && continue
    for skill_dir in "$category_dir"*/; do
      [[ -d "$skill_dir" ]] || continue
      [[ -f "$skill_dir/SKILL.md" ]] || continue
      name="$(basename "$skill_dir")"
      printf '%s %s\n' "$name" "$skill_dir"
    done
  done
}

total_created=0
total_skipped=0
total_warned=0
total_missing=0

for TARGET_DIR in "${TARGET_DIRS[@]}"; do
  if [[ -z "${SKILLS_TARGET_DIR:-}" ]] && ! tool_installed "$TARGET_DIR"; then
    echo "[skip] 未检测到对应工具,跳过: $TARGET_DIR"
    total_missing=$((total_missing + 1))
    continue
  fi
  mkdir -p "$TARGET_DIR"
  echo "================ $TARGET_DIR ================"

  created=0
  skipped=0
  warned=0

  while read -r name skill_dir; do
    link="$TARGET_DIR/$name"

    if [[ -L "$link" ]]; then
      current="$(readlink "$link")"
      if [[ "$current" == "$skill_dir" ]]; then
        skipped=$((skipped + 1))
        continue
      fi
      echo "[update] $name: $current -> $skill_dir"
      [[ $DRY_RUN -eq 0 ]] && ln -sfn "$skill_dir" "$link"
      created=$((created + 1))
    elif [[ -e "$link" ]]; then
      echo "[warn] $name: 已存在真实目录,跳过($link)"
      warned=$((warned + 1))
    else
      echo "[link] $name -> $skill_dir"
      [[ $DRY_RUN -eq 0 ]] && ln -s "$skill_dir" "$link"
      created=$((created + 1))
    fi
  done < <(collect_skills)

  echo "linked/updated: $created, already-ok: $skipped, skipped-warnings: $warned"
  echo
  total_created=$((total_created + created))
  total_skipped=$((total_skipped + skipped))
  total_warned=$((total_warned + warned))
done

echo "===== 汇总 ====="
echo "新建/更新: $total_created, 已就位: $total_skipped, 跳过(冲突): $total_warned, 未检测到工具: $total_missing"
[[ $DRY_RUN -eq 1 ]] && echo "(dry-run,未做任何修改)"

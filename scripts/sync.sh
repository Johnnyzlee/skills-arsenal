#!/usr/bin/env bash
# sync.sh — 把仓库内的 skill 软链到所有支持的工具目录
#
# 支持的目标工具(opencode / Claude Code / Codex / Zed / Hermes / Cursor / 通用 ~/.agents):
#   ~/.config/opencode/skills
#   ~/.claude/skills
#   ~/.agents/skills
#   ~/.codex/skills
#   ~/.config/zed/skills
#   ~/.hermes/skills
#   ~/.cursor/skills
#
# 只管理本仓库拥有的 skill:按仓库内 <分类>/<skill>/SKILL.md 逐个建立软链。
# 绝不删除任何目录里其他来源的 skill,也不碰已存在的真实目录。
#
# 用法:
#   ./scripts/sync.sh            同步到全部 5 个工具
#   ./scripts/sync.sh --dry-run  只打印将执行的操作,不做修改
#   SKILLS_TARGET_DIR=~/xxx ./scripts/sync.sh  只同步到指定目录(单工具)
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
    "$HOME/.agents/skills"
    "$HOME/.codex/skills"
    "$HOME/.config/zed/skills"
    "$HOME/.hermes/skills"
    "$HOME/.cursor/skills"
  )
fi

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

for TARGET_DIR in "${TARGET_DIRS[@]}"; do
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
echo "新建/更新: $total_created, 已就位: $total_skipped, 跳过(冲突): $total_warned"
[[ $DRY_RUN -eq 1 ]] && echo "(dry-run,未做任何修改)"

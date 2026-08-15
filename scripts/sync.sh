#!/usr/bin/env bash
# sync.sh — 把仓库内的 skill 软链到 opencode 的 skills 目录
#
# 只管理本仓库拥有的 skill:按仓库内 <分类>/<skill>/SKILL.md 逐个建立软链。
# 绝不删除 opencode 目录里其他来源的 skill,也不碰已存在的真实目录。
#
# 用法:
#   ./scripts/sync.sh            建立/更新软链
#   ./scripts/sync.sh --dry-run  只打印将执行的操作
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${SKILLS_TARGET_DIR:-$HOME/.config/opencode/skills}"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

mkdir -p "$TARGET_DIR"

created=0
skipped=0
warned=0

for category_dir in "$REPO_DIR"/*/; do
  category="$(basename "$category_dir")"
  [[ "$category" == "scripts" ]] && continue
  for skill_dir in "$category_dir"*/; do
    [[ -d "$skill_dir" ]] || continue
    [[ -f "$skill_dir/SKILL.md" ]] || continue
    name="$(basename "$skill_dir")"
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
  done
done

echo "---"
echo "linked/updated: $created, already-ok: $skipped, skipped-warnings: $warned"
[[ $DRY_RUN -eq 1 ]] && echo "(dry-run,未做任何修改)"

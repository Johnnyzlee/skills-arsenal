#!/usr/bin/env bash
# setup.sh — 新电脑一键安装 skills-arsenal
#
# 用法:
#   curl -fsSL https://raw.githubusercontent.com/Johnnyzlee/skills-arsenal/main/scripts/setup.sh | bash
#
# 或手动:
#   git clone https://github.com/Johnnyzlee/skills-arsenal.git ~/skills-arsenal
#   ~/skills-arsenal/scripts/setup.sh
set -euo pipefail

REPO_URL="https://github.com/Johnnyzlee/skills-arsenal.git"
INSTALL_DIR="${SKILLS_INSTALL_DIR:-$HOME/skills-arsenal}"

echo "==> 1/3 安装到 $INSTALL_DIR"
if [[ -d "$INSTALL_DIR/.git" ]]; then
  echo "    已存在,拉取最新..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

echo "==> 2/3 检查依赖"
command -v git >/dev/null || { echo "缺少 git"; exit 1; }

echo "==> 3/3 建立软链(所有 Agent)"
"$INSTALL_DIR/scripts/sync.sh"

echo
echo "完成!已同步到:"
ls -l "$INSTALL_DIR"/*/*/SKILL.md 2>/dev/null | awk -F/ '{print "  - " $(NF-1)}'
echo
echo "本机可用的 Agent 目录:" 
echo "  opencode ~/.config/opencode/skills   Claude ~/.claude/skills"
echo "  codex ~/.codex/skills   zed ~/.config/zed/skills   hermes ~/.hermes/skills"
echo "  cursor ~/.cursor/skills   agents ~/.agents/skills"
echo
echo "以后更新:cd $INSTALL_DIR && git pull && ./scripts/sync.sh"

#!/bin/bash
# App Launch Skills - 一键安装脚本
# 将 9 个 skill 通过 symlink 注册到 ~/.claude/skills/

set -e

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

SKILLS=(
  "app-launch"
  "app-framework"
  "app-competitor"
  "app-design"
  "app-tech-spec"
  "app-compliance"
  "app-dependencies"
  "app-store-strategy"
  "app-qa"
)

echo "Installing App Launch Skills..."
echo "Repo: $REPO_DIR"
echo "Skills: $SKILLS_DIR"
echo ""

for skill in "${SKILLS[@]}"; do
  if [ -L "$SKILLS_DIR/$skill" ]; then
    echo "  ↻ 更新 symlink: $skill"
    rm "$SKILLS_DIR/$skill"
  elif [ -e "$SKILLS_DIR/$skill" ]; then
    echo "  ⚠ $skill 已存在且不是 symlink，跳过"
    continue
  fi
  ln -s "$REPO_DIR/$skill" "$SKILLS_DIR/$skill"
  echo "  ✅ $skill"
done

echo ""
echo "✅ App Launch Skills 安装完成，9 个 skill 已注册。"
echo "在任何项目目录启动 Claude Code，说 '新项目上架' 即可开始。"

---
name: app-framework
description: Use when generating an app project framework document, project
  launch plan, sprint plan, milestone schedule, or project roadmap. Triggers
  when user mentions project framework, launch plan, sprint plan, milestone,
  or project schedule.
---

# App Project Framework Generator

## Process
1. 读取 `CLAUDE.md` 获取项目需求信息
2. 读取 `../app-launch/prompts/P-01-framework.md` 中的完整角色 Prompt
3. 创建 `docs/app-launch/` 目录（如不存在）
4. 按 Prompt 角色和格式要求生成 `docs/app-launch/01-framework.md`
5. 对照验收标准逐项自查
6. 不达标则读取输出文件，按修正指令（FIX）追加迭代

## Dependencies
- Input: `CLAUDE.md`
- Reference: `../app-launch/prompts/P-01-framework.md`
- Output: `docs/app-launch/01-framework.md`

---
name: app-design
description: Use when generating a design brief, design requirements document,
  UI design specification, or designer-ready design doc. Triggers when user
  mentions design brief, design requirements, UI design, design specification,
  or Figma design doc.
---

# Design Brief Generator

## Process
1. 读取 `CLAUDE.md` 获取项目信息
2. 读取 `docs/app-launch/01-framework.md`（如存在）
3. 读取 `../app-launch/prompts/P-03-design.md` 中的完整角色 Prompt
4. 创建 `docs/app-launch/` 目录（如不存在）
5. 按 Prompt 角色和格式要求生成 `docs/app-launch/03-design-brief.md`
6. 对照验收标准逐项自查
7. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `docs/app-launch/01-framework.md`
- Reference: `../app-launch/prompts/P-03-design.md`
- Output: `docs/app-launch/03-design-brief.md`

---
name: app-dependencies
description: Use when generating an external dependency plan, third-party
  integration plan, or vendor coordination schedule. Triggers when user
  mentions external dependencies, third-party integration, API integration
  plan, or dependency management.
---

# External Dependencies Plan Generator

## Process
1. 读取 `CLAUDE.md` 获取项目信息
2. 读取 `docs/app-launch/01-framework.md`（如存在）
3. 读取 `docs/app-launch/04-tech-spec.md`（如存在）
4. 读取 `../app-launch/prompts/P-06-dependencies.md` 中的完整角色 Prompt
5. 创建 `docs/app-launch/` 目录（如不存在）
6. 按 Prompt 角色和格式要求生成 `docs/app-launch/06-external-dependencies.md`
7. 对照验收标准逐项自查
8. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `docs/app-launch/01-framework.md`, `docs/app-launch/04-tech-spec.md`
- Reference: `../app-launch/prompts/P-06-dependencies.md`
- Output: `docs/app-launch/06-external-dependencies.md`

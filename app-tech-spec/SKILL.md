---
name: app-tech-spec
description: Use when generating a technical architecture plan, tech spec,
  API design, database schema, or system architecture document. Triggers when
  user mentions tech spec, technical architecture, API design, database design,
  system architecture, or backend design.
---

# Tech Spec Generator

## Process
1. 读取 `CLAUDE.md` 获取项目信息
2. 读取 `docs/app-launch/01-framework.md`（如存在）
3. 读取 `../app-launch/prompts/P-04-tech-spec.md` 中的完整角色 Prompt
4. 创建 `docs/app-launch/` 目录（如不存在）
5. 按 Prompt 角色和格式要求生成 `docs/app-launch/04-tech-spec.md`
6. 对照验收标准逐项自查
7. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `docs/app-launch/01-framework.md`
- Reference: `../app-launch/prompts/P-04-tech-spec.md`
- Output: `docs/app-launch/04-tech-spec.md`

---
name: app-compliance
description: Use when generating compliance checklists, license requirements,
  privacy compliance documents, regulatory filing checklists, or protocol text
  inventories. Triggers on compliance, licenses, privacy policy, regulatory
  requirements. Do NOT trigger on app store review strategy or ASO optimization.
---

# Compliance Checklist Generator

## Process
1. 读取 `CLAUDE.md` 获取项目信息
2. 读取 `docs/app-launch/01-framework.md`（如存在）
3. 读取 `docs/app-launch/02-competitor-report.md`（如存在）
4. 读取 `../app-launch/prompts/P-05-compliance.md` 中的完整角色 Prompt
5. 创建 `docs/app-launch/` 目录（如不存在）
6. 按 Prompt 角色和格式要求生成 `docs/app-launch/05-compliance-checklist.md`
7. 对照验收标准逐项自查
8. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `docs/app-launch/01-framework.md`, `docs/app-launch/02-competitor-report.md`
- Reference: `../app-launch/prompts/P-05-compliance.md`
- Output: `docs/app-launch/05-compliance-checklist.md`

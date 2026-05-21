---
name: app-store-strategy
description: Use when generating app store launch strategies, store review
  guidelines, ASO plans, or channel prioritization documents. Triggers when
  user mentions app store, ASO, store listing, channel launch, or app review.
  Do NOT trigger on compliance licenses or regulatory filings.
---

# App Store Strategy Generator

## Process
1. 读取 `CLAUDE.md` 获取项目信息
2. 读取 `docs/app-launch/05-compliance-checklist.md`（如存在）
3. 读取 `../app-launch/prompts/P-07-store-strategy.md` 中的完整角色 Prompt
4. 创建 `docs/app-launch/` 目录（如不存在）
5. 按 Prompt 角色和格式要求生成 `docs/app-launch/07-store-strategy.md`
6. 对照验收标准逐项自查
7. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `docs/app-launch/05-compliance-checklist.md`
- Reference: `../app-launch/prompts/P-07-store-strategy.md`
- Output: `docs/app-launch/07-store-strategy.md`

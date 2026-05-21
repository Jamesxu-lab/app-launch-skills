---
name: app-competitor
description: Use when generating a competitive analysis report, competitor
  research, industry policy analysis, or market landscape report. Triggers
  when user mentions competitor analysis, competitor report, policy analysis,
  industry research, or competitive landscape.
---

# Competitor & Policy Analysis Generator

## Process
1. 读取 `CLAUDE.md` 获取产品定位和竞品信息
2. 读取 `../app-launch/prompts/P-02-competitor.md` 中的完整角色 Prompt
3. 创建 `docs/app-launch/` 目录（如不存在）
4. 按 Prompt 角色和格式要求生成 `docs/app-launch/02-competitor-report.md`
5. 对照验收标准逐项自查
6. 不达标则读取输出文件，追加修正指令迭代

## Note
此模块需要联网搜索以获取最新政策动态。确保 CC 有 web search 权限。

## Dependencies
- Input: `CLAUDE.md`
- Reference: `../app-launch/prompts/P-02-competitor.md`
- Output: `docs/app-launch/02-competitor-report.md`

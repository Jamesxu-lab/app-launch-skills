---
name: app-qa
description: Use when running document quality checks, consistency verification,
  or generating a document index. Triggers when user mentions document review,
  quality check, consistency check, document index, or output review.
---

# Document QA & Index Generator

## Process
1. 读取 `CLAUDE.md` 获取项目原始需求
2. 列出 `docs/app-launch/` 下所有已生成文档（01~07）
3. 读取 `../app-launch/prompts/P-08-qa.md` 中的完整角色 Prompt
4. 按 Prompt 要求执行：
   - 第一部分：文档索引（每个文档: 标题/摘要/字数/更新时间）
   - 第二部分：一致性检查（产品定位/时间线/外部依赖/竞品名称/三方服务）
   - 第三部分：差异报告（列出不一致项及修正建议）
   - 第四部分：待人工确认项汇总
5. 输出为 `docs/app-launch/00-index.md`

## Dependencies
- Input: `CLAUDE.md` + `docs/app-launch/` 下所有已生成文档
- Reference: `../app-launch/prompts/P-08-qa.md`
- Output: `docs/app-launch/00-index.md`

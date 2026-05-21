---
name: app-launch
description: Use when starting a new app project, planning app launch, or
  needing to generate app store launch documents. Triggers when user mentions
  app launch, new app project, app store launch, app publish, or mobile app
  go-live preparation.
---

# App Launch Project Framework

## Overview

一键式 App 项目上架文档生成工具。从 CLAUDE.md 出发，自动按依赖关系串行/并行执行 8 个模块，生成从项目框架到商店上架策略的完整文档集。

## Iron Law

执行前必须确认当前目录存在 CLAUDE.md 且包含项目需求信息。如果 CLAUDE.md 不存在或内容不足，先引导用户完善。

## When to Use

- 启动新 App 项目，需要全套上线文档
- 项目缺少某类规划文档，需要补充生成
- 需要系统化的项目推进框架

## Process

### Step 1: 环境检查

检查当前工作目录：
```
1. 确认 CLAUDE.md 存在
2. 确认 CLAUDE.md 包含以下信息（至少）：
   - 产品定位/一句话描述
   - 目标用户
   - 核心功能列表
3. 检查 docs/app-launch/ 是否存在已有输出文件
4. 如有已有文件，列出并询问：增量继续 or 重新全量
```

如果 CLAUDE.md 信息不足，引导用户补充后再继续。

### Step 2: 模块勾选

向用户展示勾选清单，默认全部勾选。用表格呈现：

```
┌────┬──────────────────────┬─────────────────────────┬──────────┐
│  # │ 模块名称              │ 输出文件                  │ 建议运行  │
├────┼──────────────────────┼─────────────────────────┼──────────┤
│ 1  │ P-01 项目推进框架     │ 01-framework.md         │ ✅ 必选   │
│ 2  │ P-02 竞品/政策分析    │ 02-competitor-report.md │ ✅ 必选   │
│ 3  │ P-03 设计需求文档     │ 03-design-brief.md      │ 可选     │
│ 4  │ P-04 技术架构方案     │ 04-tech-spec.md         │ 可选     │
│ 5  │ P-05 合规上线清单     │ 05-compliance-checklist │ 可选     │
│ 6  │ P-06 外部依赖计划     │ 06-external-dependencies│ 可选     │
│ 7  │ P-07 商店上架策略     │ 07-store-strategy.md    │ 可选     │
│ 8  │ P-08 文档质检索引     │ 00-index.md             │ ✅ 必选   │
└────┴──────────────────────┴─────────────────────────┴──────────┘

跳过建议：
- 已有技术团队 → 可跳过 P-04
- 已有设计师   → 可跳过 P-03
- 非金融/强监管 → 可跳过 P-05/P-07
- 无外部依赖   → 可跳过 P-06
```

等待用户确认勾选后再执行。

### Step 3: 按 DAG 调度

读取 `dependency-graph.md` 获取依赖关系和并行策略。

执行原则：
1. 无依赖模块可并行执行（用 Task 工具分派子 agent）
2. 有依赖模块按拓扑顺序串行
3. 每个模块执行完成后，立即保存输出文件到 `docs/app-launch/`
4. 使用 TodoWrite 跟踪每个模块的执行状态

执行阶段：

```
阶段 1：并行 [P-01] [P-02]
    │
阶段 2：并行 [P-03] [P-04]（依赖 P-01）
    │
阶段 3：并行 [P-05] [P-06]（各自有依赖）
    │
阶段 4：[P-07]（依赖 P-05）
    │
阶段 5：[P-08]（依赖全部）
```

每个模块的执行步骤：
1. 读取 Prompt 文件：`prompts/P-XX-name.md`
2. 读取输入依赖文件（CLAUDE.md + 前序输出）
3. 用 Prompt 中的角色和格式要求，生成对应输出文件
4. 对照验收标准逐项自查
5. 不达标则读取输出文件，追加修正指令迭代一次
6. 标记该模块 TodoWrite 状态为 completed

### Step 4: 质检收尾

P-08 完成后的最终输出：
```
1. 输出 00-index.md（文档索引 + 一致性报告）
2. 汇总所有"待人工确认项"，生成表格
3. 提醒用户：待人工确认项需在第一次团队对齐会上逐一确认
```

## Common Issues

| 问题 | 处理方式 |
|------|---------|
| CLAUDE.md 信息不足 | 引导用户补充产品定位、目标用户、核心功能 |
| 部分输出文件已存在 | 询问增量继续还是覆盖 |
| 某模块输出不达标 | 按 prompts/P-XX.md 中的修正指令（FIX）追加迭代 |
| 用户中途打断 | 记录当前进度，询问是否继续或跳过当前模块 |

## Red Flags

- 用户跳过 P-01 直接要 P-03 的输出 → P-03 依赖 P-01，先跑 P-01 再用 P-01 的输出跑 P-03
- CLAUDE.md 内容少于 20 行 → 信息不足以生成有意义的文档，先引导用户补充
- 用户想跳过所有模块 → 确认意图：是否需要的是单点修改（应用独立 skill）

## Dependencies

- 读取 `prompts/P-XX-*.md` 获取各模块 Prompt
- 读取 `dependency-graph.md` 获取调度顺序
- 读取 `quality-standards.md` 获取通用验收标准

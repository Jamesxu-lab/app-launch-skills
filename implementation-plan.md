# App Launch Skills 实现计划

> **目标**：将 Prompt 原子指令库升级为 1 个总控 + 8 个独立模块 + 配套文件的 Claude Code Skill 集群

> **架构**：总控 skill（app-launch）负责任务调度与勾选，8 个独立 skill 各自薄封装引用 prompts/ 中的角色 Prompt 资产。所有文件存放在 `AI使用/skills/` 目录，通过 symlink 挂入 `~/.claude/skills/` 实现全局可用。

> **技术栈**：Markdown + YAML frontmatter（Claude Code Skill 格式），bash（安装脚本）

---

## 文件结构总览

```
AI使用/skills/                        ← 工作目录
│
├── app-launch/                        # ★ 创建：总控 Skill 目录
│   ├── SKILL.md                       #   创建：总控 Skill（~280行）
│   ├── prompts/                       # ★ 创建：Prompt 资产目录
│   │   ├── P-01-framework.md          #   创建：迁移自原始指令库
│   │   ├── P-02-competitor.md         #   创建
│   │   ├── P-03-design.md             #   创建
│   │   ├── P-04-tech-spec.md          #   创建
│   │   ├── P-05-compliance.md         #   创建
│   │   ├── P-06-dependencies.md       #   创建
│   │   ├── P-07-store-strategy.md     #   创建
│   │   └── P-08-qa.md                 #   创建
│   ├── dependency-graph.md            #   创建
│   ├── quality-standards.md           #   创建
│   └── CHANGELOG.md                   #   创建
│
├── app-framework/SKILL.md             #   创建：P-01 薄封装
├── app-competitor/SKILL.md            #   创建：P-02 薄封装
├── app-design/SKILL.md                #   创建：P-03 薄封装
├── app-tech-spec/SKILL.md             #   创建：P-04 薄封装
├── app-compliance/SKILL.md            #   创建：P-05 薄封装
├── app-dependencies/SKILL.md          #   创建：P-06 薄封装
├── app-store-strategy/SKILL.md        #   创建：P-07 薄封装
├── app-qa/SKILL.md                    #   创建：P-08 薄封装
│
├── README.md                          #   创建：对外展示
├── install.sh                         #   创建：一键安装
├── CLAUDE.md                          #   更新：索引页
│
├── prompt-atomic-library-v1.md        #   修改：加盖迁移标记
├── app-launch-skills-design.md        #   已存在：设计文档
├── implementation-plan.md             #   本文件
└── 如何写出工业级SKILL.md             #   已存在：参考
```

---

### Task 1: 创建目录结构

**操作**：创建 10 个目录（9 个 skill 目录 + 1 个 prompts 子目录）

- [ ] **Step 1: 创建所有目录**

```bash
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-launch/prompts
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-framework
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-competitor
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-design
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-tech-spec
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-compliance
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-dependencies
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-store-strategy
mkdir -p /Users/a51nb/knowledge/AI使用/skills/app-qa
```

- [ ] **Step 2: 验证目录结构**

```bash
ls -R /Users/a51nb/knowledge/AI使用/skills/app-*
```
预期：看到 1 个 app-launch/prompts/ + 8 个 app-*/ 空目录

---

### Task 2: 迁移 Prompt 资产（P-01 ~ P-08）

**操作**：从 `prompt-atomic-library-v1.md` 中提取 8 条 Prompt 指令，各自存为独立文件。

- [ ] **Step 1: 创建 app-launch/prompts/P-01-framework.md**

从原始文件第 36-63 行提取 P-01 指令，加上 YAML frontmatter 和 `{{变量}}` 说明：

```markdown
---
type: prompt-asset
module: P-01
version: 1.0
inputs:
  - 01-framework.md
outputs:
  - 03-design-brief.md
  - 04-tech-spec.md
  - 05-compliance-checklist.md
  - 06-external-dependencies.md
---

# P-01 | 生成项目推进框架

**角色**：资深项目经理
**输入依赖**：`CLAUDE.md`
**输出文件**：`docs/app-launch/01-framework.md`
**预估耗时**：30-60 分钟（含 CC 生成 + 人工审核）

```
你是一个有10年互联网产品经验的资深项目经理，擅长金融/消费类APP从零到上线的全流程管理。

请读取 CLAUDE.md，基于其中的项目需求，生成一份完整的项目推进框架，输出为 docs/app-launch/01-framework.md。

文档必须包含以下章节：
1. 项目背景与定位（产品定位 + 交易结构 + 核心业务线）
2. 基于项目周期的冲刺计划（每周：目标 / 工作项 / 产出物 / 负责人）
3. MECE 准备事项清单（维度：产品/设计/技术/测试/合规/运营/商店/商务）
4. 关键路径分析（标注哪些事项是 hard dependency，延误会影响上线）
5. 风险矩阵（风险描述 / 概率 / 影响 / 应对措施）
6. 并行策略（用 ASCII 甘特图表示各模块并行关系）
7. 外部依赖优先级（P0/P1 分级 + 最晚启动时间）
8. 上线材料筹备清单（证照/协议/商店素材/备案，每项标注主体+负责人+行动）

格式要求：
- 使用 Markdown，包含清晰的二级/三级标题
- 准备事项清单用表格，含：序号/事项/维度/优先级/负责人/状态
- 甘特图用 ASCII 或 Markdown 表格模拟
- 整体不少于 600 行
```

**验收标准**：
- [ ] 上线计划每周有明确产出物（不是泛泛的"推进开发"）
- [ ] MECE 清单覆盖 8 个维度，每维度至少 5 条
- [ ] 甘特图能体现至少 3 个模块的并行关系
- [ ] 风险矩阵至少 6 条，含合规风险

---

## 修正指令（FIX）

当 P-01 输出不满足验收标准时，追加以下修正：

```
请读取 docs/app-launch/01-framework.md，按以下修改意见进行调整，覆盖保存：

{{修改意见，例如：
- 第三章 MECE 清单缺少"商务"维度，请补充
- 第四章关键路径未标注三方接口联调的依赖关系，请补充
- 风险矩阵中的"合规风险"描述过于笼统，请细化为具体监管条款}}

修改后请在文档末尾追加"变更日志"章节，记录本次修改内容和日期。
```
```

- [ ] **Step 2: 创建剩余 7 个 Prompt 文件**

按同样模式创建 P-02 ~ P-08：

```bash
# P-02 ~ P-08 内容分别来自 prompt-atomic-library-v1.md 的第 91-118, 126-163, 166-199, 202-235, 238-268, 271-296, 298-341 行
# 每个文件格式与 P-01 一致：YAML frontmatter(module/version/inputs/outputs) + 角色 Prompt + 验收标准
```

文件对应关系：

| 源行号范围 | 目标文件 |
|-----------|---------|
| 91-118 | `prompts/P-02-competitor.md` |
| 126-163 | `prompts/P-03-design.md` |
| 166-199 | `prompts/P-04-tech-spec.md` |
| 202-235 | `prompts/P-05-compliance.md` |
| 238-268 | `prompts/P-06-dependencies.md` |
| 271-296 | `prompts/P-07-store-strategy.md` |
| 298-341 | `prompts/P-08-qa.md` |

---

### Task 3: 创建支撑文件

- [ ] **Step 1: 创建 app-launch/dependency-graph.md**

```markdown
# 依赖关系图

## DAG 拓扑

```
CLAUDE.md
    │
    ├─┬─▶ P-01 (01-framework.md)
    │ │       ├──▶ P-03 (03-design-brief.md)
    │ │       ├──▶ P-04 (04-tech-spec.md) ──▶ P-06 (06-external-dependencies.md)
    │ │       └──▶ P-05 (05-compliance-checklist.md) ──▶ P-07 (07-store-strategy.md)
    │ │
    │ └─▶ P-02 (02-competitor-report.md) ──▶ P-05 (05-compliance-checklist.md)
    │
    └──▶ P-08 (00-index.md) ← 依赖所有勾选模块完成
```

## 并行分组

| 阶段 | 模块 | 前置条件 |
|------|------|---------|
| 1 | P-01, P-02 | 无（可并行） |
| 2 | P-03, P-04 | P-01 完成（可并行） |
| 3 | P-05, P-06 | P-01+P-02 完成(P-05); P-01+P-04 完成(P-06)（可并行） |
| 4 | P-07 | P-05 完成 |
| 5 | P-08 | 所有勾选模块完成 |

## 输入/输出映射

| 模块 | 输入文件 | 输出文件 |
|------|---------|---------|
| P-01 | CLAUDE.md | docs/app-launch/01-framework.md |
| P-02 | CLAUDE.md | docs/app-launch/02-competitor-report.md |
| P-03 | CLAUDE.md, 01-framework.md | docs/app-launch/03-design-brief.md |
| P-04 | CLAUDE.md, 01-framework.md | docs/app-launch/04-tech-spec.md |
| P-05 | CLAUDE.md, 01-framework.md, 02-competitor-report.md | docs/app-launch/05-compliance-checklist.md |
| P-06 | CLAUDE.md, 01-framework.md, 04-tech-spec.md | docs/app-launch/06-external-dependencies.md |
| P-07 | CLAUDE.md, 05-compliance-checklist.md | docs/app-launch/07-store-strategy.md |
| P-08 | CLAUDE.md + 所有已生成文档 | docs/app-launch/00-index.md |
```

- [ ] **Step 2: 创建 app-launch/quality-standards.md**

```markdown
# 通用验收标准

> 模块特有的验收标准在各 `prompts/P-XX.md` 中，本文件只放跨模块通用标准。

## 文档结构
- [ ] 所有输出文档使用 Markdown，含清晰的二级/三级标题
- [ ] 文件命名遵循 0X-description.md 格式
- [ ] 文档末尾含"最后更新"时间戳

## 一致性要求
- [ ] 所有文档中的项目名称、上线日期保持一致
- [ ] 输出文件中的外部依赖名称与 CLAUDE.md 对齐
- [ ] 竞品名称在所有文档中保持一致
- [ ] 待人工确认项总数 ≤ 10 条

## 提交规范
- [ ] 每个文件生成后立即保存到 docs/app-launch/ 目录
- [ ] 每次修改在文档末尾追加变更日志
```

- [ ] **Step 3: 创建 app-launch/CHANGELOG.md**

```markdown
# CHANGELOG

| 日期 | 版本 | 影响模块 | 变更类型 | 变更摘要 | 来源项目 |
|------|------|---------|---------|---------|---------|
| 2026-05-21 | v1.0 | 全部 | 初始化 | 基于融小集 Prompt 原子指令库迁移，升级为 Skill 集群 | 融小集App |
```

---

### Task 4: 创建总控 Skill（app-launch/SKILL.md）

**操作**：编写总控 skill 的 SKILL.md，这是整个 skill 库的大脑。

- [ ] **Step 1: 写入 app-launch/SKILL.md**

```markdown
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
```

---

### Task 5: 创建 8 个独立模块 Skill

**操作**：为 P-01 ~ P-08 各创建一个薄封装 SKILL.md（~50-60 行/个）。

- [ ] **Step 1: app-framework/SKILL.md（P-01）**

```markdown
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
```

- [ ] **Step 2: app-competitor/SKILL.md（P-02）**

```markdown
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
```

- [ ] **Step 3: app-design/SKILL.md（P-03）**

```markdown
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
```

- [ ] **Step 4: app-tech-spec/SKILL.md（P-04）**

```markdown
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
```

- [ ] **Step 5: app-compliance/SKILL.md（P-05）**

```markdown
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
```

- [ ] **Step 6: app-dependencies/SKILL.md（P-06）**

```markdown
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
```

- [ ] **Step 7: app-store-strategy/SKILL.md（P-07）**

```markdown
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
```

- [ ] **Step 8: app-qa/SKILL.md（P-08）**

```markdown
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
```

---

### Task 6: 创建 install.sh

- [ ] **Step 1: 写入 install.sh**

```bash
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
```

- [ ] **Step 2: 添加执行权限**

```bash
chmod +x /Users/a51nb/knowledge/AI使用/skills/install.sh
```

---

### Task 7: 创建 README.md

- [ ] **Step 1: 写入 README.md**

```markdown
# App Launch Skills

一套基于 Claude Code 的 App 项目上架加速工具集。将 3 个月的 App 从零到上线推进经验固化为 9 个可触发的 Skill。

## My Story

在做 App 从 0 到上线的过程中，我发现每次推进项目都要反复粘贴 Prompt、手动串联文档、输出质量参差不齐。我把这套流程整理成 [Prompt 原子指令库](prompt-atomic-library-v1.md)，后来升级为这套 Skill 库。

现在启动一个新项目，只需要在 Claude Code 中说 **"新项目上架"**，8 份上线文档自动按依赖关系生成。

## 解决的问题

| 痛点 | 之前 | 现在 |
|------|------|------|
| 手动粘贴 | 8 个 Prompt 逐个复制执行 | 一键说"新项目上架"，自动调度执行 |
| 质量不稳定 | 每次输出差异大，反复修正 | 验收标准内置，不达标自动迭代修正 |
| 不够灵活 | 一套全流程跑到底 | 启动时一次性勾选跳过不需要的模块 |
| 单点修改难 | 改了前面要重跑后面 | 9 个独立 Skill，改哪个就触发哪个 |

## 快速开始

### 安装

```bash
git clone https://github.com/xxx/app-launch-skills.git ~/.claude/skills/app-launch-skills
bash ~/.claude/skills/app-launch-skills/install.sh
```

### 前提条件

1. Claude Code 已安装
2. 项目目录下有 `CLAUDE.md`，内容至少包含：
   - 产品定位/一句话描述
   - 目标用户
   - 核心功能列表
3. 如果项目需要竞品分析和政策研究，确保 CC 有 Web Search 权限

### 使用

```bash
cd my-app-project
claude
```

然后说：**"新项目上架"**

### 只生成某个文档

```bash
"帮我生成设计需求文档"     → 触发 app-design（仅 P-03）
"补充一下竞品分析"         → 触发 app-competitor（仅 P-02）
"跑一下文档质检"          → 触发 app-qa（仅 P-08）
```

## Skill 清单

| Skill | 编号 | 用途 | 输出文件 |
|-------|------|------|---------|
| `app-launch` | — | 总控：勾选→调度→质检 | 自动调用子模块 |
| `app-framework` | P-01 | 项目推进框架 | `01-framework.md` |
| `app-competitor` | P-02 | 竞品/政策分析 | `02-competitor-report.md` |
| `app-design` | P-03 | 设计需求文档 | `03-design-brief.md` |
| `app-tech-spec` | P-04 | 技术架构方案 | `04-tech-spec.md` |
| `app-compliance` | P-05 | 合规上线清单 | `05-compliance-checklist.md` |
| `app-dependencies` | P-06 | 外部依赖计划 | `06-external-dependencies.md` |
| `app-store-strategy` | P-07 | 商店上架策略 | `07-store-strategy.md` |
| `app-qa` | P-08 | 文档质检索引 | `00-index.md` |

## 工作原理

```
用户说 "新项目上架"
    │
    ▼
app-launch 触发
    │
    ├── 环境检查（CLAUDE.md 存在？）
    ├── 一次性勾选（8 模块，默认全选）
    ├── 按 DAG 调度（无依赖并行，有依赖串行）
    └── 质检收尾（00-index.md + 待确认项汇总）
```

生成文档全部存放在项目的 `docs/app-launch/` 目录。

## 设计理念

- **Prompt 集中管理**：8 条角色 Prompt 集中在 `app-launch/prompts/`，统一迭代升级
- **Skill 薄封装**：每个模块的 SKILL.md < 60 行，职责单一：触发 → 读 Prompt → 执行
- **渐进式披露**：SKILL.md 只放流程和规则，详细 Prompt 按需加载
- **文件系统解耦**：模块间通过输出文件（`docs/app-launch/`）传递数据，不直接耦合

## 贡献

基于你的项目经验改进 Prompt 资产：

1. 修改 `app-launch/prompts/P-XX-name.md` 中的角色 Prompt
2. 在 `app-launch/CHANGELOG.md` 中追加变更记录
3. 提交 PR

新增模块（如 P-09 灰度发布方案）：
1. 新建 `app-launch/prompts/P-09-name.md`
2. 更新 `app-launch/dependency-graph.md`
3. 新建 `app-name/SKILL.md`（<60 行）
4. 更新 `install.sh` 的 SKILLS 列表

## 版本记录

见 [CHANGELOG.md](app-launch/CHANGELOG.md)
```

---

### Task 8: 创建/更新 CLAUDE.md 索引页

- [ ] **Step 1: 写入 CLAUDE.md**

```markdown
---
tags:
  - hub
  - AI
  - product
  - active
---

# App Launch Skill 库

> 📍 这是 App Launch Skills 的导航面板。
> 安装后，在任何项目目录说"新项目上架"即可触发。

## Skill 清单

| Skill | 编号 | 用途 | 输出文件 | 状态 |
|-------|------|------|---------|------|
| app-launch | — | 总控：勾选→调度→质检 | 自动调用子模块 | active |
| app-framework | P-01 | 项目推进框架 | 01-framework.md | active |
| app-competitor | P-02 | 竞品/政策分析 | 02-competitor-report.md | active |
| app-design | P-03 | 设计需求文档 | 03-design-brief.md | active |
| app-tech-spec | P-04 | 技术架构方案 | 04-tech-spec.md | active |
| app-compliance | P-05 | 合规上线清单 | 05-compliance-checklist.md | active |
| app-dependencies | P-06 | 外部依赖计划 | 06-external-dependencies.md | active |
| app-store-strategy | P-07 | 商店上架策略 | 07-store-strategy.md | active |
| app-qa | P-08 | 文档质检索引 | 00-index.md | active |

## 快速使用

| 我想... | 触发 |
|---------|------|
| 从零规划一个新项目 | "新项目上架" |
| 只改设计文档的一部分 | "修改设计文档的色值方案" |
| 补充竞品分析 | "竞品分析里加一家新的" |
| 检查文档一致性 | "跑一下文档质检" |

## 依赖关系

参见 [[dependency-graph|依赖关系 DAG]]

## 相关资产

- [[prompt-atomic-library-v1|原始 Prompt 原子指令库 v1.0]]（已迁移）
- [[app-launch-skills-design|设计文档]]
- [[如何写出工业级SKILL|Skill 设计参考]]
- [[CHANGELOG|版本日志]]
```

---

### Task 9: 标记原始文件为"已迁移"

- [ ] **Step 1: 在 prompt-atomic-library-v1.md 顶部插入迁移标记**

在文件第一行（`# Prompt 原子指令库 v1.0` 之前）插入：

```markdown
> ⚠️ 本文件已迁移至 Skill 库（2026-05-21），不再独立使用。
> 保留作为历史参考和版本档案。最新 Prompt 在 `app-launch/prompts/` 目录。
> 使用方式：在任意项目说"新项目上架"，自动按编排执行。

---
```

---

### Task 10: 创建 symlink（本地验证）

- [ ] **Step 1: 创建所有 symlink 到 ~/.claude/skills/**

```bash
SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="/Users/a51nb/knowledge/AI使用/skills"

for skill in app-launch app-framework app-competitor app-design \
              app-tech-spec app-compliance app-dependencies \
              app-store-strategy app-qa; do
  ln -sf "$REPO_DIR/$skill" "$SKILLS_DIR/$skill"
  echo "✅ $skill"
done
```

- [ ] **Step 2: 验证 symlink 全部生效**

```bash
ls -la $HOME/.claude/skills/app-*
```
预期：9 个 symlink 全部指向 `.../AI使用/skills/app-*`

---

### Task 11: 最终验证

- [ ] **Step 1: 文件完整性检查**

```bash
# 检查所有必要文件存在
EXPECTED_FILES=(
  "app-launch/SKILL.md"
  "app-launch/prompts/P-01-framework.md"
  "app-launch/prompts/P-02-competitor.md"
  "app-launch/prompts/P-03-design.md"
  "app-launch/prompts/P-04-tech-spec.md"
  "app-launch/prompts/P-05-compliance.md"
  "app-launch/prompts/P-06-dependencies.md"
  "app-launch/prompts/P-07-store-strategy.md"
  "app-launch/prompts/P-08-qa.md"
  "app-launch/dependency-graph.md"
  "app-launch/quality-standards.md"
  "app-launch/CHANGELOG.md"
  "app-framework/SKILL.md"
  "app-competitor/SKILL.md"
  "app-design/SKILL.md"
  "app-tech-spec/SKILL.md"
  "app-compliance/SKILL.md"
  "app-dependencies/SKILL.md"
  "app-store-strategy/SKILL.md"
  "app-qa/SKILL.md"
  "README.md"
  "install.sh"
  "CLAUDE.md"
)

BASE="/Users/a51nb/knowledge/AI使用/skills"
missing=0
for f in "${EXPECTED_FILES[@]}"; do
  if [ ! -f "$BASE/$f" ]; then
    echo "❌ MISSING: $f"
    missing=1
  else
    echo "✅ $f"
  fi
done

if [ $missing -eq 0 ]; then
  echo ""
  echo "✅ 所有文件检查通过"
else
  echo ""
  echo "❌ 有 $missing 个文件缺失"
fi
```

- [ ] **Step 2: SKILL.md 格式检查**

```bash
# 检查 9 个 SKILL.md 都包含 YAML frontmatter（name + description）
for skill in app-launch app-framework app-competitor app-design \
             app-tech-spec app-compliance app-dependencies \
             app-store-strategy app-qa; do
  file="/Users/a51nb/knowledge/AI使用/skills/$skill/SKILL.md"
  if head -1 "$file" | grep -q "^---$"; then
    echo "✅ $skill: frontmatter OK"
  else
    echo "❌ $skill: frontmatter 缺失或格式错误"
  fi
done
```

---

### Task 12: 提交

- [ ] **Step 1: 初始化 git（如未初始化）并提交**

```bash
cd /Users/a51nb/knowledge/AI使用/skills
git init
git add .
git commit -m "feat: App Launch Skills v1.0 - 初始实现

基于融小集 Prompt 原子指令库升级为 Claude Code Skill 集群。
包含 1 个总控 skill + 8 个独立模块 skill + 配套基础设施。

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

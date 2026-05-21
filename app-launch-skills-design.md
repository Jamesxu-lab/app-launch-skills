---
tags:
  - design
  - AI
  - product
  - draft
---

# App Launch Skills — 设计文档

> 基于app产品上架的完整设计
> 设计日期：2026-05-21
> 设计方法：brainstorming skill（superpowers）

---

## 1. 背景与动机

### 1.1 项目来源

在推进融小集 App 上线过程中，整理了一份 [Prompt 原子指令库 v1.0](prompt-atomic-library-v1.md)，将上线流程拆解为 8 组角色 Prompt（P-01 ~ P-08）+ 1 条主编排指令（ORCH-01）。

实战中发现了三个核心痛点：

| 痛点 | 具体表现 |
|------|---------|
| **手动粘贴** | 8 个 Prompt 逐个复制粘贴到 CC 执行，无法自动化串联 |
| **质量不稳定** | 每次输出差异大，需要反复修正，验收标准没有强制执行 |
| **不够灵活** | "全家桶"流程，团队有技术就跳过不了技术方案，有设计师就跳过不了设计文档 |

### 1.2 目标

将 Prompt 原子指令库升级为一套 **Claude Code Skill 集群**，实现：

1. **一键调度**：说"新项目上架"，自动按依赖关系串行/并行执行
2. **灵活跳过**：启动时一次性勾选不需要的模块
3. **单点修改**：每个模块有独立 skill 入口，支持单独触发修改
4. **公开可复用**：发布到 GitHub，任何人可以安装使用
5. **持续迭代**：Prompt 资产集中管理，每个新项目的经验可反哺到 Prompt 中

---

## 2. 核心设计决策

| # | 决策点 | 选型 | 理由 |
|---|--------|------|------|
| 1 | 灵活方式 | 默认全量 + 启动时一次性勾选跳过 | 比预设场景模板更灵活，用户按实际团队配置决定 |
| 2 | 修改模式 | 单点修改，独立 skill 触发 | 不重跑全流程，改哪个模块就触发哪个 |
| 3 | Skill 粒度 | 1 个总控 + 8 个独立模块 skill | 参照 Gstack 模式，每个 SKILL.md 自给自足 |
| 4 | Prompt 存放 | 集中在 `app-launch/prompts/`，独立 skill 薄封装引用 | 统一迭代 Prompt 资产，独立 skill 负责触发和调度 |
| 5 | 安装方式 | GitHub 仓库 + install.sh 一键 symlink | 全局可用（`~/.claude/skills/`），同时可发布可复用 |
| 6 | 输出目录 | `docs/app-launch/`（项目根目录下） | 不污染根目录，8 个文件集中管理 |

---

## 3. 目录结构

### 3.1 仓库结构

```
app-launch-skills/              ← GitHub Repo，同时也是 Vault 内 AI使用/skills/ 目录
│
├── README.md                   # 项目介绍 + 安装说明 + My Story 案例展示
├── install.sh                  # 一键安装脚本
├── CLAUDE.md                   # Obsidian 索引用
│
├── app-launch/                 # 总控 Skill（大脑）
│   ├── SKILL.md                # 入口：触发 → 勾选 → 调度 → 质检（200-300行）
│   ├── prompts/                # 核心资产：8 条角色 Prompt
│   │   ├── P-01-framework.md
│   │   ├── P-02-competitor.md
│   │   ├── P-03-design.md
│   │   ├── P-04-tech-spec.md
│   │   ├── P-05-compliance.md
│   │   ├── P-06-dependencies.md
│   │   ├── P-07-store-strategy.md
│   │   └── P-08-qa.md
│   ├── dependency-graph.md     # 依赖关系 DAG + 并行策略
│   ├── quality-standards.md    # 跨模块通用验收框架
│   └── CHANGELOG.md            # 版本迭代记录
│
├── app-framework/SKILL.md      # P-01 薄封装（~60行）
├── app-competitor/SKILL.md     # P-02
├── app-design/SKILL.md         # P-03
├── app-tech-spec/SKILL.md      # P-04
├── app-compliance/SKILL.md     # P-05
├── app-dependencies/SKILL.md   # P-06
├── app-store-strategy/SKILL.md # P-07
├── app-qa/SKILL.md             # P-08
│
├── prompt-atomic-library-v1.md # 历史档案（加盖"已迁移"标记）
├── 如何写出工业级SKILL.md       # Skill 设计参考
└── app-launch-skills-design.md # 本设计文档
```

### 3.2 全局安装映射

```
~/.claude/skills/
├── app-launch         -> .../AI使用/skills/app-launch          (symlink)
├── app-framework      -> .../AI使用/skills/app-framework        (symlink)
├── app-competitor     -> .../AI使用/skills/app-competitor       (symlink)
├── app-design         -> .../AI使用/skills/app-design           (symlink)
├── app-tech-spec      -> .../AI使用/skills/app-tech-spec        (symlink)
├── app-compliance     -> .../AI使用/skills/app-compliance       (symlink)
├── app-dependencies   -> .../AI使用/skills/app-dependencies     (symlink)
├── app-store-strategy -> .../AI使用/skills/app-store-strategy   (symlink)
└── app-qa             -> .../AI使用/skills/app-qa               (symlink)
```

安装命令：
```bash
git clone https://github.com/xxx/app-launch-skills.git ~/.claude/skills/app-launch-skills
bash ~/.claude/skills/app-launch-skills/install.sh
```

---

## 4. Skill 详细设计

### 4.1 总控 Skill：app-launch

```yaml
---
name: app-launch
description: Use when starting a new app project, planning app launch, or
  needing to generate app store launch documents. Triggers when user mentions
  app launch, new app project, app store launch, app publish, or mobile app
  go-live preparation.
---
```

**职责**：
- Step 1：环境检查（CLAUDE.md 是否存在、是否有前序输出文件）
- Step 2：展示 8 模块勾选清单，默认全选
- Step 3：按 dependency-graph.md 调度，无依赖并行/有依赖串行
- Step 4：P-08 质检收尾，展示待人工确认项

**执行流程**：

```
CLAUDE.md 检查
    │
    ▼
一次性勾选清单（默认全选，用户跳过不需要的）
    │
    ▼
阶段 1：并行 [P-01] [P-02]              ← 无依赖
    │
    ▼
阶段 2：并行 [P-03] [P-04]              ← 都只依赖 P-01
    │
    ▼
阶段 3：并行 [P-05] [P-06]              ← 各自有依赖
    │
    ▼
阶段 4：串行 [P-07]                     ← 依赖 P-05
    │
    ▼
阶段 5：串行 [P-08]                     ← 依赖全部
    │
    ▼
输出 00-index.md + 待人工确认汇总
```

### 4.2 独立模块 Skill（8 个）

每个模块 skill 遵循统一模板（薄封装，~60 行）：

```yaml
---
name: app-<module>
description: Use when you need to [动词] [产出物].
  Triggers when user mentions [触发短语].
  Do NOT trigger on [排除场景].
---

# <Module Name>

## Process
1. 读取 `CLAUDE.md` 获取项目需求
2. 读取前序依赖文件（见 Dependencies）
3. 加载 `../app-launch/prompts/P-XX-<name>.md` 中的完整 Prompt
4. 按 Prompt 角色和格式要求生成输出文件
5. 对照验收标准逐项自查
6. 不达标则读取输出文件，追加修正指令迭代

## Dependencies
- Input: `CLAUDE.md`, `<前序文件>`
- Reference: `../app-launch/prompts/P-XX-<name>.md`
- Output: `<输出文件>`
```

#### 8 个 Skill 清单

| Skill | 编号 | 触发关键词 | 输入依赖 | 输出文件 |
|-------|------|-----------|---------|---------|
| `app-framework` | P-01 | 项目框架、推进计划、冲刺计划、上线排期、milestone | 仅 CLAUDE.md | `01-framework.md` |
| `app-competitor` | P-02 | 竞品分析、竞品报告、政策分析、行业研究、competitive | 仅 CLAUDE.md | `02-competitor-report.md` |
| `app-design` | P-03 | 设计需求、设计文档、UI设计规范、design brief、Figma | CLAUDE.md + P-01 | `03-design-brief.md` |
| `app-tech-spec` | P-04 | 技术方案、技术架构、API设计、数据库设计、tech spec | CLAUDE.md + P-01 | `04-tech-spec.md` |
| `app-compliance` | P-05 | 合规清单、上线材料、证照清单、隐私合规、regulatory | CLAUDE.md + P-01 + P-02 | `05-compliance-checklist.md` |
| `app-dependencies` | P-06 | 外部依赖、三方对接、接入计划、dependency plan | CLAUDE.md + P-01 + P-04 | `06-external-dependencies.md` |
| `app-store-strategy` | P-07 | 商店上架、应用商店、ASO、审核策略、App Store | CLAUDE.md + P-05 | `07-store-strategy.md` |
| `app-qa` | P-08 | 文档质检、一致性检查、文档索引、output review | CLAUDE.md + 所有已生成文档 | `00-index.md` |

#### 重合触发消歧

`app-compliance` 和 `app-store-strategy` 都涉及"商店"，通过互斥排除：

```yaml
# app-compliance 的 description（底部加）
Do NOT trigger on app store review strategy or ASO optimization.

# app-store-strategy 的 description（底部加）
Do NOT trigger on compliance licenses or regulatory filings.
```

### 4.3 触发优先级

```
用户说 "新项目上架"
  → 触发 app-launch（优先匹配"新项目"、"启动"等全流程关键词）

用户说 "修改设计文档的色值"
  → 触发 app-design（匹配"修改" + "设计文档"）

用户说 "帮我看看文档有没有不一致"
  → 触发 app-qa（匹配"文档" + "不一致" = 质检意图）
```

---

## 5. 依赖关系与并行策略

```
CLAUDE.md（唯一输入源）
    │
    ├──▶ 01-framework ──┬──▶ 03-design ──────┐
    │                    │                     │
    ├──▶ 02-competitor ─┤                     │
    │                    │                     │
    │                    ├──▶ 04-tech-spec ────┤
    │                    │                     │
    │                    └──▶ 05-compliance ─┬─┴──▶ 07-store-strategy
    │                                        │
    │                    ┌──▶ 06-deps ────────┘
    │                    │
    └────────────────────┴──▶ 00-index（最后生成）
```

| 阶段 | 并行组 | 依赖条件 |
|------|--------|---------|
| 1 | P-01 + P-02 | 无依赖，可同时执行 |
| 2 | P-03 + P-04 | 均依赖 P-01 完成，P-03 和 P-04 之间无依赖 |
| 3 | P-05 + P-06 | P-05 依赖 P-01+P-02，P-06 依赖 P-01+P-04，无互相依赖 |
| 4 | P-07 | 依赖 P-05 完成 |
| 5 | P-08 | 依赖所有勾选模块完成 |

### 增量模式

当检测到已有输出文件时：
- 已有文件跳过生成，作为后续模块的依赖输入
- 用户可以选择"覆盖已有"或"仅生成缺失"
- 单点修改时，触发对应独立 skill 更新目标文件，不重跑其他

---

## 6. 输出文件约定

### 6.1 项目内目录

```
NewApp/
├── CLAUDE.md
├── docs/app-launch/
│   ├── 00-index.md                     ← P-08 产出，阅读入口
│   ├── 01-framework.md                 ← P-01
│   ├── 02-competitor-report.md         ← P-02
│   ├── 03-design-brief.md              ← P-03
│   ├── 04-tech-spec.md                 ← P-04
│   ├── 05-compliance-checklist.md      ← P-05
│   ├── 06-external-dependencies.md     ← P-06
│   └── 07-store-strategy.md            ← P-07
└── src/
```

### 6.2 通用验收标准（跨模块共享）

```markdown
## 文档结构
- [ ] 所有输出文档使用 Markdown，含清晰的二级/三级标题
- [ ] 文件命名遵循 0X-description.md 格式
- [ ] 文档末尾含"最后更新"时间戳

## 一致性要求
- [ ] 所有文档中的项目名称、上线日期保持一致
- [ ] 外部依赖名称与 CLAUDE.md 对齐
- [ ] 待人工确认项总数 ≤ 10 条

## 提交规范
- [ ] 每个文件生成后立即保存
- [ ] 每次修改追加变更日志
```

（模块特有的验收标准留在各自的 `prompts/P-XX.md` 中。）

---

## 7. 迭代机制

### 7.1 三层迭代

```
发现质量不够
  → 修改 prompts/P-XX.md（改 Prompt 内容）    ← 立即生效
  → 更新 CHANGELOG.md（记录改动）               ← 可追溯
  → 如果验收标准变了，更新 quality-standards.md  ← 可选
  → 如果依赖关系变了，更新 dependency-graph.md   ← 可选
```

**关键原则**：改 Prompt = 只改一个文件。独立 skill 的 SKILL.md 通过引用路径加载，路径不变则无需修改。

### 7.2 质量反馈闭环

```
用 P-03 出设计文档
    ↓
发现页面清单遗漏了"注册/登录"流程           ← 实际使用发现
    ↓
在 P-03-design.md 中补充页面清单章节要求     ← 修改 Prompt
    ↓
下次用 P-03 自动包含注册/登录页面            ← 验证修复
    ↓
CHANGELOG 记录："补充页面清单需覆盖注册登录"  ← 归档
```

### 7.3 新增模块约定

当新项目经验催生新模块时（如 P-09 灰度发布方案）：

1. 新建 `app-launch/prompts/P-09-canary.md`
2. 更新 `app-launch/dependency-graph.md` 追加 P-09 的依赖关系
3. 新建 `app-canary/SKILL.md`（<60 行薄封装）
4. 在 `~/.claude/skills/` 新增 symlink（或运行 install.sh）
5. 更新 `CLAUDE.md` 索引页
6. CHANGELOG 追加记录

### 7.4 CHANGELOG 格式

```markdown
| 日期 | 版本 | 影响模块 | 变更类型 | 变更摘要 | 来源项目 |
|------|------|---------|---------|---------|---------|
| 2026-05-21 | v1.0 | 全部 | 初始化 | 基于融小集项目经验迁移 | 融小集App |
```

---

## 8. 公开发布方案

### 8.1 README 结构

```markdown
# App Launch Skills

一套基于 Claude Code 的 App 项目上架加速工具集。
将 3 个月的 App 上线推进经验固化为 9 个可触发的 Skill。

## My Story
从融小集项目实战出发……

## 解决的问题（Before/After）
| 痛点 | 之前 | 现在 |
|------|------|------|
| ...

## 快速开始（安装 + 使用）

## Skill 清单

## 工作原理（DAG 图）

## 设计理念（Prompt 集中 vs 薄封装）

## 贡献指南

## 版本记录
```

### 8.2 install.sh

```bash
#!/bin/bash
SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$HOME/.claude/skills/app-launch-skills"

SKILLS=(
  "app-launch" "app-framework" "app-competitor" "app-design"
  "app-tech-spec" "app-compliance" "app-dependencies"
  "app-store-strategy" "app-qa"
)

for skill in "${SKILLS[@]}"; do
  ln -sf "$REPO_DIR/$skill" "$SKILLS_DIR/$skill"
done

echo "✅ App Launch Skills 安装完成，9 个 skill 已注册。"
```

### 8.3 你的发布流程

```
AI使用/skills/（Vault = GitHub Repo）
    │
    │  修改 Prompt → CHANGELOG
    │  新项目经验 → 更新对应 P-XX
    │
    ├── git push → GitHub
    │
    ▼
用户 git clone + bash install.sh → ~/.claude/skills/
```

---

## 9. 从原始 Prompt 库迁移

```
prompt-atomic-library-v1.md          新结构
─────────────────────────────         ─────────────────────────────
P-01 指令（行36-63）             →   app-launch/prompts/P-01-framework.md
P-01-FIX 修正指令（行73-87）     →   合入 P-01 的"修正指令"章节
P-02 指令                       →   app-launch/prompts/P-02-competitor.md
P-03 指令                       →   app-launch/prompts/P-03-design.md
P-04 指令                       →   app-launch/prompts/P-04-tech-spec.md
P-05 指令                       →   app-launch/prompts/P-05-compliance.md
P-06 指令                       →   app-launch/prompts/P-06-dependencies.md
P-07 指令                       →   app-launch/prompts/P-07-store-strategy.md
P-08 指令                       →   app-launch/prompts/P-08-qa.md
ORCH-01 主编排                   →   app-launch/SKILL.md 的调度逻辑
快速参考卡                       →   dependency-graph.md
文件命名约定 + 使用说明           →   quality-standards.md
```

原始文件顶部添加迁移标记：
```markdown
> ⚠️ 本文件已迁移至 Skill 库，不再独立使用。
> 保留作为历史参考。最新版本在 app-launch/prompts/ 目录。
```

---

## 10. 设计参考来源

- **Superpowers/Gstack**：Skill 结构模式（目录 + SKILL.md + 引用文件）、触发设计（`Use when X`）、铁律/反模式表格
- **如何写出工业级SKILL.md**：渐进式披露、SKILL.md < 500 行、验证-打分-迭代闭环
- **融小集项目实战**：8 组 Prompt 的内容基础、依赖链路、验收标准

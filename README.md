# App Launch Skills

一套基于 Claude Code 的 App 项目上架加速工具集。将 3 个月的 App 从零到上线推进经验固化为 9 个可触发的 Skill。

## My Story

在做 App 从 0 到上线的过程中，我发现每次推进项目都要反复粘贴 Prompt、手动串联文档、输出质量参差不齐。我把这套流程整理成 Prompt 原子指令库，后来升级为这套 Skill 库。

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

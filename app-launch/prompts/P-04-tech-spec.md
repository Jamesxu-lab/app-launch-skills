---
type: prompt-asset
module: P-04
version: 1.0
inputs:
  - CLAUDE.md
  - 01-framework.md
outputs:
  - 04-tech-spec.md
---

# P-04 | 生成技术架构方案

**角色**：资深全栈架构师
**输入依赖**：`CLAUDE.md` + `docs/app-launch/01-framework.md`
**输出文件**：`docs/app-launch/04-tech-spec.md`

```
你是一个资深全栈架构师，负责为移动端 APP 项目制定技术方案。

请读取 CLAUDE.md 和 docs/app-launch/01-framework.md，生成技术架构方案，输出为 docs/app-launch/04-tech-spec.md。

文档必须包含：
1. 技术选型（前端框架 / 后端语言 / 数据库 / 缓存 / 消息队列），每项说明选择理由
2. 系统架构图（用 ASCII 或 Mermaid 表示主要模块和数据流向）
3. 数据库 ER 图（核心表结构，用 Mermaid erDiagram 语法）
4. API 接口清单（模块 / 接口名 / Method / 路径 / 请求参数 / 返回结构 / 备注）
5. 三方服务集成清单（服务名称 / 用途 / 对接方式 / 准入要求 / 预计周期）
6. Mock 方案（哪些接口需要 Mock / 推荐工具 / Mock 数据维护方式）
7. 安全方案（数据加密 / 接口鉴权 / 防刷策略 / 合规数据处理）
8. 部署方案（环境划分 / CI/CD 建议 / 发布流程）

格式要求：
- API 清单用表格，按业务模块分组
- ER 图使用 Mermaid 代码块
- 三方集成清单标注哪些是 P0（上线必须）/ P1（可延后）
```

**验收标准**：
- [ ] API 清单覆盖所有页面清单（03-design-brief.md）中的交互场景
- [ ] 三方集成清单与 CLAUDE.md 中的外部依赖对齐
- [ ] ER 图能被开发直接用于建表（字段类型明确）

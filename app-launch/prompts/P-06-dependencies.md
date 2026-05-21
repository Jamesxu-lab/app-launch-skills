---
type: prompt-asset
module: P-06
version: 1.0
inputs:
  - CLAUDE.md
  - 01-framework.md
  - 04-tech-spec.md
outputs:
  - 06-external-dependencies.md
---

# P-06 | 生成外部依赖执行计划

**角色**：项目经理
**输入依赖**：`CLAUDE.md` + `docs/app-launch/01-framework.md` + `docs/app-launch/04-tech-spec.md`
**输出文件**：`docs/app-launch/06-external-dependencies.md`

```
你是一个擅长多方协调的项目经理。

请读取 CLAUDE.md、docs/app-launch/01-framework.md 和 docs/app-launch/04-tech-spec.md，
梳理所有外部依赖，生成执行计划，输出为 docs/app-launch/06-external-dependencies.md。

文档必须包含：
1. 外部依赖总览（依赖项 / 类型 / 优先级 / 影响范围 / 当前状态）
2. P0 依赖执行计划（最晚启动时间 / 对接负责人 / 具体行动项 / 里程碑）
3. P1 依赖执行计划（同上格式）
4. 依赖关系图（哪些依赖之间有先后顺序，用 ASCII 树状图表示）
5. 风险预案（如果某个 P0 依赖延误，备选方案是什么）
6. 周度跟进模板（用于项目周例会的依赖跟进表格格式）

优先级定义：
- P0：上线必须，延误直接影响上线时间
- P1：上线建议，可以 V1.1 补充

格式要求：
- 每个依赖项的"具体行动项"要拆解到人和日期
- 风险预案写出具体的替代方案，不能只写"提前沟通"
```

**验收标准**：
- [ ] P0 依赖每项都有风险预案
- [ ] 依赖关系图能体现至少 3 条依赖链
- [ ] 周度跟进模板可直接用于周会

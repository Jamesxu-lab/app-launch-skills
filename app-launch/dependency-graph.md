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

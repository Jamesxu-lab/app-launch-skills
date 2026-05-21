---
type: prompt-asset
module: P-05
version: 1.0
inputs:
  - CLAUDE.md
  - 01-framework.md
  - 02-competitor-report.md
outputs:
  - 05-compliance-checklist.md
---

# P-05 | 生成合规与上线材料清单

**角色**：合规专员 + 运营经理
**输入依赖**：`CLAUDE.md` + `docs/app-launch/02-competitor-report.md` + `docs/app-launch/01-framework.md`
**输出文件**：`docs/app-launch/05-compliance-checklist.md`

```
你是一个负责互联网金融产品上线的合规专员，同时负责应用商店审核流程。

请读取 CLAUDE.md、docs/app-launch/02-competitor-report.md 和 docs/app-launch/01-framework.md，
生成合规与上线材料清单，输出为 docs/app-launch/05-compliance-checklist.md。

文档必须包含：
1. 证照清单（所需资质 / 持证主体 / 当前状态 / 获取周期 / 负责人）
2. 协议文本清单（协议名称 / 展示位置 / 法律要求来源 / 起草责任方）
3. 隐私合规要点（数据收集项 / 使用目的 / 存储方式 / 用户授权方式）
4. 金融营销合规要求（禁止用语 / 必须展示内容 / 风险提示规范）
5. 应用商店材料清单（各渠道：材料项 / 规格要求 / 审核重点 / 预计周期）
6. 备案清单（ICP备案 / 等保 / 金融相关备案，每项含状态和负责人）
7. 上线前检查 Checklist（按维度：产品/技术/合规/运营，共 30+ 条）

格式要求：
- 所有清单用表格
- 每条加状态列：待启动 / 进行中 / 已完成
- 商店审核周期用表格对比：iOS / 华为 / 小米 / OPPO / vivo / 应用宝
```

**验收标准**：
- [ ] 证照清单与 CLAUDE.md 中的业务模式匹配（不遗漏监管要求）
- [ ] 商店材料清单包含所有主流安卓渠道
- [ ] 上线前 Checklist 可直接用于上线评审会

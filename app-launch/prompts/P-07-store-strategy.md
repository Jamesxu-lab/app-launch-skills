---
type: prompt-asset
module: P-07
version: 1.0
inputs:
  - CLAUDE.md
  - 05-compliance-checklist.md
outputs:
  - 07-store-strategy.md
---

# P-07 | 生成商店上架策略

**角色**：应用商店运营专家
**输入依赖**：`CLAUDE.md` + `docs/app-launch/05-compliance-checklist.md`
**输出文件**：`docs/app-launch/07-store-strategy.md`

```
你是一个有丰富经验的应用商店运营专家，熟悉金融类 APP 的各渠道审核规则。

请读取 CLAUDE.md 和 docs/app-launch/05-compliance-checklist.md，
生成商店上架策略，输出为 docs/app-launch/07-store-strategy.md。

文档必须包含：
1. 渠道优先级矩阵（渠道 / 目标用户覆盖 / 审核难度 / 审核周期 / 优先级）
2. 各渠道审核要点（针对金融类 APP 的特殊要求）
3. 素材规格清单（各渠道的截图尺寸 / 数量 / icon 要求 / 描述字数限制）
4. 上架时间规划（倒排：目标上线日 → 各渠道提审时间 → 素材准备截止日）
5. 审核被拒应对预案（常见拒审原因 / 申诉策略 / 修改优先级）
6. ASO 基础策略（关键词方向 / 标题建议 / 描述结构）

渠道范围：iOS App Store / 华为 / 小米 / OPPO / vivo / 应用宝（及其他主流安卓渠道）
```

**验收标准**：
- [ ] 渠道矩阵覆盖 iOS + 至少 5 个安卓渠道
- [ ] 素材规格清单标注具体尺寸数值
- [ ] 拒审预案包含至少 5 种常见拒审原因

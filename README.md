# SQL 专项练习

自 2026-09-13 开始的 SQL / 数据库运维练习记录。
环境：SQL Server 2022 Developer · SSMS 22 · 示例库 AdventureWorks2022

## 目录

| 文件 | 内容 | 关键概念 |
|---|---|---|
| `01_单表查询_TOP10订单.sql` | 查金额最大的 10 笔订单 | `SELECT` / `TOP` / `FROM` / `ORDER BY` |
| `02_分组聚合_年度销售额.sql` | 2011-2014 年度销售趋势 | `GROUP BY` / `COUNT` / `SUM` / `AVG` |
| `03_多表JOIN_畅销产品榜.sql` | 最畅销产品 TOP 10 | `JOIN ... ON` / 表别名 / 聚合 |

## 第 1 天（2026-09-13）

环境搭建完成，三句 SQL 跑通，识别出 4 个真实运维问题。
详见 `Documents/Codex/2026-09-10/new-chat/outputs/第1天_完成记录.md`

**业务发现**：2013 年订单数暴涨但客单价腰斩（9,623 → 3,452 → 1,906）。
猜想是零售小单占比上升，待用 `WHERE OnlineOrderFlag = 1` 验证。

## 待办

- [ ] 验证 `OnlineOrderFlag` 猜想
- [ ] 读《SQL学习指南》第 1-4 章并重敲示例

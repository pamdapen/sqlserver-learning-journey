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

---

## 开发环境

| 项目 | 值 |
|---|---|
| 数据库 | SQL Server 2022 Developer · 连接名 `localhost` |
| 客户端 | SSMS 22 |
| 示例库 | AdventureWorks2022（71 张表 / 121,317 行订单明细） |
| Git | Git for Windows 2.55 |

## 每天怎么提交

```powershell
cd C:\Users\仲墨涵\Documents\SQL专项练习
git add -A
git commit -m "第 X 天：今天练了什么"
git push
```

## 网络说明

本机 `github.com` 直连不稳定，已将 git 单独配置为经本地代理访问：

```
git config --global http.https://github.com.proxy http://127.0.0.1:10809
```

只对 github.com 生效，其他远程仓库不受影响。若以后不再需要代理：

```
git config --global --unset http.https://github.com.proxy
```

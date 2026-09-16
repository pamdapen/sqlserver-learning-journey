# SQL 专项练习

自 2026-09-13 开始的 SQL / 数据库运维练习记录。
环境：SQL Server 2022 Developer · SSMS 22 · 示例库 AdventureWorks2022

## 目录

| 文件 | 内容 | 关键概念 |
|---|---|---|
| `01_单表查询_TOP10订单.sql` | 查金额最大的 10 笔订单 | `SELECT` / `TOP` / `FROM` / `ORDER BY` |
| `02_分组聚合_年度销售额.sql` | 2011-2014 年度销售趋势 | `GROUP BY` / `COUNT` / `SUM` / `AVG` |
| `03_多表JOIN_畅销产品榜.sql` | 最畅销产品 TOP 10 | `JOIN ... ON` / 表别名 / 聚合 |
| `04_建库建表与主外键.sql` | 自建 `bank` 库：`person` / `favorite_food` | `CREATE DATABASE` / `IDENTITY` / 联合主键 / `FOREIGN KEY` |
| `05_第三章练习.sql` | 《SQL学习指南》第 3 章，10 条单表查询 | `WHERE` / `BETWEEN` / `IN` / `DISTINCT` / `LIKE` / `IS NULL` / `HAVING` |

## 第 1 天（2026-09-13）

环境搭建完成，三句 SQL 跑通，识别出 4 个真实运维问题。
详见 `Documents/Codex/2026-09-10/new-chat/outputs/第1天_完成记录.md`

**业务发现**：2013 年订单数暴涨但客单价腰斩（9,623 → 3,452 → 1,906）。
猜想是零售小单占比上升，待用 `WHERE OnlineOrderFlag = 1` 验证。

## 第 2 天（2026-09-15）

建 `bank` 库，`person` + `favorite_food` 两张表，跑通主外键约束的两个方向。
详见 `04_建库建表与主外键.sql`

**踩坑**：

- 列名拼错 `gerner` → 用 `sp_rename` 改名
- `street` 存不下中文地址：`VARCHAR(20)` → `NVARCHAR(50)`

**外键报错的两个方向**（措辞不同，含义正好相反）：

- 往子表插一条主表里不存在的引用 → 报 **FOREIGN KEY 约束冲突**，冲突发生于【主表】
- 删主表里正被引用的行 → 报 **REFERENCE 约束冲突**，冲突发生于【子表】

**工具**：学会了用「右键 → 任务 → 生成脚本」导出真实 DDL。

## 第 3 天（2026-09-16）

读完《SQL学习指南》第 3 章，在 `Production.Product`（504 行）上完成 10 条单表查询。
详见 `05_第三章练习.sql`

**最大的收获**：`WHERE Color IS NULL` 返回 248 行，`WHERE Color = NULL` 返回 **0 行**。
NULL 是"未知"不是"空"，判断它只有 `IS NULL` / `IS NOT NULL` 两种写法。

**方言改编**：书的示例是 MySQL，`LIMIT 10` 在 SQL Server 里写作 `SELECT TOP (10)`。

**工具**：学会「选中一段 + F5」只执行选中的语句，不用为了重跑某一句而删掉别的。

## 待办

- [ ] 验证 `OnlineOrderFlag` 猜想
- [ ] 读《SQL学习指南》第 4 章（过滤）
- [ ] 盲测：脱离资料默写建表语句（自增主键 + 联合主键 + 外键）

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

**提交前一定先跑一次 `git status`。** 它会把有改动的文件列出来。
如果列表里没出现你以为要提交的文件，就是文件存到仓库外面去了
—— SSMS 的「另存为」默认落在 `Documents\SQL Server Management Studio 22\`，
不在这个仓库里，`git add -A` 是看不见仓库外面的东西的。

## 网络说明

本机 `github.com` 直连不稳定，已将 git 单独配置为经本地代理访问：

```
git config --global http.https://github.com.proxy http://127.0.0.1:10809
```

只对 github.com 生效，其他远程仓库不受影响。若以后不再需要代理：

```
git config --global --unset http.https://github.com.proxy
```

**推送前必须让代理软件开着**，否则 `git push` 会卡住直到超时。

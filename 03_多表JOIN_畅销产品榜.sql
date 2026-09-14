/* ============================================================
   03 多表 JOIN：最畅销产品 TOP 10
   日期：2026-09-13
   要点：JOIN ... ON 多表关联 / 表别名 / 分组聚合
   对照：JOIN 相当于 Power Query 的「合并查询」
   ============================================================ */

USE AdventureWorks2022;

SELECT TOP (10)
       p.Name,
       SUM(d.OrderQty)   AS Qty,
       SUM(d.LineTotal)  AS Amount
FROM Sales.SalesOrderDetail AS d
JOIN Production.Product AS p ON p.ProductID = d.ProductID
GROUP BY p.Name
ORDER BY Amount DESC;

/* 为什么必须 JOIN：
   明细表 Sales.SalesOrderDetail 里只存了 ProductID，没有产品名。
   产品名在 Production.Product 里。
   如果每行订单都重复存一遍产品名，一亿行订单就把产品名存了一亿遍，
   改个产品名要改一亿行 —— 所以数据库只存编号，用的时候再拼。
   这叫范式化（Normalization），是数据库设计的核心思想。

   结果：TOP 10 里 6 个是 Mountain-200，全是高端车型。
   —— 按 Qty 排序和按 Amount 排序会得出不同结论。
*/

/* ============================================================
   01 单表查询：金额最大的 10 笔订单
   日期：2026-09-13
   要点：SELECT 选列 / TOP 限行 / FROM 指定表 / ORDER BY 排序
   ============================================================ */

USE AdventureWorks2022;

SELECT TOP (10)
       SalesOrderID,
       OrderDate,
       TotalDue
FROM   Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

/* 结果：最大单笔 187,487.825（2013-05-30）
   注意 OrderDate 是 datetime，日期和时间存在一起。
   以后做日期筛选不能写 = '2013-05-30'，要用区间：
   WHERE OrderDate >= '2013-05-30' AND OrderDate < '2013-05-31'
*/

/* ============================================================
   05 第 3 章：单表查询 10 条
   日期：2026-09-16
   对象：AdventureWorks2022.Production.Product（504 行）
   来源：《SQL学习指南（第3版）》第 3 章
   改动：书上的示例是 MySQL，本文件按 SQL Server 写法
         LIMIT 10  ->  TOP (10)
   要点：WHERE 条件筛选 / TOP 限行 / BETWEEN / IN /
         DISTINCT / LIKE / IS NULL / GROUP BY /
         HAVING / ORDER BY

   执行提示：选中某一段按 F5 只跑选中的；不选中=整份全跑。
   ============================================================ */

USE AdventureWorks2022;
GO


-- ========== 1. 列筛选 ==========
SELECT ProductID, Name, ListPrice
FROM Production.Product;

/* 结果：504 行 —— 这是整张表的总行数，后面每道题都拿它当基准对比。
   表在 Production 架构下，所以表名写两段：Production.Product
   写成两段还有个好处：不依赖 USE 切换，脚本换谁来跑结果都一样。
*/


-- ========== 2. TOP + ORDER BY ==========
SELECT TOP (10) ProductID, Name, ListPrice
	FROM Production.Product
	ORDER BY ListPrice DESC;

/* 结果：
   749 | Road-150 Red, 62       | 3578.2700
   750 | Road-150 Red, 44       | 3578.2700
   751 | Road-150 Red, 48       | 3578.2700
   752 | Road-150 Red, 52       | 3578.2700
   753 | Road-150 Red, 56       | 3578.2700
   771 | Mountain-100 Silver, 38 | 3399.9900
   772 | Mountain-100 Silver, 42 | 3399.9900
   773 | Mountain-100 Silver, 44 | 3399.9900
   774 | Mountain-100 Silver, 48 | 3399.9900
   775 | Mountain-100 Black, 38  | 3374.9900

   ★ 方言点：书上写 LIMIT 10（在句尾），SQL Server 写 TOP (10)（在 SELECT 后）。
   ORDER BY 默认升序，要降序必须显式写 DESC。
   Road-150 五个尺码同价 3578.27 —— 排在最前面，说明它是旗舰款。
*/


-- ========== 3. 标价在 100 到 500 之间的产品 ==========
SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE ListPrice BETWEEN 100 AND 500;

/* 结果：78 行，最低 101.2400，最高 404.9900
   BETWEEN 是闭区间，两头都算（>= 100 且 <= 500）。
*/


-- ========== 4. 颜色是 Red / Black / White 的产品 ==========
SELECT ProductID, Name, Color
	FROM Production.Product
	WHERE Color IN ('Red', 'Black', 'White');

/* 结果：135 行

   等价写法（结果完全一样，也是 135 行）：
     WHERE Color = 'Red' OR Color = 'Black' OR Color = 'White'
   IN 就是多个 OR 的简写。条件一多，IN 短得多也更不容易写错。
*/


-- ========== 5. 这张表一共有哪些颜色（去重） ==========
SELECT DISTINCT Color
	FROM Production.Product;

/* 结果：10 个值，注意第一个就是 NULL
   NULL, Black, Blue, Grey, Multi, Red, Silver, Silver/Black, White, Yellow

   DISTINCT 会把 NULL 当成一个"值"保留下来 —— 这是第 7 题的伏笔。
*/


-- ========== 6. 名称里带 "Road" 的产品 ==========
SELECT ProductID, Name
	FROM Production.Product
	WHERE Name LIKE '%Road%';

/* 结果：103 行

   % 代表任意多个字符。'%Road%' 是"中间含 Road"，两边都不限制。

   顺手验收：改成小写 '%road%' 再跑一次，还是 103 行 —— 大小写不影响。
   因为本实例排序规则是 Chinese_PRC_CI_AS，CI = Case Insensitive 不区分大小写。
   生产库上如果是 CS 规则，这两句结果就会不一样 ——
   这是排查"明明有数据却查不到"时的高频原因。
*/


-- ========== 7. 没有颜色的产品 ==========
SELECT ProductID, Name, Color
	FROM Production.Product
	WHERE Color IS NULL;

/* 结果：248 行

   ★ 本次最重要的一条。一定要跑一遍对照组：
     WHERE Color = NULL   ->  返回 0 行（永远是 0 行）

   为什么？NULL 不是"空"，是"未知"。
   = NULL 等于问数据库"这个值等于一个未知的东西吗"，
   数据库只能回答"不知道"，而"不知道"不算"是"，所以一行都不返回。
   判断 NULL 只有两种写法：IS NULL / IS NOT NULL。

   业务视角：248 行占 504 行的一半 ——
   这张表里一半的产品没有颜色属性（多半是配件、工具类），
   统计"颜色分布"时必须先决定这些行怎么处理，否则结论会偏。
*/


-- ========== 8. 按颜色统计产品数 ==========
SELECT Color, COUNT(*) AS 产品数
	FROM Production.Product
	GROUP BY Color;

/* 结果：
   NULL         | 248
   Black        |  93
   Silver       |  43
   Red          |  38
   Yellow       |  36
   Blue         |  26
   Multi        |   8
   Silver/Black |   7
   White        |   4
   Grey         |   1

   10 组加起来 = 504，和第 1 题的总行数对得上 —— 这是分组查询的自我校验。

   GROUP BY 把 NULL 当成一个正常的分组值，让它单独成一组，
   而不是把它丢掉。这一点和第 7 题的 IS NULL 是同一件事的两面。
*/


-- ========== 9. 只保留产品数超过 50 的颜色 ==========
SELECT Color, COUNT(*) AS 产品数
	FROM Production.Product
	GROUP BY Color
		HAVING COUNT(*) > 50;

/* 结果：只剩 2 行   NULL | 248 、 Black | 93

   WHERE 过滤【行】，HAVING 过滤【分组】。
   COUNT(*) > 50 这种"分完组才知道的数"只能写在 HAVING 里，
   写在 WHERE 里会直接报错（那时组还没形成）。

   执行顺序：FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

   注意 NULL 组在这里也没被特殊对待，它照样通过了筛选。
   将来做报表时"要不要排除 NULL 组"得自己明确决定，数据库不会替你想。
*/


-- ========== 10. 各颜色的平均标价，从高到低 ==========
SELECT Color, AVG(ListPrice) AS 平均价格
	FROM Production.Product
	GROUP BY Color
	ORDER BY AVG(ListPrice) DESC;

/* 结果：
   Red          | 1401.95
   Yellow       |  959.09
   Blue         |  923.68
   Silver       |  850.31
   Black        |  725.12
   Grey         |  125.00
   Silver/Black |   64.02
   Multi        |   59.87
   NULL         |   16.86
   White        |    9.25

   也可以写成 ORDER BY 平均价格 DESC —— SQL Server 允许在 ORDER BY 里用别名。

   ★ 注意 NULL 那一组是有值的（16.86），不是 NULL。
   因为 AVG 算的是 ListPrice，这一组的 Color 才是 NULL，价格本身有数。
   "分组列是 NULL"和"聚合结果是 NULL"是两回事，别混。

   业务解读：红色平均价 1401.95 是白色的 150 倍，
   高端整车走红/黄/蓝，白/灰/银偏低端 —— 颜色在自行车业务里就是价格分层的标志。
*/

USE AdventureWorks2022;
GO

-- ========== 1. 列筛选 ==========
SELECT ProductID, Name, ListPrice
FROM Production.Product;

-- ========== 2. TOP + ORDER BY ==========
SELECT TOP (10) ProductID, Name, ListPrice
	FROM Production.Product
	ORDER BY ListPrice DESC;

-- ========== 3.标价在 100 到 500 之间的产品 ==========
SELECT ProductID, Name, ListPrice
	FROM Production.Product
	WHERE ListPrice BETWEEN 100 AND 500;

-- ========== 4. 颜色是 Red / Black / White 的产品 ==========
SELECT ProductID, Name, Color
	FROM Production.Product
	WHERE Color IN ('Red', 'Black', 'White');

-- ========== 5. 这张表一共有哪些颜色（去重） ==========
SELECT DISTINCT Color
	FROM Production.Product;

-- ==========6. 名称里带 "Road" 的产品 ==========
SELECT ProductID, Name
	FROM Production.Product
	WHERE Name LIKE '%Road%';

-- ==========7.没有颜色的产品 ==========
SELECT ProductID, Name, Color
	FROM Production.Product
	WHERE Color IS NULL;

-- ==========8. 按颜色统计产品数 ==========
SELECT Color, COUNT(*) AS 产品数
	FROM Production.Product
	GROUP BY Color;

-- ==========9. 只保留产品数超过 50 的颜色 ==========
SELECT Color, COUNT(*) AS 产品数
	FROM Production.Product
	GROUP BY Color
		HAVING COUNT(*) > 50;

-- ==========10. 各颜色的平均标价，从高到低 ==========
SELECT Color, AVG(ListPrice) AS 平均价格
	FROM Production.Product
	GROUP BY Color
	ORDER BY AVG(ListPrice) DESC;
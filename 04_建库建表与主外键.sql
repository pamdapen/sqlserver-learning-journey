/* ============================================================
   04 建库建表与主外键约束
   日期：2026-09-15
   库  ：bank（排序规则 Chinese_PRC_CI_AS）
   来源：《SQL学习指南（第3版）》第 2 章
   改动：书上是 MySQL，本文件已改成 SQL Server 写法
         AUTO_INCREMENT    -> IDENTITY(1,1)
         VARCHAR           -> NVARCHAR（要存中文）
         SMALLINT UNSIGNED -> 去掉 UNSIGNED
   要点：CREATE DATABASE / IDENTITY 自增 / 联合主键 /
         外键约束的两个方向 / sp_rename / ALTER COLUMN

   重跑提示：bank 已存在，直接跑第 1 节会报「数据库已存在」。
            要重建先执行：DROP DATABASE bank;（会删光数据）
   ============================================================ */


-- ---------- 1. 建库 ----------
CREATE DATABASE bank;
GO

USE bank;
GO


-- ---------- 2. person 表：自增主键 ----------
CREATE TABLE person (
    person_id   INT IDENTITY(1,1) NOT NULL,
    fname       NVARCHAR(20),
    lname       NVARCHAR(20),
    gender      CHAR(1),
    birth_date  DATE,
    street      NVARCHAR(50),
    city        NVARCHAR(20),
    state       NVARCHAR(20),
    country     NVARCHAR(20),
    postal_code NVARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);
GO

/* 建表三锚点（不用背整句，记住三个零件就能拼出来）：
     1) 骨架  CREATE TABLE 表名 ( 列 类型, ..., CONSTRAINT 名 PRIMARY KEY (列) );
     2) 自增  INT IDENTITY(1,1) NOT NULL
     3) 外键  CONSTRAINT 名 FOREIGN KEY (本表列) REFERENCES 目标表 (目标列)
   没写 NOT NULL 的列都允许 NULL —— 本表除主键外全部可空。
*/


-- ---------- 3. favorite_food 表：联合主键 + 外键 ----------
CREATE TABLE favorite_food (
    person_id  INT          NOT NULL,
    food       NVARCHAR(20) NOT NULL,
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
        REFERENCES person (person_id)
);
GO

/* 联合主键 = 两列合起来才唯一。
     同一个人可以喜欢多种食物（person_id 允许重复）
     但同一个人不能重复喜欢同一种食物（person_id + food 不能重复）

   外键没写 ON DELETE，默认就是 NO ACTION ——
   主表那行还有人在引用时，不许删。第 5 周会讲 ON DELETE CASCADE。
*/


-- ---------- 4~5. 改名 & 加长列 ----------
-- 4) 列名拼错：gerner -> gender
EXEC sp_rename 'person.gerner', 'gender', 'COLUMN';

-- 5) street 存不下中文地址：VARCHAR(20) -> NVARCHAR(50)
ALTER TABLE person ALTER COLUMN street NVARCHAR(50);

/* 教训：中文一律 NVARCHAR，长度还要留余量。
   VARCHAR 按单字节存，中文会丢字或变成问号 ——
   生产环境里看到满屏 ??? 的老表，基本都是这个原因。
*/


-- ---------- 6. 插入数据 ----------
INSERT INTO person (fname, lname, gender, birth_date, street, city, country)
VALUES ('William', 'Turner', 'M', '1972-05-27', 'Main Street', 'Beijing', 'China');

-- person_id 是自增列，不用也不能手动给值
INSERT INTO favorite_food (person_id, food) VALUES (1, 'pizza');

-- 清理重复 / 收尾（练习结束后已执行，两张表现在都是 0 行）
-- DELETE FROM favorite_food WHERE person_id = 1 AND food = 'pizza';
-- DELETE FROM person        WHERE person_id = 1;   -- 直接删会失败，原因见第 7 节


-- ---------- 7. 实验：外键约束的两个方向 ----------
/* 这两个报错是本次最有价值的收获 ——
   措辞不同，含义完全相反，看错方向就会排查半天。

   ① 往子表插一条主表里不存在的引用
        INSERT INTO favorite_food (person_id, food) VALUES (999, 'noodle');

      消息 547，级别 16：INSERT 语句与 FOREIGN KEY 约束
      "fk_fav_food_person_id" 冲突。该冲突发生于数据库"bank"，
      表"dbo.person", column 'person_id'。

      -> 冲突报在【主表】。含义：你引用的那个 person_id 根本不存在。

   ② 删主表里正被引用的行
        DELETE FROM person WHERE person_id = 1;

      消息 547，级别 16：DELETE 语句与 REFERENCE 约束
      "fk_fav_food_person_id" 冲突。该冲突发生于数据库"bank"，
      表"dbo.favorite_food", column 'person_id'。

      -> 冲突报在【子表】。含义：还有人在引用这行，删不掉。

   记法：报 FOREIGN KEY = "你引用的不存在"（往上看）
         报 REFERENCE   = "还有人在引用它"（往下看）
*/


-- ---------- 附：bank 库里的其它对象 ----------
-- text_table：只有一列 test_id INT NOT NULL（主键 PK_text_table），空表。
--             当时用来试数据类型的草稿表，无业务含义。

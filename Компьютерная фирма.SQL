-- Компьютерная фирма
-- https://sql-ex.ru/help/select13.php#db_1
-- Схема БД состоит из четырех таблиц:

-- Product(maker, model, type)
-- PC(code, model, speed, ram, hd, cd, price)
-- Laptop(code, model, speed, ram, hd, price, screen)
-- Printer(code, model, color, type, price)

-- Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или
-- 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей
-- и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code,
-- указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах),
-- объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства -
-- cd (например, '4x') и цена - price. Таблица Laptop аналогична таблице РС за исключением того,
-- что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера
-- указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser',
-- струйный – 'Jet' или матричный – 'Matrix') и цена - price.


-- Задание: 1 (Serge I: 2002-09-30)
-- https://sql-ex.ru/learn_exercises.php?LN=1
-- Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол.
-- Вывести: model, speed и hd

SELECT model, speed, hd
FROM PC
WHERE price < 500;


-- Задание: 2 (Serge I: 2002-09-21)
-- https://sql-ex.ru/learn_exercises.php?LN=2
-- Найдите производителей принтеров. Вывести: maker

SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer';


-- Задание: 3 (Serge I: 2002-09-30)
-- https://sql-ex.ru/learn_exercises.php?LN=3
-- Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

SELECT model, ram, screen
FROM Laptop
WHERE price > 1000;


-- Задание: 4 (Serge I: 2002-09-21)
-- https://sql-ex.ru/learn_exercises.php?LN=4
-- Найдите все записи таблицы Printer для цветных принтеров.

SELECT *
FROM Printer
WHERE color = 'y';


-- Задание: 5 (Serge I: 2002-09-30)
-- https://sql-ex.ru/learn_exercises.php?LN=5
-- Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.

SELECT model, speed, hd
FROM PC
WHERE CD in ('12x', '24x')
  AND price < 600;


-- Задание: 6 (Serge I: 2002-10-28)
-- https://sql-ex.ru/learn_exercises.php?LN=6
-- Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт,
-- найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

SELECT DISTINCT p.maker, l.speed
FROM Product p
         JOIN Laptop l
              ON p.model = l.model
WHERE hd >= 10;


-- Задание: 7 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=7
-- Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

SELECT X.model, X.price
FROM (
         SELECT pc.model, pc.price
         FROM PC

         UNION

         SELECT l.model, l.price
         FROM Laptop l

         UNION

         SELECT pr.model, pr.price
         FROM Printer pr
     ) AS X

         JOIN product p
              ON p.model = X.model
WHERE maker = 'B';


-- Задание: 8 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=8
-- Найдите производителя, выпускающего ПК, но не ПК-блокноты.

SELECT DISTINCT maker
FROM Product
WHERE type = 'PC'
    EXCEPT
SELECT DISTINCT maker
FROM Product
WHERE type = 'Laptop';


-- Задание: 9 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=9
-- Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

SELECT DISTINCT maker
FROM Product p,
     PC
WHERE p.model = pc.model
  AND speed >= 450;


-- Задание: 10 (Serge I: 2002-09-23)
-- https://sql-ex.ru/learn_exercises.php?LN=10
-- Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

SELECT model, price
FROM printer
WHERE price =
      (SELECT MAX(price) FROM printer);


-- Задание: 11 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=11
-- Найдите среднюю скорость ПК.

SELECT AVG(speed)
FROM PC;


-- Задание: 12 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=12
-- Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

SELECT AVG(Speed)
FROM Laptop
WHERE Price > 1000;


-- Задание: 13 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=13
-- Найдите среднюю скорость ПК, выпущенных производителем A.

SELECT AVG(speed)
FROM PC
         JOIN product
              ON product.model = PC.model AND product.maker = 'A';


-- Задание: 15 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=15
-- Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

SELECT hd
FROM PC
GROUP BY HD
HAVING COUNT(HD) >= 2SELECT p.maker, AVG(l.screen)
FROM Product p, Laptop l
WHERE p.model = l.model
GROUP BY p.maker;


-- Задание: 16 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=16
-- Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз,
-- т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram
FROM PC as pc1,
     PC as pc2
WHERE pc1.speed = pc2.speed
  AND pc1.ram = pc2.ram
  AND pc1.model > pc2.model;


-- Задание: 17 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=17
-- Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
-- Вывести: type, model, speed

SELECT DISTINCT 'Laptop' type, model, speed
FROM Laptop
WHERE speed < (SELECT MIN(speed) FROM PC);


-- Задание: 18 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=18
-- Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price


SELECT DISTINCT pt.maker, pr.price
FROM Product pt
         JOIN Printer pr
              ON pr.model = pt.model
WHERE price = (SELECT MIN(price)
               FROM Printer
               WHERE color = 'y')
  AND color = 'y';


-- Задание: 19 (Serge I: 2003-02-13)
-- https://sql-ex.ru/learn_exercises.php?LN=19
-- Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых
-- им ПК-блокнотов. Вывести: maker, средний размер экрана.

SELECT p.maker, AVG(l.screen)
FROM Product p,
     Laptop l
WHERE p.model = l.model
GROUP BY p.maker;

-- Задание: 20 (Serge I: 2003-02-13)
-- https://sql-ex.ru/learn_exercises.php?LN=20
-- Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

SELECT maker, COUNT(model)
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3;

-- Задание: 21 (Serge I: 2003-02-13)
-- https://sql-ex.ru/learn_exercises.php?LN=21
-- Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
-- Вывести: maker, максимальная цена.

SELECT p.maker, MAX(pc.price)
FROM PC
         JOIN Product p
              ON p.model = pc.model
GROUP BY p.maker;

-- Задание: 22 (Serge I: 2003-02-13)
-- https://sql-ex.ru/learn_exercises.php?LN=22
-- Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью.
-- Вывести: speed, средняя цена.

SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed;


-- Задание: 23 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=23
-- Найдите производителей, которые производили бы как ПК
-- со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
-- Вывести: Maker

SELECT DISTINCT p1.maker
FROM PC
         JOIN Product p1
              ON p1.model = PC.model
WHERE pc.speed >= 750

INTERSECT

SELECT DISTINCT p2.maker
FROM Laptop l
         JOIN Product p2
              ON p2.model = l.model
WHERE l.speed >= 750;


-- Задание: 24 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=24
-- Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

WITH Total AS
         (
             SELECT model, price
             FROM PC

             UNION ALL

             SELECT model, price
             FROM Laptop

             UNION ALL

             SELECT model, price
             FROM Printer
         )

SELECT DISTINCT model
FROM Total
WHERE price = (SELECT MAX(price) from Total);


-- Задание: 25 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=25
-- Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором
-- среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

WITH Low_ram AS
         (SELECT DISTINCT model, speed, ram
          FROM PC
          WHERE ram = (SELECT MIN(ram) FROM PC)
         )

SELECT DISTINCT maker
FROM Product
WHERE model in
      (SELECT model
       FROM Low_ram
       WHERE speed = (SELECT MAX(Speed) from Low_ram))
  AND maker IN (SELECT maker FROM Product where type = 'Printer');


-- Задание: 26 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=26
-- Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква).
-- Вывести: одна общая средняя цена.

SELECT AVG(price)
FROM (
         SELECT model, price
         FROM PC

         UNION ALL

         SELECT model, price
         FROM Laptop
     ) AS PCL
         JOIN product AS p
              ON PCL.model = p.model
WHERE maker = 'A';


-- Задание: 27 (Serge I: 2003-02-03)
-- https://sql-ex.ru/learn_exercises.php?LN=27
-- Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры.
-- Вывести: maker, средний размер HD.

SELECT maker, AVG(hd)
FROM Product p
         JOIN PC
              ON pc.model = p.model
WHERE p.maker in (SELECT maker FROM Product WHERE Type = 'printer')
GROUP BY maker


-- Задание: 28 (Serge I: 2012-05-04)
-- Используя таблицу Product, определить количество производителей, выпускающих по одной модели.

SELECT COUNT(*)
FROM (SELECT maker
      FROM Product
      GROUP BY maker
      HAVING COUNT(model) = 1) z

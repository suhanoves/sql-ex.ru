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
WHERE maker = 'B'




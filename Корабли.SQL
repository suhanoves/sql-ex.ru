-- Корабли
-- https://sql-ex.ru/help/select13.php#db_3
-- Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:

-- Classes (class, type, country, numGuns, bore, displacement)
-- Ships (name, class, launched)
-- Battles (name, date)
-- Outcomes (ship, battle, result)

-- Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля,
-- построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей
-- в БД. Корабль, давший название классу, называется головным.
-- Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера),
-- страну, в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах)
-- и водоизмещение ( вес в тоннах). В отношении Ships записаны название корабля, имя его класса и год спуска на воду.
-- В отношение Battles включены название и дата битвы, в которой участвовали корабли, а в отношении Outcomes –
-- результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged или невредим - OK).
-- Замечания. 1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships.
-- 2) Потопленный корабль в последующих битвах участия не принимает.


-- Задание: 14 (Serge I: 2002-11-05)
-- https://sql-ex.ru/learn_exercises.php?LN=14
-- Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

SELECT s.class, s.name, c.country
FROM Ships s
         JOIN Classes c
              ON s.class = c.class
WHERE c.numGuns >= 10;


-- Задание: 31 (Serge I: 2002-10-22)
-- https://sql-ex.ru/learn_exercises.php?LN=31
-- Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.

SELECT class, country
FROM classes
WHERE bore >= 16;


-- Задание: 32 (Serge I: 2003-02-17)
-- https://sql-ex.ru/learn_exercises.php?LN=32
-- Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью
-- до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны,
-- у которой есть корабли в базе данных.

SELECT country, CAST(AVG(mw) AS NUMERIC(6, 2)) as mw
FROM (
         SELECT c.country, ship, POWER(bore, 3) / 2 as mw
         FROM Outcomes O
                  JOIN Classes c ON o.ship = c.class

         UNION

         SELECT c.country, name, POWER(bore, 3) / 2 as mw
         FROM ships s
                  JOIN Classes c ON c.class = s.class
     ) AllShips
GROUP BY country;


-- Задание: 33 (Serge I: 2002-11-02)
-- https://sql-ex.ru/learn_exercises.php?LN=33
-- Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

SELECT ship
FROM Outcomes
WHERE result = 'sunk'
  AND battle = 'North Atlantic';


-- Задание: 34 (Serge I: 2002-11-04)
-- https://sql-ex.ru/learn_exercises.php?LN=34
-- По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением
-- более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом
-- спуска на воду). Вывести названия кораблей.

SELECT name
FROM Ships s
         JOIN Classes c
              ON c.class = s.class
WHERE s.launched > 1921
  AND c.displacement > 35000
  AND type = 'bb';


-- Задание: 36 (Serge I: 2003-02-17)
-- https://sql-ex.ru/learn_exercises.php?LN=36
-- Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).

SELECT class
FROM classes
WHERE class IN (SELECT name FROM ships)
   OR class IN (SELECT ship FROM outcomes);


-- Задание: 37 (Serge I: 2003-02-17)
-- https://sql-ex.ru/learn_exercises.php#answer_ref
-- Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).

SELECT class
FROM (
         SELECT ship as name, class
         FROM Outcomes,
              Classes
         WHERE ship = class
         UNION
         SELECT name, class
         FROM Ships
     ) t
Group by class
HAVING count(*) = 1;


-- Задание: 38 (Serge I: 2003-02-19)
-- https://sql-ex.ru/learn_exercises.php?LN=38
-- Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb')
-- и имевшие когда-либо классы крейсеров ('bc').

SELECT DISTINCT country
FROM Classes
WHERE type = 'bb'

INTERSECT

SELECT DISTINCT country
FROM Classes
WHERE type = 'bc';


-- Задание: 39 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=39
-- Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged),
-- они участвовали в другой, произошедшей позже.

WITH T AS
         (SELECT *
          FROM Outcomes o
                   JOIN Battles b
                        ON b.name = o.battle)

SELECT DISTINCT ship
FROM T
WHERE EXISTS(
              SELECT ship
              FROM T as Tdam
              WHERE T.ship = Tdam.ship
                AND T.date > Tdam.date
                AND Tdam.result = 'damaged');


-- Задание: 42 (Serge I: 2002-11-05)
-- https://sql-ex.ru/learn_exercises.php?LN=42
-- Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.

SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk';


-- Задание: 43 (qwrqwr: 2011-10-28)
-- https://sql-ex.ru/learn_exercises.php?LN=43
-- Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

SELECT DISTINCT name AS battle
FROM battles
WHERE YEAR(date) NOT IN
      (SELECT launched
       FROM ships
       WHERE launched IS NOT NULL);


-- Задание: 44 (Serge I: 2002-12-04)
-- https://sql-ex.ru/learn_exercises.php?LN=44
-- Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

SELECT a.name
FROM (
         SELECT name
         FROM Ships
         UNION
         SELECT ship as name
         FROM Outcomes
     ) a
WHERE a.name LIKE 'R%';


-- Задание: 45 (Serge I: 2002-12-04)
-- https://sql-ex.ru/learn_exercises.php?LN=45
-- Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
-- Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

SELECT name
FROM Ships
WHERE name like '% % %'

UNION

SELECT ship
FROM Outcomes
WHERE ship like '% % %';


-- Задание: 46 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=47
-- Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal)
-- Вывести название, водоизмещение и число орудий.

SELECT O.ship, C.displacement, C.numGuns
FROM Outcomes O
         LEFT JOIN Ships S
                   ON O.ship = S.name
         LEFT JOIN Classes C
                   ON C.class = COALESCE(S.class, O.ship)
WHERE battle = 'Guadalcanal';


-- Задание: 47 (Serge I: 2019-06-07)
-- https://sql-ex.ru/learn_exercises.php?LN=47
-- Определить страны, которые потеряли в сражениях все свои корабли.


-- Задание: 48 (Serge I: 2003-02-16)
-- https://sql-ex.ru/learn_exercises.php?LN=48
-- Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.

SELECT DISTINCT COALESCE(s.class, ship) as class
FROM outcomes o
         LEFT JOIN ships s ON o.ship = s.name
         INNER JOIN classes c ON c.class = COALESCE(s.class, ship)
WHERE o.result = 'sunk';


-- Задание: 49 (Serge I: 2003-02-17)
-- https://sql-ex.ru/learn_exercises.php?LN=49
-- Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).

SELECT DISTINCT COALESCE(s.name, o.ship) as name
FROM Ships S
         FULL JOIN Outcomes O
                   ON S.name = O.ship
         LEFT JOIN Classes C
                   ON C.class = COALESCE(S.class, O.ship)
WHERE C.bore = 16;


-- Задание: 50 (Serge I: 2002-11-05)
-- https://sql-ex.ru/learn_exercises.php?LN=50
-- Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

SELECT DISTINCT battle
FROM Outcomes O
         LEFT JOIN Ships S
                   ON O.ship = S.name
WHERE COALESCE(S.class, O.ship) = 'Kongo';

    -- Задание: 51 (Serge I: 2003-02-17)
-- https://sql-ex.ru/learn_exercises.php?LN=51
-- Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения
-- (учесть корабли из таблицы Outcomes).

WITH T AS
         (SELECT S.name, S.class
          FROM Ships S
          UNION
          SELECT O.ship, O.ship
          FROM Outcomes O
          WHERE O.ship NOT IN (SELECT name FROM Ships)),

     X AS (
         SELECT name, T.class, numGuns, displacement
         FROM T
                  JOIN Classes C
                       ON T.class = C.class),

     Y AS (
         SELECT displacement, MAX(numGuns) numGuns
         FROM X
         GROUP BY displacement)

SELECT X.name
FROM X,
     Y
WHERE X.displacement = Y.displacement
  AND X.numGuns = Y.numGuns



-- Задание: 52 (qwrqwr: 2010-04-23)
-- https://sql-ex.ru/learn_exercises.php?LN=52
-- Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
-- имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

SELECT S.name
FROM Ships S
         JOIN Classes C ON S.class = C.class
WHERE country = 'Japan'
  AND type = 'bb'
  AND Coalesce(numGuns, 9) > = 9
  AND Coalesce(bore, 0.0) < 19.0
  AND Coalesce(displacement, 0) <= 65000;


-- Задание: 53 (Serge I: 2002-11-05)
-- https://sql-ex.ru/learn_exercises.php?LN=53
-- Определите среднее число орудий для классов линейных кораблей.
-- Получить результат с точностью до 2-х десятичных знаков.

SELECT CAST(AVG(numGuns * 1.0) AS NUMERIC(6, 2)) as numGuns
FROM Classes
WHERE TYPE = 'bb';

-- Задание: 54 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=53
-- С точностью до 2-х десятичных знаков определите среднее число орудий всех линейных кораблей
-- (учесть корабли из таблицы Outcomes).

WITH T AS
         (SELECT DISTINCT COALESCE(S.name, O.ship)  Name,
                          COALESCE(S.class, O.ship) Class,
                          NumGuns
          FROM Ships S
                   FULL JOIN Outcomes O
                             ON S.name = O.ship
                   JOIN Classes C
                        ON C.class = COALESCE(S.class, O.ship)
          WHERE type = 'bb')

SELECT CAST(AVG(NumGuns * 1.0) AS NUMERIC(6, 2))
FROM T


-- Задание: 55 (Serge I: 2003-02-16)
-- https://sql-ex.ru/learn_exercises.php?LN=55
-- Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду
-- головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

SELECT C.class, MIN(S.launched)
FROM Classes C
         LEFT JOIN Ships S
                   ON S.class = C.class
GROUP BY C.class;

-- Задание: 56 (Serge I: 2003-02-16)
-- Для каждого класса определите число кораблей этого класса, потопленных в сражениях.
-- Вывести: класс и число потопленных кораблей.

WITH T AS
         (SELECT DISTINCT COALESCE(S.class, O.ship) class,
                          count(result)             result
          FROM Outcomes O
                   LEFT JOIN Ships S
                             ON S.name = O.ship
          WHERE result = 'sunk'
          GROUP BY COALESCE(S.class, O.ship)
         )

SELECT DISTINCT C.class, COALESCE(T.result, 0)
FROM Classes C
         LEFT JOIN T
                   ON T.class = C.class;

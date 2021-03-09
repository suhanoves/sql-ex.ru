-- Фирма вторсырья
-- https://sql-ex.ru/help/select13.php#db_2
-- Фирма имеет несколько пунктов приема вторсырья. Каждый пункт получает деньги для их выдачи сдатчикам вторсырья.
-- Сведения о получении денег на пунктах приема записываются в таблицу: Income_o(point, date, inc)
-- Первичным ключом является (point, date). При этом в столбец date записывается только дата (без времени),
-- т.е. прием денег (inc) на каждом пункте производится не чаще одного раза в день.

-- Сведения о выдаче денег сдатчикам вторсырья записываются в таблицу: Outcome_o(point, date, out)
-- В этой таблице также первичный ключ (point, date) гарантирует отчетность каждого пункта о выданных деньгах (out)
-- не чаще одного раза в день. В случае, когда приход и расход денег может фиксироваться несколько раз в день,
-- используется другая схема с таблицами, имеющими первичный ключ code:
-- Income(code, point, date, inc)
-- Outcome(code, point, date, out)
-- Здесь также значения столбца date не содержат времени.


-- Задание: 29 (Serge I: 2003-02-14)
-- https://sql-ex.ru/learn_exercises.php?LN=29
-- В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день
-- [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход).
-- Использовать таблицы Income_o и Outcome_o.

SELECT
       COALESCE(i.point, o.point) point,
       COALESCE(i.date, o.date) date,
       i.inc inc,
       o.out out
FROM income_o i
FULL JOIN outcome_o o
    ON o.date = i.date
    AND i.point = o.point
ORDER BY point

-- Задание: 30 (Serge I: 2003-02-14)
-- В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз
-- (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту
-- за каждую дату выполнения операций будет соответствовать одна строка.
-- Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc).
-- Отсутствующие значения считать неопределенными (NULL).

WITH
pivot_income AS (
    SELECT point, date, SUM(inc) inc
    FROM Income
    GROUP BY point, date
    ),

pivot_outcome AS (
    SELECT point, date, SUM(out) out
    FROM Outcome
    GROUP BY point, date
    )

SELECT
    COALESCE(pi.point, po.point),
    COALESCE(pi.date, po.date),
    out,
    inc
FROM pivot_income pi
FULL JOIN pivot_outcome po
    ON pi.point = po.point
    AND pi.date = po.date


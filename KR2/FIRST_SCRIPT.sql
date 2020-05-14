
--1.Изведете данните за всички работници продавачи(с название на работата ‘ST_CLERK’), които са постъпили на работа след 2003.

SELECT * FROM EMPLOYEES
WHERE JOB_ID='ST_CLERK' AND HIRE_DATE LIKE '2003%';

--2.Изведете фамилия, название на работата, заплата и комисиона на тези работници, които печелят комисиона. Сортирайте данните по възходящ ред на комисионата.

SELECT 
    LAST_NAME ,
    JOB_ID ,
    SALARY ,
    COMMISSION_PCT
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL 
ORDER BY COMMISSION_PCT ASC;

--3.Изведете фамилиите и новата заплата само на тези работници, които нямат комисиона, но ще имат 10% увеличение на заплатата (закръглете новата заплата).

SELECT 
    LAST_NAME ,
    SALARY,
    ROUND(SALARY * 1.1) AS NEW_SALARY
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NULL;

--4.Изведете по отдели: фамилия, броя на годините и броя на завършените месеци на работа на работниците, подредени по низходящ ред на стажа (години, месеци) за работници с години стаж по-голям от 6 години.

SELECT 
    LAST_NAME,
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) AS WORK_YEARS,
    TRUNC(MOD(MONTHS_BETWEEN(SYSDATE,HIRE_DATE), 12)) AS WORK_MONTHS
FROM EMPLOYEES
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) > 6
ORDER BY 
    DEPARTMENT_ID ASC, 
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) DESC;

--5.Изведете фамилиите на тези работници, които имат съчетание ‘in’или ‘an’ във фамилията си.

SELECT LAST_NAME 
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%in%' OR LAST_NAME LIKE '%an%';

--6.Изведете фамилиите, заплатите на всички работници, които имат комисиона и определете с GOOD или BAD дали получават комисионна по-голяма от 0.2 или по-малка от 0.2. 

SELECT 
    LAST_NAME,
    SALARY,
    COMMISSION_PCT,
    CASE
        WHEN (COMMISSION_PCT > 0.2) THEN 'GOOD'
        ELSE 'BAD'
    END AS SALARY_TYPE
FROM EMPLOYEES
WHERE
    COMMISSION_PCT IS NOT NULL;

--7.Изведете всички работници, които не са постъпили в понеделник. 

SELECT *  FROM EMPLOYEES
WHERE 
    (SELECT TO_CHAR(HIRE_DATE, 'DAY') FROM DUAL) <> 'MONDAY' AND 
    (SELECT TO_CHAR(HIRE_DATE, 'DAY') FROM DUAL) <> 'ПОНЕДЕЛНИК';

--8.Изведете име на отдела, ID на локацията, фамилия, название на работата и заплатата на тези работници, които имат определено название на работата. Напомнете на потребителя за въвеждане на названието на работата.

SELECT 
    D.DEPARTMENT_NAME,
    D.LOCATION_ID,
    E.LAST_NAME, 
    J.JOB_TITLE,
    E.SALARY
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
WHERE UPPER(J.JOB_TITLE) like UPPER('%&JOB_NAME%');
-- ползвам LIKE, за да може да се изпълни търсене по непълно название и UPPER, за да е case insensitive

UNDEFINE JOB_NAME;

--9.Изведете броя на работниците, коити имат название на работата, завършващо с ‘REP’.

SELECT COUNT(*) AS EMP_COUNT FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP';

--10.Изведете ID на локацията, града  и броя на отделите за всяка локация. //ASK

SELECT 
    L.LOCATION_ID, 
    L.CITY,
    COUNT(D.DEPARTMENT_NAME) AS DEPT_COUNT
FROM LOCATIONS L
JOIN DEPARTMENTS D
-- ако искаме да показва и градовете с 0 отдела трябва да направим LEFT JOIN
-- LEFT JOIN DEPARTMENTS D
    ON L.LOCATION_ID = D.LOCATION_ID
GROUP BY 
    L.LOCATION_ID, 
    L.CITY;
    
--11.Изведете имената на отделите и градовете за локации 1400 и 1500 в низходящ ред. //ASK

SELECT 
    D.DEPARTMENT_NAME,
    L.CITY
FROM DEPARTMENTS D
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
WHERE D.LOCATION_ID BETWEEN 1400 AND 1500
ORDER BY D.DEPARTMENT_NAME DESC;

--12.Изведете отделите, в които няма работа за ‘MK_MAN’. Включете номер, име и локацията на отдела.

SELECT DISTINCT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.JOB_ID <> 'MK_MAN';

--13.Изведете названията на работите, които са намерени в отделите Marketing и Shipping. Покажете средната заплата за всяка работа. Първо да бъде показана работата с най - голяма ср. заплата. //ORDER

SELECT
    J.JOB_TITLE, 
    ROUND(AVG(E.SALARY), 2) AS AVERAGE_SALARY 
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
WHERE D.DEPARTMENT_NAME = 'Marketing' OR D.DEPARTMENT_NAME = 'Shipping'
GROUP BY J.JOB_ID, J.JOB_TITLE
ORDER BY AVERAGE_SALARY DESC;

--14.Изведете фамилиите и датата на постъпване на работа на всички работници, които са постъпили в последните шест месеца от годината и във втората половина на месеца.

SELECT 
    LAST_NAME,
    HIRE_DATE
FROM EMPLOYEES
WHERE 
    TO_CHAR(HIRE_DATE, 'MM') > 6 AND  
    TO_CHAR(HIRE_DATE, 'DD') > 15;

--15.Изведете номер и име на регион и брой страни в гегиона.
/*
SELECT 
    R.REGION_ID, 
    R.REGION_NAME,
    (
    SELECT COUNT(*) FROM COUNTRIES C 
    WHERE C.REGION_ID = R.REGION_ID
    ) AS COUNTRIES_COUNT
FROM REGIONS R;
*/
-- виждам два начина за осъществяване на тази задача, затова ще разпиша и двата

SELECT 
    R.REGION_ID, 
    R.REGION_NAME,
    COUNT(C.COUNTRY_NAME) AS COUNTRIES_COUNT
FROM REGIONS R
JOIN COUNTRIES C
    ON R.REGION_ID = C.REGION_ID
GROUP BY 
    R.REGION_ID, 
    R.REGION_NAME;

--16.Изведете всички работници, които имат менажери със заплата между 12000 и 13000 включително. 
-- Покажете следните данни: фамилия на работника, фамилия на менажера, заплата на менажера и категорията на менажера (grade_level),
-- която се определя в зависимост от това в кой диапазон се намира заплатата му (между lowest_sal и highest_sal).
/*
CREATE TABLE JOB_GRADES 
(
  GRADE_LEVEL VARCHAR2(3),
  LOWEST_SAL NUMBER,
  HIGHEST_SAL NUMBER 
);

INSERT ALL
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('A', 1000, 2999)
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('B', 3000, 5999)
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('C', 6000, 9999)
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('D', 10000, 14999)
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('E', 15000, 24999)
    INTO JOB_GRADES (GRADE_LEVEL, LOWEST_SAL, HIGHEST_SAL) VALUES ('F', 25000, 40000)
SELECT * FROM dual;
*/
SELECT
    W.LAST_NAME AS EMP_LAST_NAME, 
    W.MANAGER_ID AS MAN_ID,
    M.LAST_NAME AS MAN_LAST_NAME, 
    M.SALARY AS MAN_SALARY,
    J_G.GRADE_LEVEL
FROM EMPLOYEES W
JOIN EMPLOYEES M
    ON W.MANAGER_ID = M.EMPLOYEE_ID
JOIN JOB_GRADES J_G
    ON (M.SALARY BETWEEN J_G.LOWEST_SAL AND J_G.HIGHEST_SAL)
WHERE 
    M.SALARY BETWEEN 12000 AND 13000;

--17.Изведете номера на отдел и средната заплата на отдела с най-ниска заплата.

SELECT
    D.DEPARTMENT_ID,
    ROUND(AVG(E.SALARY), 2) AS AVERAGE_SALARY
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID
HAVING MIN(E.SALARY) = (SELECT MIN(SALARY) FROM EMPLOYEES);

--18.Изведете номер, фамилия, заплата на работник, номер на отдел и минималната заплата за отдела за всички работници.

SELECT 
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    E.SALARY,
    E_MIN.DEPARTMENT_ID,
    MIN(E_MIN.SALARY) AS MIN_DEPT_SAL
FROM EMPLOYEES E
JOIN EMPLOYEES E_MIN
    ON E.DEPARTMENT_ID = E_MIN.DEPARTMENT_ID
GROUP BY 
    E_MIN.DEPARTMENT_ID,
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    E.SALARY;
    
--19.Изведете номер, име на отдел и броя на работниците, работещи във всеки отдел, които:

--a)е наел между 3 и 7 работника;

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(*) AS WORKERS_COUNT
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) BETWEEN 3 AND 7;

--b)е наел работници повече от отдела с най-малък брой работници;

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(*) AS WORKERS_COUNT
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) > (SELECT MIN(COUNT(*)) FROM EMPLOYEES GROUP BY DEPARTMENT_ID);


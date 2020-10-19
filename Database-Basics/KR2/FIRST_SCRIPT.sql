
--1.�������� ������� �� ������ ��������� ���������(� �������� �� �������� �ST_CLERK�), ����� �� ��������� �� ������ ���� 2003.

SELECT * FROM EMPLOYEES
WHERE JOB_ID='ST_CLERK' AND HIRE_DATE LIKE '2003%';

--2.�������� �������, �������� �� ��������, ������� � ��������� �� ���� ���������, ����� ������� ���������. ���������� ������� �� �������� ��� �� �����������.

SELECT 
    LAST_NAME ,
    JOB_ID ,
    SALARY ,
    COMMISSION_PCT
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL 
ORDER BY COMMISSION_PCT ASC;

--3.�������� ��������� � ������ ������� ���� �� ���� ���������, ����� ����� ���������, �� �� ���� 10% ���������� �� ��������� (���������� ������ �������).

SELECT 
    LAST_NAME ,
    SALARY,
    ROUND(SALARY * 1.1) AS NEW_SALARY
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NULL;

--4.�������� �� ������: �������, ���� �� �������� � ���� �� ����������� ������ �� ������ �� �����������, ��������� �� �������� ��� �� ����� (������, ������) �� ��������� � ������ ���� ��-����� �� 6 ������.

SELECT 
    LAST_NAME,
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) AS WORK_YEARS,
    TRUNC(MOD(MONTHS_BETWEEN(SYSDATE,HIRE_DATE), 12)) AS WORK_MONTHS
FROM EMPLOYEES
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) > 6
ORDER BY 
    DEPARTMENT_ID ASC, 
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE) / 12) DESC;

--5.�������� ��������� �� ���� ���������, ����� ���� ��������� �in���� �an� ��� ��������� ��.

SELECT LAST_NAME 
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%in%' OR LAST_NAME LIKE '%an%';

--6.�������� ���������, ��������� �� ������ ���������, ����� ���� ��������� � ���������� � GOOD ��� BAD ���� ��������� ���������� ��-������ �� 0.2 ��� ��-����� �� 0.2. 

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

--7.�������� ������ ���������, ����� �� �� ��������� � ����������. 

SELECT *  FROM EMPLOYEES
WHERE 
    (SELECT TO_CHAR(HIRE_DATE, 'DAY') FROM DUAL) <> 'MONDAY' AND 
    (SELECT TO_CHAR(HIRE_DATE, 'DAY') FROM DUAL) <> '����������';

--8.�������� ��� �� ������, ID �� ���������, �������, �������� �� �������� � ��������� �� ���� ���������, ����� ���� ���������� �������� �� ��������. ��������� �� ����������� �� ��������� �� ���������� �� ��������.

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
-- ������� LIKE, �� �� ���� �� �� ������� ������� �� ������� �������� � UPPER, �� �� � case insensitive

UNDEFINE JOB_NAME;

--9.�������� ���� �� �����������, ����� ���� �������� �� ��������, ���������� � �REP�.

SELECT COUNT(*) AS EMP_COUNT FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP';

--10.�������� ID �� ���������, �����  � ���� �� �������� �� ����� �������. //ASK

SELECT 
    L.LOCATION_ID, 
    L.CITY,
    COUNT(D.DEPARTMENT_NAME) AS DEPT_COUNT
FROM LOCATIONS L
JOIN DEPARTMENTS D
-- ��� ������ �� ������� � ��������� � 0 ������ ������ �� �������� LEFT JOIN
-- LEFT JOIN DEPARTMENTS D
    ON L.LOCATION_ID = D.LOCATION_ID
GROUP BY 
    L.LOCATION_ID, 
    L.CITY;
    
--11.�������� ������� �� �������� � ��������� �� ������� 1400 � 1500 � �������� ���. //ASK

SELECT 
    D.DEPARTMENT_NAME,
    L.CITY
FROM DEPARTMENTS D
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
WHERE D.LOCATION_ID BETWEEN 1400 AND 1500
ORDER BY D.DEPARTMENT_NAME DESC;

--12.�������� ��������, � ����� ���� ������ �� �MK_MAN�. �������� �����, ��� � ��������� �� ������.

SELECT DISTINCT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.JOB_ID <> 'MK_MAN';

--13.�������� ���������� �� ��������, ����� �� �������� � �������� Marketing � Shipping. �������� �������� ������� �� ����� ������. ����� �� ���� �������� �������� � ��� - ������ ��. �������. //ORDER

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

--14.�������� ��������� � ������ �� ���������� �� ������ �� ������ ���������, ����� �� ��������� � ���������� ���� ������ �� �������� � ��� ������� �������� �� ������.

SELECT 
    LAST_NAME,
    HIRE_DATE
FROM EMPLOYEES
WHERE 
    TO_CHAR(HIRE_DATE, 'MM') > 6 AND  
    TO_CHAR(HIRE_DATE, 'DD') > 15;

--15.�������� ����� � ��� �� ������ � ���� ������ � �������.
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
-- ������ ��� ������ �� ������������� �� ���� ������, ������ �� ������� � �����

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

--16.�������� ������ ���������, ����� ���� �������� ��� ������� ����� 12000 � 13000 �����������. 
-- �������� �������� �����: ������� �� ���������, ������� �� ��������, ������� �� �������� � ����������� �� �������� (grade_level),
-- ����� �� �������� � ���������� �� ���� � ��� �������� �� ������ ��������� �� (����� lowest_sal � highest_sal).
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

--17.�������� ������ �� ����� � �������� ������� �� ������ � ���-����� �������.

SELECT
    D.DEPARTMENT_ID,
    ROUND(AVG(E.SALARY), 2) AS AVERAGE_SALARY
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID
HAVING MIN(E.SALARY) = (SELECT MIN(SALARY) FROM EMPLOYEES);

--18.�������� �����, �������, ������� �� ��������, ����� �� ����� � ����������� ������� �� ������ �� ������ ���������.

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
    
--19.�������� �����, ��� �� ����� � ���� �� �����������, �������� ��� ����� �����, �����:

--a)� ���� ����� 3 � 7 ���������;

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(*) AS WORKERS_COUNT
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) BETWEEN 3 AND 7;

--b)� ���� ��������� ������ �� ������ � ���-����� ���� ���������;

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(*) AS WORKERS_COUNT
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) > (SELECT MIN(COUNT(*)) FROM EMPLOYEES GROUP BY DEPARTMENT_ID);


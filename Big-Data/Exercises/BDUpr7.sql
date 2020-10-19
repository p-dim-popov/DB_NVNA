SET SERVEROUTPUT ON;
----------------
SET verify OFF;
----------------
SET echo off;
----------------
DECLARE
    v_deptno NUMBER := 10;
    CURSOR c_emp_cursor IS
        SELECT last_name, salary, manager_id
        FROM employees
        WHERE department_id = v_deptno;

BEGIN
    FOR emp_record IN c_emp_cursor
        LOOP
            IF emp_record.salary < 5000 AND (emp_record.manager_id = 101 OR emp_record.manager_id = 124) THEN
                DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Due for a raise');
            ELSE
                DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Not Due for a raise');
            END IF;
        END LOOP;
END;

-------------------------------
DECLARE
    CURSOR c_dept_cursor IS
        SELECT department_id, department_name
        FROM departments
        WHERE department_id < 100
        ORDER BY department_id;
    CURSOR c_emp_cursor(v_deptno NUMBER ) IS
        SELECT last_name, job_id, hire_date, salary
        FROM employees
        WHERE department_id = v_deptno
          AND employee_id < 120;
    v_current_deptno departments.department_id%TYPE;
    v_current_dname  departments.department_name%TYPE;
    v_ename          employees.last_name%TYPE;
    v_job            employees.job_id%TYPE;
    v_hiredate       employees.hire_date%TYPE;
    v_sal            employees.salary%TYPE;

BEGIN
    OPEN c_dept_cursor;
    LOOP
        FETCH c_dept_cursor INTO v_current_deptno, v_current_dname;
        EXIT WHEN c_dept_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Department Number : ' || v_current_deptno ||
                             '  Department Name : ' || v_current_dname);
        IF c_emp_cursor%ISOPEN THEN
            CLOSE c_emp_cursor;
        END IF;
        OPEN c_emp_cursor(v_current_deptno);
        LOOP
            FETCH c_emp_cursor INTO v_ename, v_job,v_hiredate,v_sal;
            EXIT WHEN c_emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_ename || '    ' || v_job || '   ' || v_hiredate || '   ' || v_sal);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(
                '----------------------------------------------------------------------------------------');
        CLOSE c_emp_cursor;
    END LOOP;

    CLOSE c_dept_cursor;
END;
----------------------
SET VERIFY OFF
---
DELETE
FROM top_salaries
WHERE 1 = 1;
-- Изтрива записи от таблицата, ако я има
---
CREATE TABLE top_salaries
(
    salary NUMBER(8, 2)
);
-- Създава таблица, ако я няма
--------------------------
DECLARE
    v_num NUMBER(3) := 5;
    v_sal employees.salary%TYPE;
    CURSOR c_emp_cursor IS
        SELECT salary
        FROM employees
        ORDER BY salary DESC;

BEGIN
    OPEN c_emp_cursor;
    FETCH c_emp_cursor INTO v_sal;
    WHILE c_emp_cursor%ROWCOUNT <= v_num AND c_emp_cursor%FOUND
        LOOP
            INSERT INTO top_salaries (salary) VALUES (v_sal);
            FETCH c_emp_cursor INTO v_sal;
        END LOOP;
    CLOSE c_emp_cursor;
END;
---

SELECT *
FROM top_salaries;
---------------------------------
-- DROP TABLE emp;   -- Изтрива таблицата, ако я има
CREATE TABLE emp AS
SELECT *
FROM EMPLOYEES;

-- PL/SQL код, който за служители с длъжност 'ST_CLERK' и със заплата
-- по-голяма от 3000 променя длъжността им на 'SR_CLERK' и повишава
-- заплатата им с 10%. Проверете резултатите в таблица emp.
-- Използва се курсор с FOR UPDATE и клаузата CURRENT OF за обновяването.

DECLARE

    CURSOR C_Senior_Clerk IS
        SELECT employee_id, job_id
        FROM emp
        WHERE job_id = 'ST_CLERK'
          AND salary > 3000
            FOR UPDATE OF job_id;

BEGIN
    FOR discard_rec IN C_Senior_Clerk
        LOOP
            UPDATE emp
            SET job_id = 'SR_CLERK',
                salary = 1.1 * salary
            WHERE CURRENT OF C_Senior_Clerk;
        END LOOP;
    COMMIT;
END;
---

SELECT *
FROM emp;
----------------------------------
--Примери от теорията:

DECLARE

    CURSOR c_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 30;
    v_empno employees.employee_id%TYPE;
    v_lname employees.last_name%TYPE;

BEGIN
    OPEN c_emp_cursor;
    FETCH c_emp_cursor INTO v_empno, v_lname;
    DBMS_OUTPUT.PUT_LINE(v_empno || '  ' || v_lname);
END;

-----------------------------
DECLARE

    CURSOR c_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 30;
    v_empno employees.employee_id%TYPE;
    v_lname employees.last_name%TYPE;

BEGIN
    OPEN c_emp_cursor;
    LOOP
        FETCH c_emp_cursor INTO v_empno, v_lname;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empno || '  ' || v_lname);
    END LOOP;
END;

-------------------------------
DECLARE

    CURSOR c_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 30;
    v_emp_record c_emp_cursor%ROWTYPE;

BEGIN
    OPEN c_emp_cursor;
    LOOP
        FETCH c_emp_cursor INTO v_emp_record;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp_record.employee_id || ' ' || v_emp_record.last_name);
    END LOOP;
    CLOSE c_emp_cursor;
END;

------------------------------
DECLARE
    CURSOR c_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = 30;

BEGIN
    FOR emp_record IN c_emp_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE(emp_record.employee_id || ' ' || emp_record.last_name);
        END LOOP;
END;

-----------------------------
DECLARE

    CURSOR c_emp_cursor IS SELECT employee_id,
                                  last_name
                           FROM employees;
    v_emp_record c_emp_cursor%ROWTYPE;

BEGIN
    OPEN c_emp_cursor;
    LOOP
        FETCH c_emp_cursor INTO v_emp_record;
        EXIT WHEN c_emp_cursor%ROWCOUNT > 10 OR c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp_record.employee_id || ' ' || v_emp_record.last_name);
    END LOOP;
    CLOSE c_emp_cursor;
END ;

---------------------------
BEGIN
    FOR emp_record IN (SELECT employee_id, last_name
                       FROM employees
                       WHERE department_id = 30)
        LOOP
            DBMS_OUTPUT.PUT_LINE(emp_record.employee_id || ' ' || emp_record.last_name);
        END LOOP;
END;

---------------------------
DECLARE
    CURSOR c_emp_cursor (deptno NUMBER) IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = deptno;
    v_empno employees.employee_id%TYPE;
    v_lname employees.last_name%TYPE;

BEGIN
    OPEN c_emp_cursor(10);
    LOOP
        FETCH c_emp_cursor INTO v_empno, v_lname;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_lname);
    END LOOP;
    CLOSE c_emp_cursor;
    OPEN c_emp_cursor(20);
    LOOP
        FETCH c_emp_cursor INTO v_empno, v_lname;
        EXIT WHEN c_emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empno || ' ' || v_lname);
    END LOOP;
END;

-----------------------------------------------------
-- Зад. 1. Създайте PL/SQL блок с декларация на курсор, с име C_DATE_CUR, полета –
-- номер, фамилия и дата на постъпване; както и параметър на курсора от даннов тип DATE.
-- Изведете информация за всички служители, които са постъпили на работа след определена дата,
-- въведена от клавиатурата. Тествайте с дати 2007-01-01, 2008-02-03.

DECLARE
    CURSOR c_date_cur(var_date DATE) IS
        SELECT EMPLOYEE_ID, LAST_NAME, HIRE_DATE
        FROM EMPLOYEES
        WHERE HIRE_DATE > var_date;
    var_record c_date_cur%ROWTYPE;
    var_date   DATE := TO_DATE(&date, 'YYYY-MM-DD');
BEGIN
    DBMS_OUTPUT.PUT_LINE('hire_date > ' || var_date);
    OPEN c_date_cur(var_date);
    LOOP
        FETCH c_date_cur INTO var_record;
        EXIT WHEN c_date_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
                    'emp_id: ' || var_record.EMPLOYEE_ID ||
                    ', last_name: ' || var_record.LAST_NAME ||
                    ', hire_date: ' || var_record.HIRE_DATE);
    END LOOP;
    CLOSE c_date_cur;
END;


-- Зад. 2. Изведете за всеки идентификатор и име на страна, данните за всички локации за страната.
-- Използвайте два курсора, като вторият курсор приема като параметър идентификатора на страната.


DECLARE
    CURSOR c_outer IS
        SELECT COUNTRY_ID, COUNTRY_NAME
        FROM COUNTRIES;
    CURSOR c_inner(param_country_id COUNTRIES.country_id%TYPE) IS
        SELECT *
        FROM LOCATIONS
        WHERE COUNTRY_ID = param_country_id;
    var_location c_inner%ROWTYPE;
BEGIN
    FOR cur_country IN c_outer
        LOOP
            DBMS_OUTPUT.PUT_LINE('country_name: ' || cur_country.COUNTRY_NAME);
            OPEN c_inner(cur_country.COUNTRY_ID);
            LOOP
                FETCH c_inner into var_location;
                EXIT when c_inner%notfound;
                DBMS_OUTPUT.PUT_LINE('city: ' ||var_location.CITY ||
                                     ', post code: ' || var_location.POSTAL_CODE);
            END LOOP;
            CLOSE c_inner;
            DBMS_OUTPUT.PUT_LINE('country_name: ' || cur_country.COUNTRY_NAME || 'end-----------------');
        END LOOP;
END;
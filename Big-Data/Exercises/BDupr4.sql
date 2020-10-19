SET SERVEROUTPUT ON

SELECT
    COUNT(*)
FROM
    employees;

------------------------------

BEGIN
    INSERT INTO employees (
        employee_id,
        first_name,
        last_name,
        email,
        hire_date,
        job_id,
        salary
    ) VALUES (
        employees_seq.NEXTVAL,
        'Ruth',
        'Cores',
        'RCORES',
        current_date,
        'AD_ASST',
        4000
    );

END;
------------------------------

SELECT
    COUNT(*)
FROM
    employees;

---

ROLLBACK;
-----------------------------------------------------------------------------------------------------------------

SELECT
    first_name,
    salary
FROM
    employees
WHERE
    job_id = 'ST_CLERK';

---

DECLARE
    sal_increase employees.salary%TYPE := 800;
BEGIN
    UPDATE employees
    SET
        salary = salary + sal_increase
    WHERE
        job_id = 'ST_CLERK';

END;
---

SELECT
    first_name,
    salary
FROM
    employees
WHERE
    job_id = 'ST_CLERK';

---

ROLLBACK;
------------------------------------------------------------------------------------------------------------
-- Създаване на таблица employees2

CREATE TABLE employees2
    AS
        ( SELECT
            *
        FROM
            employees
        );
---

DECLARE
    deptno employees2.department_id%TYPE := 10;
BEGIN
    DELETE FROM employees2
    WHERE
        department_id = deptno;

END;

--------------------------------------------------------------

DECLARE
    v_rows_deleted   VARCHAR2(30);
    v_empno          employees2.employee_id%TYPE := 176;
BEGIN
    DELETE FROM employees2
    WHERE
        employee_id = v_empno;

    v_rows_deleted := ( SQL%rowcount
                        || ' row deleted.' );
    dbms_output.put_line(v_rows_deleted);
END;

-- 
drop table employees2;
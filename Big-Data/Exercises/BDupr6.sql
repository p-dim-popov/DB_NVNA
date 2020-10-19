SET SERVEROUTPUT ON

--=========================================================

DECLARE
    TYPE t_rec IS RECORD (
        v_sal         NUMBER(8),
        v_minsal      NUMBER(8) DEFAULT 1000,
        v_hire_date   employees.hire_date%TYPE,
        v_rec1        employees%rowtype
    );
    v_myrec t_rec;
BEGIN
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hire_date := sysdate;
    SELECT
        *
    INTO v_myrec.v_rec1
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(v_myrec.v_rec1.last_name
                         || ' '
                         || to_char(v_myrec.v_hire_date)
                         || ' '
                         || to_char(v_myrec.v_sal));

END;
--=========================================================

SET VERIFY OFF

DROP TABLE retired_emps;  -- изтриване на таблица retired_emps
----

CREATE TABLE retired_emps    -- създаване на таблица retired_emps

 (
    empno       NUMBER(4),
    ename       VARCHAR2(10),
    job         VARCHAR2(9),
    mgr         NUMBER(4),
    hiredate    DATE,
    leavedate   DATE,
    sal         NUMBER(7, 2),
    comm        NUMBER(7, 2),
    deptno      NUMBER(2)
);
----

DECLARE
    v_employee_number   NUMBER := 124;
    v_emp_rec           employees%rowtype;
BEGIN
    SELECT
        *
    INTO v_emp_rec
    FROM
        employees
    WHERE
        employee_id = v_employee_number;

    INSERT INTO retired_emps (
        empno,
        ename,
        job,
        mgr,
        hiredate,
        leavedate,
        sal,
        comm,
        deptno
    ) VALUES (
        v_emp_rec.employee_id,
        v_emp_rec.last_name,
        v_emp_rec.job_id,
        v_emp_rec.manager_id,
        v_emp_rec.hire_date,
        sysdate,
        v_emp_rec.salary,
        v_emp_rec.commission_pct,
        v_emp_rec.department_id
    );

END;
------

SELECT
    *
FROM
    retired_emps;  -- извеждане на данни от таблица retired_emps
--===========================================================

SET VERIFY OFF

DROP TABLE retired_emps;   -- изтриване на таблица retired_emps
----
/*създаване на таблица retired_emps*/

CREATE TABLE retired_emps (
    empno       NUMBER(4),
    ename       VARCHAR2(10),
    job         VARCHAR2(9),
    mgr         NUMBER(4),
    hiredate    DATE,
    leavedate   DATE,
    sal         NUMBER(7, 2),
    comm        NUMBER(7, 2),
    deptno      NUMBER(2)
);

----

DECLARE
    v_employee_number   NUMBER := 124;
    v_emp_rec           retired_emps%rowtype;
BEGIN
    SELECT
        employee_id,
        last_name,
        job_id,
        manager_id,
        hire_date,
        hire_date,
        salary,
        commission_pct,
        department_id
    INTO v_emp_rec
    FROM
        employees
    WHERE
        employee_id = v_employee_number;

    INSERT INTO retired_emps VALUES v_emp_rec;

END;

----

SELECT
    *
FROM
    retired_emps;  
--============================================================

SET VERIFY OFF
---

DECLARE
    v_employee_number   NUMBER := 124;
    v_emp_rec           retired_emps%rowtype;
BEGIN
    SELECT
        *
    INTO v_emp_rec
    FROM
        retired_emps;

    v_emp_rec.leavedate := current_date;
    UPDATE retired_emps
    SET
        row = v_emp_rec
    WHERE
        empno = v_employee_number;

END;

----

SELECT
    *
FROM
    retired_emps;  -- извеждане на данни от таблица retired_emps
--=============================================================

DROP TABLE empl;    -- изтриване на таблица empl
---

CREATE TABLE empl (
    ename    VARCHAR2(25 BYTE),
    hiredt   DATE
);   -- създаване на таблица empl
---

DECLARE
    TYPE ename_table_type IS
        TABLE OF employees.last_name%TYPE INDEX BY PLS_INTEGER;
    TYPE hiredate_table_type IS
        TABLE OF DATE INDEX BY PLS_INTEGER;
    ename_table      ename_table_type;
    hiredate_table   hiredate_table_type;
BEGIN
    ename_table(1) := 'CAMERON';
    hiredate_table(8) := sysdate + 7;
    IF ename_table.EXISTS(1) THEN
        INSERT INTO empl VALUES (
            ename_table(1),
            hiredate_table(8)
        );

    END IF;

END;
---

SELECT
    *
FROM
    empl;  -- извеждане на данни от таблица empl

--========================================================

DECLARE
    TYPE dept_table_type IS
        TABLE OF departments%rowtype INDEX BY VARCHAR2(20);
    dept_table dept_table_type;
  -- всеки елемент на dept_table е запис със структура като  таблица departments
BEGIN
    SELECT
        *
    INTO
        dept_table
    (1)
    FROM
        departments
    WHERE
        department_id = 10;

    dbms_output.put_line(dept_table(1).department_name);
END;
--==========================================================

DECLARE
    TYPE emp_table_type IS
        TABLE OF employees%rowtype INDEX BY PLS_INTEGER; -- 
    my_emp_table   emp_table_type;  -- структура като таблица employees
    max_count      NUMBER(3) := 104;
BEGIN
    FOR i IN 100..max_count LOOP SELECT
                                     *
                                 INTO
                                     my_emp_table
                                 (i)
                                 FROM
                                     employees
                                 WHERE
                                     employee_id = i;

    END LOOP;

    FOR i IN my_emp_table.first..my_emp_table.last LOOP dbms_output.put_line(my_emp_table(i).last_name);
    END LOOP;

END;
--==============================================================

DECLARE
    TYPE location_type IS
        TABLE OF locations.city%TYPE;
    offices       location_type;
    table_count   NUMBER;
BEGIN
    offices := location_type('Bombay', 'Tokyo', 'Singapore', 'Oxford');
    FOR i IN 1..offices.count() LOOP dbms_output.put_line(offices(i));
    END LOOP;

END;
--===============================================================

SET VERIFY OFF

DECLARE
    v_countryid        VARCHAR2(20) := 'ca';
    v_country_record   countries%rowtype;
BEGIN
    SELECT
        *
    INTO v_country_record
    FROM
        countries
    WHERE
        country_id = upper(v_countryid);

    dbms_output.put_line('Country Id: '
                         || v_country_record.country_id
                         || ' Country Name: '
                         || v_country_record.country_name
                         || ' Region: '
                         || v_country_record.region_id);

END;

--===============================================================

DECLARE
    TYPE dept_table_type IS
        TABLE OF departments.department_name%TYPE INDEX BY PLS_INTEGER;
    my_dept_table   dept_table_type;
    f_loop_count    NUMBER(2) := 10;
    v_deptno        NUMBER(4) := 0;
BEGIN
    FOR i IN 1..f_loop_count LOOP
        v_deptno := v_deptno + 10;
        SELECT
            department_name
        INTO
            my_dept_table
        (i)
        FROM
            departments
        WHERE
            department_id = v_deptno;

    END LOOP;

    FOR i IN 1..f_loop_count LOOP dbms_output.put_line(my_dept_table(i));
    END LOOP;

END;
--=============================================================

DECLARE
    TYPE dept_table_type IS
        TABLE OF departments%rowtype INDEX BY PLS_INTEGER;
    my_dept_table   dept_table_type;
    f_loop_count    NUMBER(2) := 10;
    v_deptno        NUMBER(4) := 0;
BEGIN
    FOR i IN 1..f_loop_count LOOP
        v_deptno := v_deptno + 10;
        SELECT
            *
        INTO
            my_dept_table
        (i)
        FROM
            departments
        WHERE
            department_id = v_deptno;

    END LOOP;

    FOR i IN 1..f_loop_count LOOP dbms_output.put_line('Department Number: '
                                                       || my_dept_table(i).department_id
                                                       || ' Department Name: '
                                                       || my_dept_table(i).department_name
                                                       || ' Manager Id: '
                                                       || my_dept_table(i).manager_id
                                                       || ' Location Id: '
                                                       || my_dept_table(i).location_id);
    END LOOP;

END;
--================================================================









-- Task 1 ================================================

DECLARE
    TYPE emp_lname_table_type IS
        TABLE OF employees.last_name%TYPE INDEX BY BINARY_INTEGER;
    TYPE emp_sal_table_type IS
        TABLE OF employees.salary%TYPE INDEX BY BINARY_INTEGER;
    my_emp_lname_table   emp_lname_table_type;
    my_emp_sal_table     emp_sal_table_type;
    v_i                  NUMBER := 1;
BEGIN
    FOR i IN 100..114 LOOP
        SELECT
            last_name,
            salary
        INTO
                my_emp_lname_table
            (v_i),
            my_emp_sal_table(v_i)
        FROM
            employees
        WHERE
            employee_id = i;

        v_i := v_i + 1;
    END LOOP;

    FOR i IN 1..15 LOOP dbms_output.put_line('last name: '
                                             || my_emp_lname_table(i)
                                             || ' salary: '
                                             || my_emp_sal_table(i));
    END LOOP;

END;

-- Task 2 ===================================================

SELECT
    *
FROM
    employees
WHERE
    employee_id BETWEEN 104 AND 108;

DECLARE
    TYPE emp_table_type IS
        TABLE OF employees%rowtype INDEX BY BINARY_INTEGER;
    my_emp_table   emp_table_type;
    v_emp_record   employees%rowtype;
    v_i            NUMBER := 1;
BEGIN
    FOR i IN 104..108 LOOP
        SELECT
            *
        INTO v_emp_record
        FROM
            employees
        WHERE
            employee_id = i;

        IF v_emp_record.salary < 5000 THEN
            v_emp_record.salary := v_emp_record.salary + 200;
        END IF;

        my_emp_table(v_i) := v_emp_record;
        v_i := v_i + 1;
    END LOOP;
--    FOR i IN 1..v_i LOOP dbms_output.put_line('last name: '
--                                             || my_emp_table(i).last_name
--                                             || ' salary: '
--                                             || my_emp_table(i).salary);
--    END LOOP;
END;

--
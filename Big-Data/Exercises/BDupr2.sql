SET SERVEROUTPUT ON

DECLARE
    v_event VARCHAR2(15);
BEGIN
    v_event := q'!Father's day!';
    dbms_output.put_line('3rd Sunday in June is : ' || v_event);
    v_event := q'[Mother's day]';
    dbms_output.put_line('2nd Sunday in May is : ' || v_event);
END;
-----------------------------------------

VARIABLE b_result NUMBER

SET AUTOPRINT ON

BEGIN
    SELECT
        ( salary * 12 ) + nvl(commission_pct, 0) * ( salary * 12 )
    INTO :b_result
    FROM
        employees
    WHERE
        employee_id = 130;

END;
----------------------------------------------------

VARIABLE b_emp_salary NUMBER

SET AUTOPRINT OFF

BEGIN
    SELECT
        salary
    INTO :b_emp_salary
    FROM
        employees
    WHERE
        employee_id = 178;

END;
--++++++++++++++++++++++++++++++++++++++++++++

PRINT b_emp_salary
--------------------------------------

VARIABLE b_emp_salary NUMBER

SET AUTOPRINT ON

DECLARE
    v_empno NUMBER(6) := &empno;
BEGIN
    SELECT
        salary
    INTO :b_emp_salary
    FROM
        employees
    WHERE
        employee_id = v_empno;

END;
--------------------

-- Task 1 --
-- Изведете всички данни за номер на локация, 
-- която се въвежда от потребител. 
-- Изведете данните на няколко реда с подходящи текстове.

DECLARE
    v_loc_id           locations.location_id%TYPE := &loc_id;
    v_str_addr         locations.street_address%TYPE;
    v_postcode         locations.postal_code%TYPE;
    v_city             locations.city%TYPE;
    v_state_province   locations.state_province%TYPE;
    v_country_id       locations.country_id%TYPE;
BEGIN
    SELECT
        location_id,
        street_address,
        postal_code,
        city,
        state_province,
        country_id
    INTO
        v_loc_id,
        v_str_addr,
        v_postcode,
        v_city,
        v_state_province,
        v_country_id
    FROM
        locations
    WHERE
        location_id = v_loc_id;

    dbms_output.put_line(v_loc_id
                         || ' '
                         || v_str_addr
                         || ' '
                         || v_postcode
                         || ' '
                         || v_city
                         || ' '
                         || v_state_province
                         || ' '
                         || v_country_id);

END;

-- Task 2 --
-- Изведете сумата от заплати за номер на отдел, 
-- който се въвежда от потребител. 
-- Изведете сумата и номера на отдела с подходящи текстове.

DECLARE
    v_department_id   employees.department_id%TYPE := &dep_id;
    v_sum             NUMBER(6);
BEGIN
    SELECT
        SUM(salary)
    INTO v_sum
    FROM
        employees
    WHERE
        department_id = v_department_id;

    dbms_output.put_line('The sum of department: '
                         || ' '
                         || v_department_id
                         || ' '
                         || 'is'
                         || ' '
                         || v_sum);

END;

-- Task 3 --
-- Изведете броя на служителите, които получават минимална заплата. 
-- Изведете броя с подходящ текст.

DECLARE
    v_emp_count INT;
BEGIN
    SELECT
        COUNT(employee_id)
    INTO v_emp_count
    FROM
        employees
    WHERE
        salary = (
            SELECT
                MIN(salary)
            FROM
                employees
        );

    dbms_output.put_line('Employees with min salary: ' || v_emp_count);
END;

-- Task 4 --
-- Изведете броя на отделите, 
-- които се намират на определен номер на локация, 
-- който се въвежда от потребител. Използвайте bind променлива.

SET AUTOPRINT OFF;

VARIABLE b_dept_count NUMBER;

DECLARE
    v_loc_id locations.location_id%TYPE := &loc_id;
BEGIN
    SELECT
        COUNT(*)
    INTO :b_dept_count
    FROM
        locations
    WHERE
        location_id = v_loc_id;

END;

--+++++++++++++++++++++++++++

PRINT b_dept_count;

-- Task 5 --
-- Изведете длъжността на служител с номер 178 
-- с текст „employee's job is “.

DECLARE
    v_job_id employees.job_id%TYPE;
BEGIN
    SELECT
        job_id
    INTO v_job_id
    FROM
        employees
    WHERE
        employee_id = 178;

    dbms_output.put_line(q'[employee's job is ]' || v_job_id);
END;
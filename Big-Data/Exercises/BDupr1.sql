SET SERVEROUTPUT ON

-----------

DECLARE
    v_fname VARCHAR2(20);
BEGIN
    SELECT
        first_name
    INTO v_fname
    FROM
        employees
    WHERE
        employee_id = 100;

END;

------------

DECLARE
    v_fname VARCHAR(20);
BEGIN
    SELECT
        first_name
    INTO v_fname
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(' The First Name of the Employee is ' || v_fname);
END;
--------------------------

DECLARE
    v_myname VARCHAR(20);
BEGIN
    dbms_output.put_line('My name is: ' || v_myname);
    v_myname := 'John';
    dbms_output.put_line('My name is: ' || v_myname);
END;
----------------

DECLARE
    v_myname VARCHAR(20) := 'John';
BEGIN
    v_myname := 'Steven';
    dbms_output.put_line('My name is: ' || v_myname);
END;
------------------

-- exercise 1 --

DECLARE
    v_first_name    VARCHAR2(20 BYTE);
    v_last_name     VARCHAR2(25 BYTE);
    v_employee_id   NUMBER(6, 0) := &employee_id;
BEGIN
    SELECT
        first_name,
        last_name
    INTO
        v_first_name,
        v_last_name
    FROM
        employees
    WHERE
        employee_id = v_employee_id;

    dbms_output.put_line('My first name is '
                         || v_first_name
                         || ' and my last name is '
                         || v_last_name);
END;

-- exercise 2 --

DECLARE
    v_first_name   VARCHAR2(20 BYTE);
    v_last_name    VARCHAR2(25 BYTE);
    v_salary       NUMBER(8, 2) := &salary;
BEGIN
    SELECT
        first_name,
        last_name,
        salary
    INTO
        v_first_name,
        v_last_name,
        v_salary
    FROM
        employees
    WHERE
        salary > v_salary
        AND ROWNUM <= 1;

    dbms_output.put_line('My first name is '
                         || v_first_name
                         || ' and my last name is '
                         || v_last_name
                         || ' and my salary is '
                         || v_salary);

END;
SET SERVEROUTPUT ON

CREATE SEQUENCE my_seq;

--------

DECLARE
    v_new_id NUMBER;
BEGIN
    v_new_id := my_seq.nextval;
END;

SELECT
    my_seq.CURRVAL
FROM
    dual;  

---------

DECLARE
    v_salary         NUMBER(6) := 6000;
    v_sal_hike       VARCHAR2(5) := '1000';
    v_total_salary   v_salary%TYPE;
BEGIN
    v_total_salary := v_salary + v_sal_hike;
    dbms_output.put_line('Salary: '
                         || v_salary
                         || chr(10)
                         || 'Salary hike: '
                         || v_sal_hike
                         || chr(10)
                         || 'Total salary: '
                         || v_total_salary
                         || chr(10));

END;

-----------

DECLARE
    v_outer_variable VARCHAR2(20) := 'GLOBAL VARIABLE';
BEGIN
    DECLARE
        v_inner_variable VARCHAR2(20) := 'LOCAL VARIABLE';
    BEGIN
        dbms_output.put_line(v_inner_variable);
        dbms_output.put_line(v_outer_variable);
    END;

    dbms_output.put_line(v_outer_variable);
END;

--------

DECLARE
    v_outer_variable VARCHAR2(20) := 'GLOBAL VARIABLE';
BEGIN
    DECLARE
        v_inner_variable VARCHAR2(20) := 'LOCAL VARIABLE';
    BEGIN
        dbms_output.put_line(v_inner_variable);
        dbms_output.put_line(v_outer_variable);
    END;

    dbms_output.put_line(v_outer_variable);
END;

---------

DECLARE
    v_father_name     VARCHAR2(20) := 'Patrick';
    v_date_of_birth   DATE := '1972-04-20';
BEGIN
    DECLARE
        v_child_name      VARCHAR2(20) := 'Mike';
        v_date_of_birth   DATE := '2002-12-12';
    BEGIN
        dbms_output.put_line('Father''s Name: ' || v_father_name);
        dbms_output.put_line('Date of Birth: ' || v_date_of_birth);
        dbms_output.put_line('Child''s Name: ' || v_child_name);
    END;

    dbms_output.put_line('Date of Birth: ' || v_date_of_birth);
END;

-------------------

BEGIN
    << outer >> DECLARE
        v_father_name     VARCHAR2(20) := 'Patrick';
        v_date_of_birth   DATE := TO_DATE('20-Apr-1972', 'DD-MON-YYYY');
    BEGIN
        DECLARE
            v_child_name      VARCHAR2(20) := 'Mike';
            v_date_of_birth   DATE := TO_DATE('12-Dec-2002', 'DD-MON-YYYY');
        BEGIN
            dbms_output.put_line('Father''s Name: ' || v_father_name);
            dbms_output.put_line('Date of Birth: ' || outer.v_date_of_birth);
            dbms_output.put_line('Child''s Name: ' || v_child_name);
            dbms_output.put_line('Date of Birth: ' || v_date_of_birth);
        END;
    END;
END outer;

-------------------------

BEGIN
    << outer >> DECLARE
        v_sal       NUMBER(7, 2) := 60000;
        v_comm      NUMBER(7, 2) := v_sal * 0.20;
        v_message   VARCHAR2(255) := ' eligible for commission';
    BEGIN
        DECLARE
            v_sal          NUMBER(7, 2) := 50000;
            v_comm         NUMBER(7, 2) := 0;
            v_total_comp   NUMBER(7, 2) := v_sal + v_comm;
        BEGIN
            v_message := 'CLERK not' || v_message;
            outer.v_comm := v_sal * 0.30;
        END;

        v_message := 'SALESMAN' || v_message;
        dbms_output.put_line(v_message);
    END;
END outer;

------------------------------------

DECLARE
    v_dname departments.department_id%TYPE;
BEGIN
    SELECT
        department_id
    INTO v_dname
    FROM
        departments
    WHERE
        department_id = 80;

    dbms_output.put_line(' Name is : ' || v_dname);
END;

-----------------------

DECLARE
    v_emp_hiredate   employees.hire_date%TYPE;
    v_emp_salary     employees.salary%TYPE;
BEGIN
    SELECT
        hire_date,
        salary
    INTO
        v_emp_hiredate,
        v_emp_salary
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line('date: '
                         || v_emp_hiredate
                         || ' salary: '
                         || v_emp_salary);
END;
--------------------------------

DECLARE
    v_sum_sal   NUMBER(10, 2);
    v_deptno    NUMBER NOT NULL := 60;
BEGIN
    SELECT
        SUM(salary)  -- group function
    INTO v_sum_sal
    FROM
        employees
    WHERE
        department_id = v_deptno;

    dbms_output.put_line('The sum of salary is ' || v_sum_sal);
END;

-----------------------------

DECLARE
    v_hire_date     employees.hire_date%TYPE;
    v_sysdate       v_hire_date%TYPE;
    v_employee_id   employees.employee_id%TYPE := 176;
BEGIN
    SELECT
        hire_date,
        sysdate
    INTO
        v_hire_date,
        v_sysdate
    FROM
        employees
    WHERE
        employee_id = employee_id;

END;

------------------------

-- Зад 1. Намерете минималната заплата и я изведете с подходящ текст.

DECLARE
    v_min_sal NUMBER;
BEGIN
    SELECT
        MIN(salary)
    INTO v_min_sal
    FROM
        employees;

    dbms_output.put_line('Min salary: ' || v_min_sal);
END;


-- Зад 2. Намерете максималната, минималната заплата и 
-- разликата между тях за зададен отдел. Изведете ги с подходящи съобщения.

DECLARE
    v_dep_id     employees.department_id%TYPE := &dep_id;
    v_sal_diff   employees.salary%TYPE;
BEGIN
    SELECT
        MAX(salary) - MIN(salary)
    INTO v_sal_diff
    FROM
        employees
    WHERE
        department_id = v_dep_id;

    dbms_output.put_line('Diff: ' || v_sal_diff);
END;

-- Зад 3. Намерете и изведете броя на служителите от зададен отдел.

DECLARE
    v_dep_id      employees.department_id%TYPE := &dep_id;
    v_emp_count   NUMBER;
BEGIN
    SELECT
        COUNT(employee_id)
    INTO v_emp_count
    FROM
        employees
    WHERE
        department_id = v_dep_id;

    dbms_output.put_line('Count: ' || v_emp_count);
END;


-- BONUS -- /*find max sal and find which depts have people with it*/

-- MAX variant

DECLARE
    v_dept_count NUMBER;
BEGIN
    SELECT
        COUNT(DISTINCT department_id)
    INTO v_dept_count
    FROM
        employees
    WHERE
        salary = (
            SELECT
                MAX(salary)
            FROM
                employees
        );

    dbms_output.put_line('Count: ' || v_dept_count);
END;

-- AVG variant

DECLARE
    v_dept_count NUMBER;
BEGIN
    SELECT
        department_id
    FROM
        employees
    GROUP BY
        department_id,
        salary
    HAVING
        salary > AVG(salary);

    dbms_output.put_line('Count: ' || v_dept_count);
END;

-- PADDING
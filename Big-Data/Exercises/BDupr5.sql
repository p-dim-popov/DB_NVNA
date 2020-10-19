SET SERVEROUTPUT ON

-------------------------

DECLARE
    myage NUMBER := 31;
BEGIN
    IF myage < 11 THEN
        dbms_output.put_line(' I am a child ');
    END IF;
END;
-------------------------------

DECLARE
    myage NUMBER := 31;
BEGIN
    IF myage < 11 THEN
        dbms_output.put_line(' I am a child ');
    ELSE
        dbms_output.put_line(' I am not a child ');
    END IF;
END;
-----------------------------------

DECLARE
    myage NUMBER := 31;
BEGIN
    IF myage < 11 THEN
        dbms_output.put_line(' I am a child ');
    ELSIF myage < 20 THEN
        dbms_output.put_line(' I am young ');
    ELSIF myage < 30 THEN
        dbms_output.put_line(' I am in my twenties');
    ELSIF myage < 40 THEN
        dbms_output.put_line(' I am in my thirties');
    ELSE
        dbms_output.put_line(' I am always young ');
    END IF;
END;

--------------------------------------

DECLARE
    myage NUMBER;
BEGIN
    IF myage < 11 THEN
        dbms_output.put_line(' I am a child ');
    ELSE
        dbms_output.put_line(' I am not a child ');
    END IF;
END;

----------------------------------------

SET VERIFY OFF

DECLARE
    grade       CHAR(1) := upper('&grade');
    appraisal   VARCHAR2(20);
BEGIN
    appraisal :=
        CASE grade
            WHEN 'A' THEN
                'Excellent'
            WHEN 'B' THEN
                'Very Good'
            WHEN 'C' THEN
                'Good'
            ELSE 'No such grade'
        END;

    dbms_output.put_line('Grade: '
                         || grade
                         || '   Appraisal '
                         || appraisal);
END;

-----------------------------------

DECLARE
    grade       CHAR(1) := upper('&grade');
    appraisal   VARCHAR2(20);
BEGIN
    appraisal :=
        CASE
            WHEN grade = 'A' THEN
                'Excellent'
            WHEN grade IN (
                'B',
                'C'
            ) THEN
                'Good'
            ELSE 'No such grade'
        END;

    dbms_output.put_line('Grade: '
                         || grade
                         || '  Appraisal '
                         || appraisal);
END;

-------------------------------------

DECLARE
    deptid     NUMBER;
    deptname   VARCHAR2(20);
    emps       NUMBER;
    mngid      NUMBER := 108;
BEGIN
    CASE mngid
        WHEN 108 THEN
            SELECT
                department_id,
                department_name
            INTO
                deptid,
                deptname
            FROM
                departments
            WHERE
                manager_id = 108;

            SELECT
                COUNT(*)
            INTO emps
            FROM
                employees
            WHERE
                department_id = deptid;

        WHEN 200 THEN
            SELECT
                department_id,
                department_name
            INTO
                deptid,
                deptname
            FROM
                departments
            WHERE
                manager_id = 200;

            SELECT
                COUNT(*)
            INTO emps
            FROM
                employees
            WHERE
                department_id = deptid;

        WHEN 121 THEN
            SELECT
                department_id,
                department_name
            INTO
                deptid,
                deptname
            FROM
                departments
            WHERE
                manager_id = 121;

            SELECT
                COUNT(*)
            INTO emps
            FROM
                employees
            WHERE
                department_id = deptid;

    END CASE;

    dbms_output.put_line('You are working in the '
                         || deptname
                         || ' department. There are '
                         || emps
                         || ' employees in this department');

END;

-------------------------------------

SELECT
    *
FROM
    locations;
    
--------------------------------------

DECLARE
    v_countryid   locations.country_id%TYPE := 'CA';
    v_loc_id      locations.location_id%TYPE;
    v_counter     NUMBER(2) := 1;
    v_new_city    locations.city%TYPE := 'Montreal';
BEGIN
    SELECT
        MAX(location_id)
    INTO v_loc_id
    FROM
        locations
    WHERE
        country_id = v_countryid;

    LOOP
        INSERT INTO locations (
            location_id,
            city,
            country_id
        ) VALUES (
            ( v_loc_id + v_counter ),
            v_new_city,
            v_countryid
        );

        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 3;
    END LOOP;

END;

--------------------------------

SELECT
    *
FROM
    locations;

------------

ROLLBACK;
------------------

SELECT
    *
FROM
    locations;
    
-----------------------------------

DECLARE
    v_countryid   locations.country_id%TYPE := 'CA';
    v_loc_id      locations.location_id%TYPE;
    v_new_city    locations.city%TYPE := 'Montreal';
    v_counter     NUMBER := 1;
BEGIN
    SELECT
        MAX(location_id)
    INTO v_loc_id
    FROM
        locations
    WHERE
        country_id = v_countryid;

    WHILE v_counter <= 3 LOOP
        INSERT INTO locations (
            location_id,
            city,
            country_id
        ) VALUES (
            ( v_loc_id + v_counter ),
            v_new_city,
            v_countryid
        );

        v_counter := v_counter + 1;
    END LOOP;

END;

---------------------------------

SELECT
    *
FROM
    locations;

---------------------------

ROLLBACK;

------------------------------

SELECT
    *
FROM
    locations;

-----------------------------------

DECLARE
    v_countryid   locations.country_id%TYPE := 'CA';
    v_loc_id      locations.location_id%TYPE;
    v_new_city    locations.city%TYPE := 'Montreal';
BEGIN
    SELECT
        MAX(location_id)
    INTO v_loc_id
    FROM
        locations
    WHERE
        country_id = v_countryid;

    FOR i IN 1..3 LOOP INSERT INTO locations (
        location_id,
        city,
        country_id
    ) VALUES (
        ( v_loc_id + i ),
        v_new_city,
        v_countryid
    );

    END LOOP;

END;

------------------

SELECT
    *
FROM
    locations;

------------------------------

ROLLBACK;

-------------------------

DECLARE
    v_total SIMPLE_INTEGER := 0;
BEGIN
    FOR i IN 1..10 LOOP
        v_total := v_total + i;
        dbms_output.put_line('Total is: ' || v_total);
        CONTINUE WHEN i > 5;
        v_total := v_total + i;
        dbms_output.put_line('Out of Loop Total is: ' || v_total);
    END LOOP;
END;

-----------------------------------

DECLARE
    v_total NUMBER := 0;
BEGIN
    << beforetoploop >> FOR i IN 1..10 LOOP
        v_total := v_total + 1;
        dbms_output.put_line('Total is: ' || v_total);
        FOR j IN 1..10 LOOP
            CONTINUE beforetoploop WHEN i + j > 5;
            v_total := v_total + 1;
        END LOOP;

    END LOOP;
END two_loop;

--��� 1. �������� ���� ��������� �� ������� ����� �� �����, ��� ������� � > 30.
--�������� ��������� ��� ����� <=30.

DECLARE
    v_dep_id      employees.department_id%TYPE := &dep_id;
    v_emp_count   NUMBER;
BEGIN
    IF v_dep_id > 30 THEN
        SELECT
            COUNT(employee_id)
        INTO v_emp_count
        FROM
            employees
        WHERE
            department_id = v_dep_id;

        dbms_output.put_line('employees count is: ' || v_emp_count);
    ELSE
        dbms_output.put_line('dep id is: ' || v_dep_id);
    END IF;
END;

--��� 2. ������� ����� �� ����� �� ������������. ��� ������� �:
--- 10, �������� �������� ������� �� ������
--- 30,  �������� ������ �� ������� �� ������
--- 80, �������� ���� ��������� � ������
--� �������� ������ �������� ��������� ����� �� �����.

DECLARE
    v_dep_id       employees.department_id%TYPE := &dep_id;
    v_number_out   NUMBER;
BEGIN
    CASE v_dep_id
        WHEN 10 THEN
            SELECT
                AVG(salary)
            INTO v_number_out
            FROM
                employees
            WHERE
                department_id = v_dep_id;

            dbms_output.put_line('avg sal in '
                                 || v_dep_id
                                 || ' is '
                                 || v_number_out);
        WHEN 30 THEN
            SELECT
                SUM(salary)
            INTO v_number_out
            FROM
                employees
            WHERE
                department_id = v_dep_id;

            dbms_output.put_line('sum sal in '
                                 || v_dep_id
                                 || ' is '
                                 || v_number_out);
        WHEN 80 THEN
            SELECT
                COUNT(employee_id)
            INTO v_number_out
            FROM
                employees
            WHERE
                department_id = v_dep_id;

            dbms_output.put_line('people in '
                                 || v_dep_id
                                 || ' is '
                                 || v_number_out);
        ELSE
            dbms_output.put_line('dep id ' || v_number_out);
    END CASE;
END;

--��� 3. �� ��������� �� 142 �� 148 �������� �������� ����� � ��������� ���������.

DECLARE
    v_sal employees.salary%TYPE;
BEGIN
    FOR i IN 142..148 LOOP
        SELECT
            salary * 12 + ( salary * 12 ) * ( nvl(commission_pct, 0) )
        INTO v_sal
        FROM
            employees
        WHERE
            employee_id = i;

        dbms_output.put_line('salary of '
                             || i
                             || ' is '
                             || v_sal);
    END LOOP;
END;

--��� 4. �������� ������ �� ������ ������ � �������� ��� � ����� �� �������� � BG,
--Bulgaria � ������� countries.

DECLARE
    v_reg_id regions.region_id%TYPE;
BEGIN
    SELECT
        region_id
    INTO v_reg_id
    FROM
        regions
    WHERE
        region_name = 'Europe';

    INSERT INTO countries (
        country_id,
        country_name,
        region_id
    ) VALUES (
        'BG',
        'Bulgaria',
        v_reg_id
    );

END;


--��� 5 .�������� 
--11
--12
--13
--21
--22
--23
--31
--32
--33
--���� ���������� ����� �� ����������� �� �����������.

DECLARE
    v_n NUMBER;
BEGIN
    FOR i IN 1..3 LOOP
        FOR j IN 1..3 LOOP
            dbms_output.put_line(i || j);
        END LOOP;
    END LOOP;
END;









----------------------------
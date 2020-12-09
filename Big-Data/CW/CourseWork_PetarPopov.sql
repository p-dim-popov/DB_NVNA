-- preparation functions
CREATE OR REPLACE PROCEDURE DROP_TABLE_IF_EXISTS(param_table_name IN ALL_TAB_COLUMNS.TABLE_NAME%TYPE)
    IS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ' || param_table_name;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;

-- 1
CREATE OR REPLACE FUNCTION GET_YEARS_SERVICE(input_employee_id IN NUMBER)
    RETURN NUMBER
    IS
    var_years_of_service NUMBER;
BEGIN
    SELECT round(months_between(sysdate, HIRE_DATE) / 12.0)
    INTO var_years_of_service
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = input_employee_id;

    RETURN var_years_of_service;

EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Employee with id ' || input_employee_id || ' does not exist!');
        RETURN -1;
END;

DECLARE
    var_employee_id      NUMBER := &emp_id;
    var_years_of_service NUMBER := GET_YEARS_SERVICE(var_employee_id);
BEGIN
    IF var_years_of_service <> -1 THEN
        DBMS_OUTPUT.PUT_LINE('Years of service of employee number ' || var_employee_id || ': ' || var_years_of_service);
    END IF;
END ;
-- 100 (works)
-- 300 (error)

-- 2
DECLARE
    TYPE EMPLOYEES_TABLE_TYPE IS TABLE OF employees%ROWTYPE INDEX BY BINARY_INTEGER;
    employees_table             EMPLOYEES_TABLE_TYPE;
    var_employee_row            employees%ROWTYPE;
    var_employees_table_indexes NUMBER := 0;
BEGIN
    FOR counter IN 100..108
        LOOP
            SELECT *
            INTO var_employee_row
            FROM EMPLOYEES
            WHERE EMPLOYEE_ID = counter;

            -- for debugging --
            DBMS_OUTPUT.PUT_LINE(var_employee_row.HIRE_DATE);
            DBMS_OUTPUT.PUT_LINE(GET_YEARS_SERVICE(var_employee_row.EMPLOYEE_ID));
            -------------------

            IF GET_YEARS_SERVICE(var_employee_row.EMPLOYEE_ID) > 15 THEN
                var_employees_table_indexes := var_employees_table_indexes + 1;
                employees_table(var_employees_table_indexes) := var_employee_row;
            END IF;
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('');

    FOR counter IN 1..var_employees_table_indexes
        LOOP
            DBMS_OUTPUT.PUT_LINE('Employee number ' || employees_table(counter).EMPLOYEE_ID ||
                                 ' (Name: ' || employees_table(counter).FIRST_NAME || ')' ||
                                 ' is working here for ' || GET_YEARS_SERVICE(employees_table(counter).EMPLOYEE_ID) ||
                                 ' years');
        END LOOP;
END;

-- 3
BEGIN
    DROP_TABLE_IF_EXISTS('emp');
END;

CREATE TABLE emp AS (SELECT *
                     FROM EMPLOYEES);

DECLARE
    CURSOR cursor_c (param_department_id emp.department_id%TYPE) IS
        SELECT EMPLOYEE_ID, DEPARTMENT_ID
        FROM emp
        WHERE DEPARTMENT_ID = param_department_id
          AND SALARY < 2700
            FOR UPDATE OF SALARY, DEPARTMENT_ID;
    var_result_row cursor_c%ROWTYPE;
BEGIN
    OPEN cursor_c(30);
    LOOP
        FETCH cursor_c INTO var_result_row;
        EXIT WHEN cursor_c%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(var_result_row.EMPLOYEE_ID);

        UPDATE emp
        SET SALARY        = SALARY * 1.05,
            DEPARTMENT_ID = 20
        WHERE CURRENT OF cursor_c;
    END LOOP;
    CLOSE cursor_c;
    COMMIT;
END;

-- 4
BEGIN
    DROP_TABLE_IF_EXISTS('DEPT');
END;

CREATE TABLE DEPT AS (SELECT *
                      FROM DEPARTMENTS);

BEGIN
    DROP_TABLE_IF_EXISTS('ERROR_DEPART');
END;

CREATE TABLE ERROR_DEPART AS (SELECT *
                              FROM DEPARTMENTS
                              WHERE 1 = 2);

CREATE OR REPLACE FUNCTION DEPARTMENT_EXISTS(input_department_id IN DEPT.DEPARTMENT_ID%TYPE)
    RETURN BOOLEAN
    IS
    var_department_id DEPT.DEPARTMENT_ID%TYPE;
BEGIN
    SELECT DEPARTMENT_ID
    INTO var_department_id
    FROM DEPT
    WHERE DEPARTMENT_ID = input_department_id;

    RETURN TRUE;

EXCEPTION
    WHEN no_data_found THEN
        RETURN FALSE;
END;

CREATE OR REPLACE FUNCTION IS_DEPARTMENT_NAME_AVAILABLE(input_department_name IN DEPT.DEPARTMENT_NAME%TYPE)
    RETURN BOOLEAN
    IS
    var_department_name DEPT.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT DISTINCT DEPARTMENT_NAME
    INTO var_department_name
    FROM DEPT
    WHERE DEPARTMENT_NAME = input_department_name;

    RETURN FALSE;

EXCEPTION
    WHEN no_data_found THEN
        RETURN TRUE;
END;

CREATE OR REPLACE FUNCTION LOCATION_EXISTS(input_location_id IN LOCATIONS.LOCATION_ID%TYPE)
    RETURN BOOLEAN
    IS
    var_location_id LOCATIONS.LOCATION_ID%TYPE;
BEGIN
    SELECT LOCATION_ID
    INTO var_location_id
    FROM LOCATIONS
    WHERE LOCATION_ID = input_location_id;

    RETURN TRUE;

EXCEPTION
    WHEN no_data_found THEN
        RETURN FALSE;
END;

CREATE OR REPLACE FUNCTION EMPLOYEE_EXISTS(input_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
    RETURN BOOLEAN
    IS
    var_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN
    SELECT EMPLOYEE_ID
    INTO var_employee_id
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = input_employee_id;

    RETURN TRUE;

EXCEPTION
    WHEN no_data_found THEN
        RETURN FALSE;
END;

CREATE OR REPLACE FUNCTION IS_EMPLOYEE_MANAGER(input_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE)
    RETURN BOOLEAN
    IS
    var_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN
    SELECT DISTINCT MANAGER_ID
    INTO var_employee_id
    FROM EMPLOYEES
    WHERE MANAGER_ID = input_employee_id;

    RETURN TRUE;

EXCEPTION
    WHEN no_data_found THEN
        RETURN FALSE;
END;


CREATE OR REPLACE PROCEDURE ADD_DEPARTMENT(param_department_id IN DEPT.department_id%TYPE,
                                           param_department_title IN DEPT.department_name%TYPE,
                                           param_location_id IN DEPT.location_id%TYPE,
                                           param_manager_id IN DEPT.manager_id%TYPE)
    IS
    department_exists_exc EXCEPTION;
    department_name_not_avail_exc EXCEPTION;
    location_does_not_exist_exc EXCEPTION;
    employee_does_not_exist_exc EXCEPTION;
    employee_is_manager_exc EXCEPTION;

    PRAGMA EXCEPTION_INIT ( department_exists_exc, -20001 );
    PRAGMA EXCEPTION_INIT ( department_name_not_avail_exc, -20002 );
    PRAGMA EXCEPTION_INIT ( location_does_not_exist_exc, -20003 );
    PRAGMA EXCEPTION_INIT ( employee_does_not_exist_exc, -20004 );
    PRAGMA EXCEPTION_INIT ( employee_is_manager_exc, -20005 );
BEGIN

    IF DEPARTMENT_EXISTS(param_department_id)
    THEN
        raise_application_error(-20001, 'Duplicate of PK (Department_Id) ' || param_department_id);
    END IF;

    IF IS_DEPARTMENT_NAME_AVAILABLE(param_department_title) = FALSE
    THEN
        raise_application_error(-20002, 'Duplicate of unique column (Department_Name) ' || param_department_title);
    END IF;

    IF LOCATION_EXISTS(param_location_id) = FALSE
    THEN
        raise_application_error(-20003, 'No corresponding FK exist (Location_Id) ' || param_location_id);
    END IF;

    IF EMPLOYEE_EXISTS(param_manager_id) = FALSE
    THEN
        raise_application_error(-20004, 'No corresponding FK exist (Employee_Id) ' || param_manager_id);
    END IF;

    IF IS_EMPLOYEE_MANAGER(param_manager_id)
    THEN
        RAISE_APPLICATION_ERROR(-20005, 'Employee is already manager (Employee_Id) ' || param_manager_id);
    END IF;

    INSERT INTO
        DEPT (department_id, department_name, manager_id, location_id)
    VALUES (param_department_id, param_department_title, param_manager_id, param_location_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        INSERT INTO
            ERROR_DEPART(department_id, department_name, manager_id, location_id)
        VALUES (param_department_id, param_department_title, param_manager_id, param_location_id);

        COMMIT;
END;

BEGIN
    ADD_DEPARTMENT(
            280,
            'Politics',
            1000,
            104);
    -- All correct
END;

BEGIN
    ADD_DEPARTMENT(
            100,
            'Politics2',
            1000,
            105);
    -- Existing department id
END;

BEGIN
    ADD_DEPARTMENT(
            290,
            'Executive',
            1000,
            106);
    -- Duplicate name
END;

BEGIN
    ADD_DEPARTMENT(
            300,
            'Politics3',
            3300,
            107);
    -- Not existing location
END;

BEGIN
    ADD_DEPARTMENT(
            310,
            'Politics4',
            1000,
            207);
    -- Not existing employee
END;

BEGIN
    ADD_DEPARTMENT(
            320,
            'Politics5',
            1000,
            100);
    -- Employee is manager
END;


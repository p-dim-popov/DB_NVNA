DECLARE
    v_lname VARCHAR2(15);
BEGIN
    SELECT last_name INTO v_lname FROM employees WHERE first_name = 'John';
    DBMS_OUTPUT.PUT_LINE('John''s last name is : ' || v_lname);
END;

-------------------------------
DECLARE
    v_lname VARCHAR2(15);
BEGIN
    SELECT last_name INTO v_lname FROM employees WHERE first_name = 'John';
    DBMS_OUTPUT.PUT_LINE('John''s last name is : ' || v_lname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(' Your select statement retrieved multiple rows. Consider using a cursor.');
END;

---------------------------------
DECLARE
    e_insert_excep EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_insert_excep, -01400);
BEGIN
    INSERT INTO departments (department_id, department_name) VALUES (280, NULL);
EXCEPTION
    WHEN e_insert_excep THEN
        DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

----------------------------------
SET verify off
---

DECLARE
    v_deptno NUMBER       := 500;
    v_name   VARCHAR2(20) := 'Testing';
    e_invalid_department EXCEPTION;
BEGIN
    UPDATE departments
    SET department_name = v_name
    WHERE department_id = v_deptno;
    IF SQL % NOTFOUND THEN
        RAISE e_invalid_department;
    END IF;
    COMMIT;

EXCEPTION
    WHEN e_invalid_department THEN
        DBMS_OUTPUT.PUT_LINE('No such department id.');
END;

--------------------------------
DROP TABLE messages;
---
/*Създаване на таблица messages*/

CREATE TABLE messages
(
    results VARCHAR2(80)
);
---
SET VERIFY OFF
---
/* Тествайте със заплата 6000; 24000; 35000 */

DECLARE
    v_ename   employees.last_name%TYPE;
    v_emp_sal employees.salary%TYPE := &Input_salary;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE salary = v_emp_sal;

    INSERT INTO messages (results) VALUES (v_ename || ' - ' || v_emp_sal);

EXCEPTION
    WHEN no_data_found THEN
        INSERT INTO messages (results)
        VALUES ('No employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN too_many_rows THEN
        INSERT INTO messages (results)
        VALUES ('More than one employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN OTHERS THEN
        INSERT INTO messages (results) VALUES ('Some other error occurred.');
END;

---
SELECT *
FROM messages;

----------------------------------
DECLARE
    e_child_record_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_child_record_exists, -02292);
BEGIN
    DBMS_OUTPUT.PUT_LINE(' Deleting department 40........');
    DELETE FROM departments WHERE department_id = 40;

EXCEPTION
    WHEN e_child_record_exists THEN
        DBMS_OUTPUT.PUT_LINE(
                ' Cannot delete this department. There are employees in this department (child records exist.) ');
END;

---------------------------------
DECLARE
    e_insert_except EXCEPTION;
    PRAGMA EXCEPTION_INIT (e_insert_except, -01400);
BEGIN
    INSERT INTO departments (department_id, department_name) VALUES (280, NULL);
EXCEPTION
    WHEN e_insert_except THEN
        DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
--------------------------------
DROP TABLE staff;
CREATE TABLE staff AS
SELECT *
FROM EMPLOYEES;
---------

DECLARE
    v_mgr staff.manager_id%TYPE := &Input_manager_id;

BEGIN
    DELETE
    FROM staff
    WHERE manager_id = v_mgr;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20202,
                                'This is not a valid manager');
    END IF;
END;
---------------------------------
DECLARE
    v_mgr      staff.manager_id%TYPE := &Input_manager_id;
    v_lastname staff.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_lastname
    FROM staff
    WHERE manager_id = v_mgr;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20201, 'Manager is not a valid employee.');
END;
-----------------------------------
DECLARE
    e_name EXCEPTION;
BEGIN
    DELETE FROM staff WHERE last_name = 'Anybody';
    IF SQL%NOTFOUND THEN
        RAISE e_name;
    END IF;
EXCEPTION
    WHEN e_name THEN
        RAISE_APPLICATION_ERROR(-20999, 'This is not a valid last name');
END;

-----------------------------------
-- Пример за част от код за улавяне на грешки и записването им
-- в таблица errors с полета e_user, e_date, error_code,  error_message.

-- DECLARE
--     error_code    NUMBER;
--     error_message VARCHAR2(255);
-- BEGIN
--     ...
-- EXCEPTION
--     ...
--     WHEN OTHERS THEN
-- ROLLBACK;
-- error_code := SQLCODE ;
-- error_message := SQLERRM ;
-- INSERT INTO
--     errors (e_user, e_date, error_code, error_message)
-- VALUES (USER, SYSDATE, error_code, error_message);
-- END;

-----------------------------------
-- Зад 1. Напишете PL/SQL блок за намиране на имената на отдели от
-- зададен от клавиатурата номер на локация.
-- Вмъкнете запис в таблица mess_dept ( името на отдела и локацията, системната
-- дата съответно в полета RESULTS и dat). Включете изключения при:
--      Не намерен отдел - Вмъкнете запис в таблица mess_dept с текст
-- 'No department with a location id' и въведения номер на локация; системна дата.
--      При върнати повече от един отдел за локация - Вмъкнете запис в таблица mess_dept
-- с текст 'More than one department with a location id ' и въведения номер на локация; системна дата.
--      При поява на някаква друга грешка – Да се изведе номера и текста на грешката.
-- Тествайте блока последователно с 1700, 1800, 3000 и 2400 за номер на локация!
--
-- Създаване на таблица mess_dept
--
CREATE TABLE mess_dept
(
    RESULTS VARCHAR2(80),
    dat     DATE
);

DECLARE
    var_location_id     DEPARTMENTS.LOCATION_ID%TYPE := &dept_id;
    var_department_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT DEPARTMENT_NAME
    INTO var_department_name
    FROM DEPARTMENTS
    WHERE LOCATION_ID = var_location_id;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('No department with a location id ' ||
                             var_location_id);
    ELSIF SQL%ROWCOUNT > 1 THEN
        DBMS_OUTPUT.PUT_LINE('More than one department with a location id ' ||
                             var_location_id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE();

END;
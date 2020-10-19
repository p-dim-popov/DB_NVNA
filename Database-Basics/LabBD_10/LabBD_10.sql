CREATE OR REPLACE VIEW employees_vu AS
SELECT employee_id, last_name employee, department_id
FROM employees;

SELECT * FROM employees_vu;

SELECT employee_id, department_id FROM employees_vu;

CREATE VIEW dept50 AS
SELECT employee_id empno, last_name employee,
department_id deptno
FROM employees
WHERE department_id = 50
WITH CHECK OPTION CONSTRAINT emp_dept_50;

DESCRIBE dept50

SELECT * FROM dept50;

UPDATE dept50
SET deptno = 80
WHERE employee = 'Matos';

CREATE SEQUENCE dept_id_seq
START WITH 200
INCREMENT BY 10
MAXVALUE 1000;

/*copy deaprtments to dept without data*/

INSERT INTO dept
VALUES (dept_id_seq.nextval, 'Education', null, 1500);

INSERT INTO dept
VALUES (dept_id_seq.nextval, 'Administration', null, 1400);

SELECT dept_id_seq.currval from dual;

SELECT * FROM dept;

CREATE INDEX dept_name_idx ON dept (department_name);

CREATE SYNONYM emp1 FOR EMPLOYEES;
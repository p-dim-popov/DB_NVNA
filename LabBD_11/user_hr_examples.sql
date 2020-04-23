GRANT select ON regions TO newhr  WITH GRANT OPTION;
-- then run newhr scripts up to this point

REVOKE select ON regions FROM newhr;
-- then run newhr scripts up to this point

GRANT select, update, insert ON COUNTRIES  TO newhr;
-- then run newhr scripts up to this point

REVOKE select, update, insert ON COUNTRIES FROM newhr;
-- next is newhr

GRANT SELECT ON departments TO newhr;
-- next is hr

SELECT * FROM   departments;
-- next is newhr

INSERT INTO departments (department_id, department_name) VALUES (500, 'Education');
COMMIT;
-- next is newhr

CREATE SYNONYM newhr FOR newhr.DEPARTMENTS;
-- next is hr

SELECT * FROM   newhr;
-- next is hr

DROP SYNONYM newhr;
REVOKE SELECT ON departments FROM   newhr;
DELETE FROM  departments WHERE department_id = 500;
COMMIT;
SELECT * FROM   departments;
-- next is newhr
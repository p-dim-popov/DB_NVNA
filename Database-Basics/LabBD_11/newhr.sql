CREATE USER newhr IDENTIFIED BY newhr ;
GRANT CONNECT TO newhr ;
GRANT  CREATE TABLE TO   newhr;
GRANT CREATE ANY SYNONYM TO newhr;

ALTER USER newhr QUOTA UNLIMITED ON USERS;

CREATE USER other IDENTIFIED BY other;
GRANT CONNECT TO other;
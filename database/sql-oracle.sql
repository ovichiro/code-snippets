---- Constraint violation: child records found ---------

SELECT owner, constraint_name, constraint_type, table_name, r_owner, r_constraint_name
    FROM all_constraints
    WHERE owner='DBTEST'AND constraint_name='FK9999AAAA8888BBBB';

SELECT owner, constraint_name, constraint_type, table_name, r_owner, r_constraint_name
    FROM all_constraints
    WHERE owner='DBTEST'AND constraint_name='SYS_C00121212';

SELECT * FROM all_cons_columns
  WHERE owner='DBTEST'AND constraint_name = 'SYS_C00121212';


select * from user_cons_columns where constraint_name = 'FK9999AAAA8888BBBB';


-- Create tablespace and users

create tablespace ts_name
    logging
    datafile 'c:/oracle/11g/oradata/orcl/ts_name.dbf' 
    size 100m 
    autoextend on 
    next 32m maxsize 4096m
    extent management local;

create user myuser identified by pass 
    default tablespace ts_name
    quota unlimited on ts_name;
  
grant connect,resource to myuser;
-- or
grant all privileges to myuser;

-- To drop a tablespace
drop tablespace ts_name including contents and datafiles cascade constraints;

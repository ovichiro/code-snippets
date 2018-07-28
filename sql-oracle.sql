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


Oracle ops for dev use
=========================

Create tablespace, schemas, export, import etc.


Oracle 12c as container database
----------------------------------

Install as usual, creating a new regular Windows user for Oracle 12c. Choose a development class database.  
If creating as a container database, also create a PDB with Oracle Database Configuration Assistant.

*Note: 12c can also be installed in legacy mode, without CDB and PDBs.*

### Check PDB State

The pluggable database has to be open in order to work on it.

```sql
alter session set container = CDB$ROOT;

SELECT name, open_mode FROM v$pdbs; -- show PDBs and how/if they are open
SELECT con_name, instance_name, state FROM dba_pdb_saved_states; -- show PDBs with a saved state and what that state is

alter pluggable database all open; -- open all pluggable databases
alter pluggable database pdb_db1 SAVE STATE; -- save the PDBs as open
```

### Create tablespace & users

Local users, the equivalent of "ordinary" users from version 11g, must be created on PDBs, not on the CDB.  
More info: https://dbasolved.com/2013/06/29/common-user-vs-local-user-12c-edition/  

Connect with SYS:

```sql
select * from dba_users;

alter session set container = pdb_db1;
create tablespace ts_name
    logging
    datafile 'd:/oracle/12c/oradata/cdborcl/pdb_db1/ts_name.dbf' 
    size 256m 
    autoextend on 
    next 32m
    extent management local;

CREATE USER myuser identified by mypass 
    default tablespace ts_name
    quota unlimited on ts_name
    container = current;

GRANT connect,resource to myuser;
-- or
GRANT all privileges to myuser;
```

Alter the `tnsnames.ora` file by adding the new service alias for pdb_db1 PDB:

```
pdb_db1 =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1522))
      (CONNECT_DATA =
        (SERVER = DEDICATED)
        (SERVICE_NAME = pdb_db1)
      )
  )
```


Export and import
-----------------------

Connect as SYS to create the dump directory and grant rights.  
It's similar for a non-cdb database.  

```sql
ALTER SESSION set container = pdb_db1;
CREATE DIRECTORY dpump_dir1 AS 'd:/oracle/12c/admin/cdborcl/dpdump';
GRANT READ, WRITE ON DIRECTORY dpump_dir1 TO myuser;
GRANT IMP_FULL_DATABASE TO myuser;
```

Export dump file.  
From the shell prompt:  

```sh
expdp myuser/mypass@pdb_db1 schemas=myuser directory=dpump_dir1 dumpfile=myuser_pdb.dmp logfile=myuser_dump_pdb.log

#or (no pdb variant)

expdp myuser/mypass@orcl schemas=myuser directory=dpump_dir1 dumpfile=myuser_single.dmp logfile=myuser_dump_single.log
```


Import dump file in a PDB.  
From the shell prompt:  

```sh
impdp dest_user/dest_pass@pdb_db1 directory=dpump_dir1 dumpfile=myuser_pdb.dmp logfile=my_db_dump.log remap_tablespace=dump_ts_name:dest_ts_name full=y

#or (preferred and more specific)

impdp dest_user/dest_pass@pdb_db1 directory=dpump_dir1 dumpfile=myuser_pdb.dmp logfile=my_db_dump.log remap_tablespace=dump_ts_name:dest_ts_name remap_schema=source_user:dest_user
```


Import with optional parfile in non-cdb database.  

```sh
impdp dest_user/dest_pass@orcl schemas=source_user directory=dpump_dir1 dumpfile=myuser_single.dmp logfile=db_dump.log remap_schema=source_user:dest_user parfile=params.par
```

Parfile contents:

```
EXCLUDE=PACKAGE:"='SOME_PACKAGE'"
EXCLUDE=USER:"='source_user'"
TRANSFORM=OID:N
```



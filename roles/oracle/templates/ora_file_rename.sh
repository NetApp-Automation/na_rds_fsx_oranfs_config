#/usr/bin/sh
# Description: Relocate RDS database from EBS storage to FSx storage. Keep RDS binary on EBS storage /rdsdbbin.
# The script search Oracle databases in /etc/oratab file in "running mode or Y" on RDS EC2 host and shutdown DB,
# then move all data files to FSx data volume and change log archive destination to FSx log volume. 

ORATAB=/etc/oratab
if [ ! -f $ORATAB ]
then
        exit 1
fi

grep ".*:.*:Y" /etc/oratab | while read line
  do
     ORACLE_SID=`echo $line | awk -F ":" '{print $1}'`
     ORACLE_HOME=`echo $line | awk -F ":" '{print $2}'`
     export ORACLE_SID
     export ORACLE_HOME
     export PATH=$PATH:$ORACLE_HOME/bin
     $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" <<!>> db_rename
     whenever sqlerror exit SQL.SQLCODE
     startup mount pfile='/rdsdbdata/admin/{{ db_name }}/pfile/init{{ db_name }}.ora';
     set pagesize 0
     set head off
     set feed off
     set echo off
     set verify off
     spool {{ script_dir }}/file_move.sql
     select 'alter database rename file',''''||name||'''', 'to ''/{{ ora_volumes_nfs[0] }}/db/{{ db_unique_name }}/datafile/'||LTRIM(name, '/rdsdbdata/db/{{ db_unique_name }}/datafile')||''''||';' from v\$datafile 
     union
     select 'alter database rename file',''''||name||'''', 'to ''/{{ ora_volumes_nfs[0] }}/db/{{ db_unique_name }}/datafile/'||LTRIM(name, '/rdsdbdata/db/{{ db_unique_name }}/datafile')||''''||';' from v\$tempfile
     union
     select 'alter database rename file',''''||member||'''', 'to ''/{{ ora_volumes_nfs[0] }}/db/{{ db_unique_name }}/'||LTRIM(member,'/rdsdbdata/db/{{ db_unique_name }}/')||''''||';' from v\$logfile
     /
     spool off
     @{{ script_dir }}/file_move.sql
     alter database open; 
     create spfile='/rdsdbdata/admin/{{ db_name }}/pfile/spfile{{ db_name }}.ora' from pfile='/rdsdbdata/admin/{{ db_name }}/pfile/init{{ db_name }}.ora';
     shutdown immediate;
     startup;
     exit;
!
  done

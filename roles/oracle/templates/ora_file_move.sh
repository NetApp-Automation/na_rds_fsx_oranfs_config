#/usr/bin/sh
# Description: Shutdown RDS Oracle instance before data files relocation.

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
     $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" <<!>> db_shut
     whenever sqlerror exit SQL.SQLCODE
     shutdown abort;
     exit;
!
     cp /rdsdbdata/db/{{ db_unique_name }}/arch/* {{ db_dirs[0] }}/ 
     mv /rdsdbdata/db/{{ db_unique_name }}/controlfile/* {{ db_dirs[1] }}/ 
     mv /rdsdbdata/db/{{ db_unique_name }}/datafile/* {{ db_dirs[2] }}/ 
     mv /rdsdbdata/db/{{ db_unique_name }}/onlinelog/* {{ db_dirs[3] }}/ 
  done

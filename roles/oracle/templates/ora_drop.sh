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
     $ORACLE_HOME/bin/sqlplus -s "/ as sysdba" <<!>> db_drop
     whenever sqlerror exit SQL.SQLCODE
     shutdown abort;
     startup mount exclusive restrict;
     drop database;
!
  done

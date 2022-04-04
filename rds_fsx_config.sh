#!/usr/bin/bash

# The purpose of this script is to configure FSX for ONTAP storage for Oracle RDS custom instance. It is supposed to be executed right   
# after Oracle RDS custom instance deployment via RDS console. By executing this script, default EBS data volume for the underlined Oracle
# database is swapped out and FSX for ONTAP storage is swapped in as main storage engine. Depending on the choice of storage protocol
# FSX storage is either mounted via NFS or iSCSI. The RDS Oracle database data files and archive log are relocated to FSX volumes from EBS 
# volume while RDS automation is paused. RDS automation is renabled at the completion of script execution. AJC 03/16/2022

LOG=/home/ec2-user/na_rds_fsx_oranfs_config/logs/rds_fsx_config-`date +"%Y-%m%d-%H%M.%S"`.log

echo "Start RDS FSX configuration at `date +"%Y-%m%d-%H%M.%S"`" >> $LOG

echo "Install or update prerequsites and Ansible at `date +"%Y-%m%d-%H%M.%S"` -----> " >> $LOG
sudo yum -y install python3
sudo yum -y install python3-pip
sudo python3 -m pip install -U pip
python3 -W ignore -m pip --disable-pip-version-check install ansible 
ansible-galaxy collection install netapp.ontap

echo "Execute FSx configuration playbook at `date +"%Y-%m%d-%H%M.%S"` -----> " >> $LOG
cd /home/ec2-user/na_rds_fsx_config
ansible-playbook -i hosts rds_fsx_config.yml -u ec2-user --private-key ora-database-1.pem -e @vars/fsx_vars.yml

echo "End RDS FSX configuration at `date +"%Y-%m%d-%H%M.%S"`" >> $LOG

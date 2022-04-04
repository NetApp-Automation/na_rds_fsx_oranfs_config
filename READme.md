na_rds_fsx_oranfs_config
=========

This is an archive of Ansible tasks used to configure a AWS RDS Custom for Oracle instance with FSx storage as its primary database storage with NFS protocol after initial RDS Custom for Oracle provision via AWS RDS console.

    Automated solutions built over these tasks are available in the na_rds_fsx_oranfs_config playbook.
    Refer to individual solutions READme.md file for instructions for use of respective solutions.

License
-------

By accessing, downloading, installing or using the content in this repository, you agree the terms of the License laid out in [License](LICENSE.TXT) file.

Note that there are certain restrictions around producing and/or sharing any derivative works with the content in this repository. Please make sure you read the terms of the [License](LICENSE.TXT) before using the content. If you do not agree to all of the terms, do not access, download or use the content in this repository.

Requirements
------------

    Ansible version: 2.10 and above
    Python 3
    Python libraries:
    netapp-lib
    xmltodict
    jmespath

    AWS FSx storage service

    RDS Custom for Oracle

Variables
---------

For detailed instructions for running the playbook refer to NetAppDocs https://docs.netapp.com/us-en/netapp-solutions/ent-db/aws_rds_ora_custom_deploy_intro.html

######################################################################
###### Oracle RDS custom configuration for FSx storage var file ######
###### Consolidate all variables from ontap, linux and oracle   ######
######################################################################

###########################################
### Ontap env specific config variables ###
###########################################

# SVM Management LIF and NFS LIF
svm_mgmt_nfs_lif: 198.19.255.68

# NFS storage volumes when data protocol used is NFS. Volumes names should match with what are created from FSx console
# ora_nfs_data - Oracle data
# ora_nfs_log  - Oracle redo
ora_volumes_nfs:
  - ora_nfs_data
  - ora_nfs_log

###########################################
### Linux env specific config variables ###
###########################################


####################################################
### DB env specific install and config variables ###
####################################################

# RDS Database parameters: default DB name ORCL, make change if a new DB name is set during RDS instance provision.
db_name: NTAP2
db_unique_name: "{{ db_name }}_A"


Execution Instructions
---------
    Follow the detailed instructions as outlined in https://docs.netapp.com/us-en/netapp-solutions/ent-db/aws_rds_ora_custom_deploy_intro.html
       
    For execution on RDS instance EC2 host or a EC2 Linux host as Ansible controller within VPC
    
    	Clone the code: git clone https://github.com/NetApp-Automation/na_rds_fsx_oranfs_config.git
        cd na_rds_fsx_oranfs_config
        
        Fill in the fsx_vars.yml files with relevant environment variables, RDS host access key pair, Oracle RDS host IP address.
    
    	FSx configuration:
        	./rds_fsx_config.sh
        
        Preclone configuration:
        	./rds_preclone_config.sh

Tags Info
---------
	linux_config: RDS EC2 host kernel configuration
    oracle_config: RDS Oracle database configuration

Author Information
------------------

NetApp Solutions Automation Team

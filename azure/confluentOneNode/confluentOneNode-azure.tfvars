# Reference existing vnet
vnet_rg_name="resourceGroupContainingTheMasterVNET"
vnet_name="MasterVNETname"
subnet_name="subnetNameForThisDeployment"
subnet_prefix="e.g. 10.135.30"
address_prefix="CDIRsubnet, e.g. 10.135.20.0/24"
#
location="West Europe"
rg_name="resourceGroupForThisDeployment"
prefix="prefixForAllResources e.g. uidogg4bd1"
storage_acc="storageAccountForThisDeployment, e.g. uidogg4bd1sa"
storage_type="Premium_LRS"
adminuser="adminUserId e.g. uid"
#
cluster_size=3
prox_cluster_size=2
cc_cluster_size=1
adminuser="atu045"
vmsize="Standard_DS2"
vmpublisher = "RedHat"
vmoffer = "RHEL"
vmsku = "7.3"
vmversion = "latest"
#
pubkeyfilelocation=~/.ssh
pubkeyfile=terra_key.pub
privkeyfilelocation=~/.ssh
privkeyfile=id_rsa
#
buildscriptlocation=~/mgis-architect/confluentOneNode
buildscript=confluentOneNode-build.sh
buildinifilelocation=~/atu045
buildinifile=confluentOneNode-build.ini

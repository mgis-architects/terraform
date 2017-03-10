# Reference existing vnet
vnet_rg_name="resourceGroupContainingTheMasterVNET"
vnet_name="MasterVNETname"
subnet_name="subnetNameForThisDeployment"
address_prefix="CDIRsubnet, e.g. 10.135.25.0/24"
#
location="West Europe"
rg_name="resourceGroupForThisDeployment"
prefix="prefixForAllResources e.g. uidcassandra1"
storage_acc="storageAccountForThisDeployment, e.g. uidcassandra1sa"
storage_type="Premium_LRS"
adminuser="adminUserId e.g. uid"
vmsize="Standard_DS1_v2"
vmpublisher = "RedHat"
vmoffer = "RHEL"
vmsku = "7.3"
vmversion = "latest"

#
pubkeyfilelocation="~/.ssh"
pubkeyfile="terra_key.pub"
privkeyfilelocation="~/.ssh"
privkeyfile="id_rsa"
#
buildscriptlocation="~/mgis-architect/cassandra"
buildscript="cassandra-build.sh"
buildinifilelocation="~/atu045"
buildinifile="cassandra-build.ini"


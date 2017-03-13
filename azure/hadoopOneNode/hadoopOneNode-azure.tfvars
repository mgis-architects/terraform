# Reference existing vnet
vnet_rg_name="resourceGroupContainingTheMasterVNET"
vnet_name="MasterVNETname"
subnet_name="subnetNameForThisDeployment"
address_prefix="CDIRsubnet, e.g. 10.135.20.0/24"
#
location="West Europe"
rg_name="resourceGroupForThisDeployment"
prefix="prefixForAllResources e.g. uidhadoop11"
storage_acc="storageAccountForThisDeployment, e.g. uidhadoop11sa"
storage_type="Premium_LRS"
adminuser="adminUserId e.g. uid"
vmsize="Standard_DS3_v2"
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
buildscriptlocation="~/mgis-architect/hadoopOneNode"
buildscript="hadoopOneNode-build.sh"
buildinifilelocation="~/privatefiles"
buildinifile="hadoopOneNode-build.ini"
#
#testsuitescriptlocation="~/mgis-architect/hadoopOneNode"
#testsuitescript="hadoopOneNode-testsuite.sh"
#testsuiteinifilelocation="~/privatefiles"
#testsuiteinifile="hadoopOneNode-testsuite.ini"
#

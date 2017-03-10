# Reference existing vnet
vnet_rg_name="resourceGroupContainingTheMasterVNET"
vnet_name="MasterVNETname"
subnet_name="subnetNameForThisDeployment"
address_prefix="CDIRsubnet, e.g. 10.135.20.0/24"
#
location="West Europe"
rg_name="resourceGroupForThisDeployment"
prefix="prefixForAllResources e.g. uidogg4bd1"
storage_acc="storageAccountForThisDeployment, e.g. uidogg4bd1sa"
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
buildscriptlocation="~/mgis-architect/ogg4bd"
buildscript="ogg4bd-build.sh"
buildinifilelocation="~/privatefiles"
buildinifile="ogg4bd-build.ini"
#
testsuitescriptlocation="~/mgis-architect/ogg4bd"
testsuitescript="ogg4bd-testsuite.sh"
testsuiteinifilelocation="~/privatefiles"
testsuiteinifile="ogg4bd-testsuite.ini"


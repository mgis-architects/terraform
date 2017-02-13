# Reference existing vnet
vnet_rg_name="atu045dev_rg"
vnet_name="atu045dev-VN"
subnet_name="atu045dev-subnet1"
address_prefix="10.135.3.0/24"
#
location="West Europe"
rg_name="atu045-confluent-rg"
cluster_size=3
prefix="atu045confluent"
storage_acc="atu045confluentsa"
adminuser="atu045"
vmsize="Standard_DS2"
vmpublisher = "RedHat"
vmoffer = "RHEL"
vmsku = "7.3"
vmversion = "latest"

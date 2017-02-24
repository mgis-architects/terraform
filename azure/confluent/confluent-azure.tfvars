# Reference existing vnet
vnet_rg_name="<existing_resource_group>"
vnet_name="<vnet_within_existing_resource_group>"
subnet_name="<new_subnet_name_to_create_within_vnet>"
address_prefix="10.9.3.0/24"
#
location="West Europe"
rg_name="<userid>-confluent-rg"
cluster_size=3
prox_cluster_size=2
cc_cluster_size=1
prefix="<userid>confluent"
storage_acc="<userid>confluentsa"
adminuser="<userid>"
vmsize="Standard_DS2"
vmpublisher = "RedHat"
vmoffer = "RHEL"
vmsku = "7.3"
vmversion = "latest"

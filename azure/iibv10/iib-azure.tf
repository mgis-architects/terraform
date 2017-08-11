
#######################################################################################################
# Variables
#####################################################################################################
variable "subscriptionid" {}
variable "appid" {}
variable "apppassword" {}
variable "tenantid" {}
variable "location" {}
variable "rg_name" {}
#variable "vlan_name" {}
variable "vnet_rg_name" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "address_prefix" {}
variable "subnet_prefix" {}
#variable "cluster_size" {}
#variable "prox_cluster_size" {}
#variable "cc_cluster_size" {}
variable "prefix" {}
variable "storage_acc" {}
variable "adminuser" {}
variable "vmsize" {}
variable "vmpublisher" {}
variable "vmoffer" {}
variable "vmsku"{} 
variable "vmversion" {}
#
variable "mqFileLoc" {}
variable "mqZipFile" {}
variable "mqMD5" {}
#

#######################################################################################################
# Configure the Microsoft Azure Provider
#######################################################################################################
provider "azurerm" {
   subscription_id = "${var.subscriptionid}"
   client_id       = "${var.appid}"
   client_secret   = "${var.apppassword}"
   tenant_id       = "${var.tenantid}"
}

#######################################################################################################
# Resource group
#######################################################################################################
resource "azurerm_resource_group" "resource_group" {
    name     = "${var.rg_name}"
    location = "${var.location}"
    lifecycle { 
	prevent_destroy=true
    }
}
 
resource "azurerm_availability_set" "availability_group_iib1" {
    name = "${var.prefix}-ag-IIB1"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_availability_set" "availability_group_iib2" {
    name = "${var.prefix}-ag-IIB2"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}


#######################################################################################################
# Network
#######################################################################################################
# # Create a virtual network in the web_servers resource group
# resource "azurerm_virtual_network" "network" {
#   name                = "${var.vlan_name}"
#   address_space       = ["10.135.0.0/16"]
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.resource_group.name}"
# }

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${var.vnet_rg_name}"
  virtual_network_name = "${var.vnet_name}"
  address_prefix       = "${var.address_prefix}"
}

# IIB MQ     10.9.40.4, 10.9.40.5
# WIndows    10.9.40.6

resource "azurerm_network_interface" "nic_iib1" {
  name                = "${var.prefix}-ip-iib1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-iib1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.4"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm1.id}"]
  }
}

resource "azurerm_network_interface" "nic_iib2" {
  name                = "${var.prefix}-ip-iib2"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-iib2"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.5"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm2.id}"]
  }
}


resource "azurerm_public_ip" "iib3" {
  name                = "${var.prefix}-ip-iib3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "nic_iib3" {
  name                = "${var.prefix}-ip-iib3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-iib3"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.6"
    public_ip_address_id          = "${azurerm_public_ip.iib3.id}"

#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm6.id}"]
  }
}



#######################################################################################################
# Public load balancer
# - Note the backend_address_pool is mapped to servers via the nic definition above
#######################################################################################################
#resource "azurerm_public_ip" "pubip" {
#    name = "${var.prefix}_pubip"
#    location = "${var.location}"
#    resource_group_name = "${azurerm_resource_group.resource_group.name}"
#    public_ip_address_allocation = "static"
#    domain_name_label = "${azurerm_resource_group.resource_group.name}"
#}

#resource "azurerm_lb" "load_balancer" {
#    name = "${var.prefix}_lb"
#    location = "${var.location}"
#    resource_group_name = "${azurerm_resource_group.resource_group.name}"
#
#    frontend_ip_configuration {
#      name = "${var.prefix}_pubip-frontend"
#      public_ip_address_id = "${azurerm_public_ip.pubip.id}"
#    }
#}

######################################### mmo275mq-cluster-mq1
#resource "azurerm_lb_backend_address_pool" "qm1" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm1"
#}
#
#resource "azurerm_lb_rule" "qm1-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm1-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21414
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm1.id}"
#  probe_id                       = "${azurerm_lb_probe.qm1-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm1-probe"]
#}

#resource "azurerm_lb_probe" "qm1-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-full-qm1-1414"
#  port                = 1414
#}  
#

######################################## mmo275mq-cluster-mq2
#resource "azurerm_lb_backend_address_pool" "qm2" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm2"
#}

#resource "azurerm_lb_rule" "qm2-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm2-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21415
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm2.id}"
#  probe_id                       = "${azurerm_lb_probe.qm2-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm2-probe"]
#}

#resource "azurerm_lb_probe" "qm2-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-full-qm2-1414"
#  port                = 1414
#}


######################################## mmo275mq-cluster-mq3
#resource "azurerm_lb_backend_address_pool" "qm3" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm3"
#}

#resource "azurerm_lb_rule" "qm3-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm3-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21416
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm3.id}"
#  probe_id                       = "${azurerm_lb_probe.qm3-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm3-probe"]
#}

#resource "azurerm_lb_probe" "qm3-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm3-1414"
#  port                = 1414
#}

######################################## mmo275mq-cluster-mq4
#resource "azurerm_lb_backend_address_pool" "qm4" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm4"
#}
#
#resource "azurerm_lb_rule" "qm4-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm4-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21417
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm4.id}"
#  probe_id                       = "${azurerm_lb_probe.qm4-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm4-probe"]
#}

#resource "azurerm_lb_probe" "qm4-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm4-1414"
#  port                = 1414
#}

######################################## mmo275mq-cluster-mq5
#resource "azurerm_lb_backend_address_pool" "qm5" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm5"
#}

#resource "azurerm_lb_rule" "qm5-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm5-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21418
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm5.id}"
#  probe_id                       = "${azurerm_lb_probe.qm5-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm5-probe"]
#}

#resource "azurerm_lb_probe" "qm5-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm5-1414"
#  port                = 1414
#}

######################################## mmo275mq-cluster-mq6
#resource "azurerm_lb_backend_address_pool" "qm6" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm6"
#}
#
#resource "azurerm_lb_rule" "qm6-1414-rule" {
#  location                       = "${var.location}"
#  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
#  name                           = "${var.prefix}-qm6-rule"
#  protocol                       = "Tcp"
#  frontend_port                  = 21419
#  backend_port                   = 1414
#  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
#  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.qm6.id}"
#  probe_id                       = "${azurerm_lb_probe.qm6-probe.id}"
#  depends_on                     = ["azurerm_lb_probe.qm6-probe"]
#}

#resource "azurerm_lb_probe" "qm6-probe" {
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.resource_group.name}"
#  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
#  name                = "${var.prefix}-cluster-qm6-1414"
#  port                = 1414
#}

#######################################################################################################
# Storage Account
#######################################################################################################
resource "azurerm_storage_account" "iibsa" {
  name                = "${var.storage_acc}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  account_type        = "Premium_LRS"

  tags {
    prefix = "staging"
  }
}

resource "azurerm_storage_container" "sc1" {
  name                  = "${var.prefix}-container-1"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.iibsa.name}"
  container_access_type = "private"
}


#MQ / IIB
resource "azurerm_virtual_machine" "iib1" {
  name                  = "${var.prefix}-vm-iib1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_iib1.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_iib1.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-iib1-osdisk"
    vhd_uri       = "${azurerm_storage_account.iibsa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-iib1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-iib1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.iibsa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-iib1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-iib1"
    admin_username = "${var.adminuser}"
    admin_password = "not@used@hopefully!"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.adminuser}/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/terra_key.pub")}"
    }
  }

#    host = "${azurerm_network_interface.nic.private_ip_address}"

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.4"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

#   provisioner "file" { 
#     source = "../../../mqv8/MQv8FP0006.zip" 
#     destination = "/home/${var.adminuser}/MQv8FP0006.zip"
#   } 

#   provisioner "file" {
#     source = "../../../mqv8/MQv8FP0006.zip.md5"
#     destination = "/home/${var.adminuser}/MQv8FP0006.zip.md5"
#   }

#  provisioner "file" {
#     source = "../../../mqv8/unzipMQv8_FP0006.sh"
#     destination = "/home/${var.adminuser}/unzipMQv8_FP0006.sh"
#   }


#   provisioner "file" { 
#     source = "~/confluent-build.ini" 
#     destination = "/home/${var.adminuser}/confluent-build.ini" 
#   } 

#   provisioner "remote-exec" { 
#     inline = [  
#        "sudo /bin/bash /home/${var.adminuser}/kafka-build.sh /home/${var.adminuser}/confluent-build.ini 1 2>&1 |tee /home/${var.adminuser}/remoteExec.kafka-build.log"
#     ] 
#   } 

}


#MQ / IIB
resource "azurerm_virtual_machine" "iib2" {
  name                  = "${var.prefix}-vm-iib2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_iib2.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_iib2.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-iib2-osdisk"
    vhd_uri       = "${azurerm_storage_account.iibsa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-iib2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-iib2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.iibsa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-iib2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-iib2"
    admin_username = "${var.adminuser}"
    admin_password = "not@used@hopefully!"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.adminuser}/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/terra_key.pub")}"
    }
  }

#    host = "${azurerm_network_interface.nic.private_ip_address}"

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.5"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

#   provisioner "file" {
#     source = "../../../confluent/kafka-build.sh"
#     destination = "/home/${var.adminuser}/kafka-build.sh"
#   }

#   provisioner "file" {
#     source = "~/confluent-build.ini"
#     destination = "/home/${var.adminuser}/confluent-build.ini"
#   }

#   provisioner "remote-exec" {
#     inline = [
#        "sudo /bin/bash /home/${var.adminuser}/kafka-build.sh /home/${var.adminuser}/confluent-build.ini 2 2>&1 |tee /home/${var.adminuser}/remoteExec.kafka-build.log"
#     ]
#   }

}


#Win Jumpbox
resource "azurerm_virtual_machine" "iibwin" {
  name                  = "${var.prefix}-vm-iibwin1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_iib3.id}"]
  vm_size               = "Standard_DS1"
  availability_set_id   = "${azurerm_availability_set.availability_group_iib1.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-DataCenter"
    version   = "latest"
  }

 storage_os_disk {
    name          = "${var.prefix}-vm-iibwin-osdisk"
    vhd_uri       = "${azurerm_storage_account.iibsa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-iibwin-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

 os_profile {
    computer_name  = "MQJumpServer"
    admin_username = "iibadmin"
    admin_password = "Passw0rd!"
    
  }


}



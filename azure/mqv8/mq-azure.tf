
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
 
resource "azurerm_availability_set" "availability_group_a" {
    name = "${var.prefix}-ag-A"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_availability_set" "availability_group_b" {
    name = "${var.prefix}-ag-B"
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

# MQ Full    10.9.20.4, 10.9.20.5
# MQ Part    10.9.20.6, 10.9.20.7, 10.9.20.8, 10.9.20.9
# WIndows    10.9.30.1

resource "azurerm_network_interface" "nic_A" {
  name                = "${var.prefix}-ip-mq1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.4"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm1.id}"]
  }
}

resource "azurerm_network_interface" "nic_B" {
  name                = "${var.prefix}-ip-mq2"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq2"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.5"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm2.id}"]
  }
}

resource "azurerm_network_interface" "nic_C" {
  name                = "${var.prefix}-ip-mq3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq3"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.6"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm3.id}"]
  }
}


resource "azurerm_network_interface" "nic_D" {
  name                = "${var.prefix}-ip-mq4"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq4"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.7"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm4.id}"]
  }
}

resource "azurerm_network_interface" "nic_E" {
  name                = "${var.prefix}-ip-mq5"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq5"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.8"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm5.id}"]
  }
}

resource "azurerm_network_interface" "nic_F" {
  name                = "${var.prefix}-ip-mq6"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-mq6"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.9"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.qm6.id}"]
  }
}


resource "azurerm_public_ip" "win1" {
  name                = "${var.prefix}-ip-win1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "nic_G" {
  name                = "${var.prefix}-ip-win"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-win1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.50"
    public_ip_address_id          = "${azurerm_public_ip.win1.id}"

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
resource "azurerm_storage_account" "sa" {
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
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}


#MQ Full Repository 1
resource "azurerm_virtual_machine" "mqfull1" {
  name                  = "${var.prefix}-vm-mq1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_A.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_a.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-mq1-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-mq1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-mq1"
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

  provisioner "file" {
     source = "../../../mqv8/checkForMQZipFile.sh"
     destination = "/home/${var.adminuser}/checkForMQZipFile.sh"
   }

  provisioner "file" { 
     source = "../../../mqv8/MQv8FP0006.zip" 
     destination = "/home/${var.adminuser}/MQv8FP0006.zip"
   } 

  provisioner "file" {
     source = "../../../mqv8/MQv8FP0006.zip.md5"
     destination = "/home/${var.adminuser}/MQv8FP0006.zip.md5"
   }

  provisioner "file" {
     source = "../../../mqv8/unzipMQv8_FP0006.sh"
     destination = "/home/${var.adminuser}/unzipMQv8_FP0006.sh"
   }


  provisioner "file" { 
     source = "~/unzipMQv8_FP0006.ini" 
     destination = "/home/${var.adminuser}/unzipMQv8_FP0006.ini" 
   } 

   provisioner "remote-exec" { 
     inline = [  
        "sudo /bin/bash /home/${var.adminuser}/unzipMQv8_FP0006.sh /home/${var.adminuser}/unzipMQv8_FP0006.ini TSTQFD01 2>&1 |tee /home/${var.adminuser}/remoteExec.kafka-build.log"
     ] 
   } 

}


#MQ Full Repository 2
resource "azurerm_virtual_machine" "mqfull2" {
  name                  = "${var.prefix}-vm-mq2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_B.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_b.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-mq2-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-mq2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-mq2"
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

  provisioner "file" {
     source = "../../../mqv8/checkForMQZipFile.sh"
     destination = "/home/${var.adminuser}/checkForMQZipFile.sh"
   }

  provisioner "file" {
     source = "../../../mqv8/MQv8FP0006.zip"
     destination = "/home/${var.adminuser}/MQv8FP0006.zip"
   }

  provisioner "file" {
     source = "../../../mqv8/MQv8FP0006.zip.md5"
     destination = "/home/${var.adminuser}/MQv8FP0006.zip.md5"
   }

  provisioner "file" {
     source = "../../../mqv8/unzipMQv8_FP0006.sh"
     destination = "/home/${var.adminuser}/unzipMQv8_FP0006.sh"
   }

  provisioner "file" {
     source = "~/unzipMQv8_FP0006.ini"
     destination = "/home/${var.adminuser}/unzipMQv8_FP0006.ini"
   }

  provisioner "remote-exec" {
     inline = [
        "sudo /bin/bash /home/${var.adminuser}/unzipMQv8_FP0006.sh /home/${var.adminuser}/unzipMQv8_FP0006.ini TSTQFD02 2>&1 |tee /home/${var.adminuser}/remoteExec.kafka-build.log"
     ]
   }


}

#MQ Partial Repository 1
resource "azurerm_virtual_machine" "mqpart1" {
  name                  = "${var.prefix}-vm-mq3"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_C.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_a.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-mq3-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq3-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-mq3-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq3-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-mq3"
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

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.6"
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
#        "sudo /bin/bash /home/${var.adminuser}/kafka-build.sh /home/${var.adminuser}/confluent-build.ini 3 2>&1 |tee /home/${var.adminuser}/remoteExec.kafka-build.log"
#     ]
#   }

}



#MQ Partial Repository 2
resource "azurerm_virtual_machine" "mqpart2" {
  name                  = "${var.prefix}-vm-mq4"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_D.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_b.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-mq4-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq4-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-mq4-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq4-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-mq4"
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

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.7"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

#   provisioner "file" {
#     source = "../../../confluent/schema-build.sh"
#     destination = "/home/${var.adminuser}/schema-build.sh"
#   }

#   provisioner "file" {
#     source = "~/confluent-build.ini"
#     destination = "/home/${var.adminuser}/confluent-build.ini"
#   }

#   provisioner "remote-exec" {
#     inline = [
#        "sudo /bin/bash /home/${var.adminuser}/schema-build.sh /home/${var.adminuser}/confluent-build.ini 1 2>&1 |tee /home/${var.adminuser}/remoteExec.schema-build.log"
#     ]
#   }

}

#MQ Partial Repository 3
resource "azurerm_virtual_machine" "mqpart3" {
  name                  = "${var.prefix}-vm-mq5"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_E.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_a.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-mq5-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq5-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-mq5-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq5-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-mq5"
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

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.8"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

#   provisioner "file" {
#     source = "../../../confluent/schema-build.sh"
#     destination = "/home/${var.adminuser}/schema-build.sh"
#   }

#   provisioner "file" {
#     source = "~/confluent-build.ini"
#     destination = "/home/${var.adminuser}/confluent-build.ini"
#   }

#   provisioner "remote-exec" {
#     inline = [
#        "sudo /bin/bash /home/${var.adminuser}/schema-build.sh /home/${var.adminuser}/confluent-build.ini 2 2>&1 |tee /home/${var.adminuser}/remoteExec.schema-build.log"
#     ]
#   }

}

#MQ Partial Repository 4
resource "azurerm_virtual_machine" "mqpart4" {
  name                  = "${var.prefix}-vm-mq6"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_F.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group_b.id}"
    
  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }
    
  storage_os_disk { 
    name          = "${var.prefix}-vm-mq6-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq6-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
    
  storage_data_disk {
    name          = "${var.prefix}-vm-mq6-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-mq6-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }
    
  os_profile {
    computer_name  = "${var.prefix}-vm-mq6"
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

  connection {
    user = "${var.adminuser}"
    host = "${var.subnet_prefix}.9"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

#   provisioner "file" {
#     source = "../../../confluent/cc-build.sh"
#     destination = "/home/${var.adminuser}/cc-build.sh"
#   }

#   provisioner "file" {
#     source = "~/confluent-build.ini"
#     destination = "/home/${var.adminuser}/confluent-build.ini"
#   }

#   provisioner "remote-exec" {
#     inline = [
#        "sudo /bin/bash /home/${var.adminuser}/cc-build.sh /home/${var.adminuser}/confluent-build.ini 1 2>&1 |tee /home/${var.adminuser}/remoteExec.cc-build.log"
#     ]
#   }

}


#MQ Partial Repository 4
resource "azurerm_virtual_machine" "win" {
  name                  = "${var.prefix}-vm-win1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_G.id}"]
  vm_size               = "Standard_DS1"
  availability_set_id   = "${azurerm_availability_set.availability_group_a.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-DataCenter"
    version   = "latest"
  }

 storage_os_disk {
    name          = "${var.prefix}-vm-win-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-win-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

 os_profile {
    computer_name  = "MQJumpServer"
    admin_username = "mqadmin"
    admin_password = "Q1&Gha37bc&£lKjk"
    
  }


}



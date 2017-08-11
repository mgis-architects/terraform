
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
variable "cluster_size" {}
variable "prox_cluster_size" {}
variable "cc_cluster_size" {}
variable "prefix" {}
variable "storage_acc" {}
variable "adminuser" {}
variable "vmsize" {}
variable "vmpublisher" {}
variable "vmoffer" {}
variable "vmsku"{} 
variable "vmversion" {}

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
 
resource "azurerm_availability_set" "availability_group" {
    name = "${var.prefix}-ag"
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

resource "azurerm_network_interface" "nic_A" {
  name                = "${var.prefix}-ip-zk1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-zk1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.4"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_B" {
  name                = "${var.prefix}-ip-zk2"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-zk2"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.5"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_C" {
  name                = "${var.prefix}-ip-zk3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-zk3"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.6"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}


resource "azurerm_network_interface" "nic_D" {
  name                = "${var.prefix}-ip-kf1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-kf1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.7"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_E" {
  name                = "${var.prefix}-ip-kf2"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-kf2"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.8"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_F" {
  name                = "${var.prefix}-ip-kf3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-kf3"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.9"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_G" {
  name                = "${var.prefix}-ip-pr1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-pr1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.10"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_controlcentre_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_H" {
  name                = "${var.prefix}-ip-pr2"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-pr2"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.11"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_network_interface" "nic_I" {
  name                = "${var.prefix}-ip-pr3"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-pr3"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.subnet_prefix}.12"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}



#######################################################################################################
# Public load balancer
# - Note the backend_address_pool is mapped to servers via the nic definition above
#######################################################################################################
resource "azurerm_public_ip" "pubip" {
    name = "${var.prefix}_pubip"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    public_ip_address_allocation = "static"
    domain_name_label = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_lb" "load_balancer" {
    name = "${var.prefix}_lb"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    frontend_ip_configuration {
      name = "${var.prefix}_pubip-frontend"
      public_ip_address_id = "${azurerm_public_ip.pubip.id}"
    }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "${var.prefix}-backend_address_pool"
}

# MJM
resource "azurerm_lb_backend_address_pool" "backend_controlcentre_pool" {
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "${var.prefix}-backend_controlcentre_pool"
}

resource "azurerm_lb_rule" "load_balancer_http_rule" {
  location                       = "${var.location}"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe.id}"
  depends_on                     = ["azurerm_lb_probe.load_balancer_probe"]
}

resource "azurerm_lb_rule" "load_balancer_https_rule" {
  location                       = "${var.location}"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  name                           = "HTTPSRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe.id}"
  depends_on                     = ["azurerm_lb_probe.load_balancer_probe"]
}

# MJM
resource "azurerm_lb_rule" "load_balancer_controlcentre_rule" {
  location                       = "${var.location}"
  resource_group_name            = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  name                           = "ControlCentreRule"
  protocol                       = "Tcp"
  frontend_port                  = 9021
  backend_port                   = 9021
  frontend_ip_configuration_name = "${var.prefix}_pubip-frontend"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_controlcentre_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_controlcentre_probe.id}"
  depends_on                     = ["azurerm_lb_probe.load_balancer_controlcentre_probe"]
}


resource "azurerm_lb_probe" "load_balancer_probe" {
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "HTTP"
  port                = 80
}  

# MJM
resource "azurerm_lb_probe" "load_balancer_controlcentre_probe" {
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "ControlCentre"
  port                = 9021
}


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


#Zookeeper - Server1
resource "azurerm_virtual_machine" "zkvm1" {
  name                  = "${var.prefix}-vm-zk1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_A.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-zk1-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-zk1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-zk1"
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
    host = "${var.subnet_prefix}.4"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

   provisioner "file" { 
     source = "../../../confluent/standalone-zookeeper-server.sh" 
     destination = "/home/${var.adminuser}/standalone-zookeeper-server.sh"
   } 

   provisioner "file" { 
     source = "~/standalone-server-build.ini" 
     destination = "/home/${var.adminuser}/standalone-server-build.ini" 
   } 

   #provisioner "remote-exec" { 
   #  inline = [  
   #     "sudo /bin/bash /home/${var.adminuser}/standalone-zookeeper-server.sh /home/${var.adminuser}/standalone-server-build.ini 1 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-zookeeper-server.log"
   #  ] 
   #} 

}


#Zookeeper - Server2
resource "azurerm_virtual_machine" "zkvm2" {
  name                  = "${var.prefix}-vm-zk2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_B.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-zk2-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-zk2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-zk2"
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
    host = "${var.subnet_prefix}.5"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

   provisioner "file" {
     source = "../../../confluent/standalone-zookeeper-server.sh"
     destination = "/home/${var.adminuser}/standalone-zookeeper-server.sh"
   }

   provisioner "file" {
     source = "~/standalone-server-build.ini"
     destination = "/home/${var.adminuser}/standalone-server-build.ini"
   }

   #provisioner "remote-exec" {
   #  inline = [
   #     "sudo /bin/bash /home/${var.adminuser}/standalone-zookeeper-server.sh /home/${var.adminuser}/standalone-server-build.ini 2 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-zookeeper-server.log"
   #  ]
   #}

}

#Zookeeper - Server3
resource "azurerm_virtual_machine" "zkvm3" {
  name                  = "${var.prefix}-vm-zk3"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_C.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-zk3-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk3-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-zk3-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-zk3-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-zk3"
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

   provisioner "file" {
     source = "../../../confluent/standalone-zookeeper-server.sh"
     destination = "/home/${var.adminuser}/standalone-zookeeper-server.sh"
   }

   provisioner "file" {
     source = "~/standalone-server-build.ini"
     destination = "/home/${var.adminuser}/standalone-server-build.ini"
   }

   #provisioner "remote-exec" {
   #  inline = [
   #     "sudo /bin/bash /home/${var.adminuser}/standalone-zookeeper-server.sh /home/${var.adminuser}//standalone-server-build.ini 3 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-zookeeper-server.log"
   #  ]
   #}

}


#Kafka - Server1
resource "azurerm_virtual_machine" "kfvm1" {
  name                  = "${var.prefix}-vm-kf1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_D.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-kf1-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-kf1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-kf1"
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

   provisioner "file" {
     source = "../../../confluent/kafka-generate-ssl.sh"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.sh"
   }

   provisioner "file" {
     source = "~/kafka-generate-ssl.ini"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.ini"
   }

   provisioner "file" {
     source = "../../../confluent/standalone-kafka-server.sh"
     destination = "/home/${var.adminuser}/standalone-kafka-server.sh"
   }

   provisioner "file" {
     source = "~/standalone-server-build.ini"
     destination = "/home/${var.adminuser}/standalone-server-build.ini"
   }
#
  #provisioner "remote-exec" {
  #   inline = [
  #      "sudo /bin/bash /home/${var.adminuser}/standalone-kafka-server.sh /home/${var.adminuser}/standalone-server-build.ini 1 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-kafka-server.log"
  #   ]
  # }

}


#Kafka - Server2
resource "azurerm_virtual_machine" "kfvm2" {
  name                  = "${var.prefix}-vm-kf2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_E.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-kf2-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-kf2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-kf2"
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

   provisioner "file" {
     source = "../../../confluent/kafka-generate-ssl.sh"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.sh"
   }

   provisioner "file" {
     source = "~/kafka-generate-ssl.ini"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.ini"
   }

   provisioner "file" {
     source = "../../../confluent/standalone-kafka-server.sh"
     destination = "/home/${var.adminuser}/standalone-kafka-server.sh"
   }

   provisioner "file" {
     source = "~/standalone-server-build.ini"
     destination = "/home/${var.adminuser}/standalone-server-build.ini"
   }

   #provisioner "remote-exec" {
   #  inline = [
   #     "sudo /bin/bash /home/${var.adminuser}/standalone-kafka-server.sh /home/${var.adminuser}/standalone-server-build.ini 2 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-kafka-server.log"
   #  ]
   #}

}


#Kafka - Server3
resource "azurerm_virtual_machine" "kfvm3" {
  name                  = "${var.prefix}-vm-kf3"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_F.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-kf3-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf3-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-kf3-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-kf3-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-kf3"
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

   provisioner "file" {
     source = "../../../confluent/kafka-generate-ssl.sh"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.sh"
   }

   provisioner "file" {
     source = "~/kafka-generate-ssl.ini"
     destination = "/home/${var.adminuser}/kafka-generate-ssl.ini"
   }

   provisioner "file" {
     source = "../../../confluent/standalone-kafka-server.sh"
     destination = "/home/${var.adminuser}/standalone-kafka-server.sh"
   }

   provisioner "file" {
     source = "~/standalone-server-build.ini"
     destination = "/home/${var.adminuser}/standalone-server-build.ini"
   }

  # provisioner "remote-exec" {
  #   inline = [
  #      "sudo /bin/bash /home/${var.adminuser}/standalone-kafka-server.sh /home/${var.adminuser}/standalone-server-build.ini 3 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-kafka-server.log"
  #   ]
  # }

}


#Proxy servers - Server1
resource "azurerm_virtual_machine" "prvm1" {
  name                  = "${var.prefix}-vm-pr1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_G.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-pr1-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-pr1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-pr1"
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
    host = "${var.subnet_prefix}.10"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

  provisioner "file" {
    source = "../../../confluent/standalone-OneNode-server.sh"
    destination = "/home/${var.adminuser}/standalone-OneNode-server.sh"
  }

  provisioner "file" {
    source = "~/standalone-server-build.ini"
    destination = "/home/${var.adminuser}/standalone-server-build.ini"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #     "sudo /bin/bash /home/${var.adminuser}/standalone-OneNode-server.sh /home/${var.adminuser}/standalone-server-build.ini 1 connect,rest 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-OneNode-server.log"
  #  ]
  #}

}

#Proxy servers - Server2
resource "azurerm_virtual_machine" "prvm2" {
  name                  = "${var.prefix}-vm-pr2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_H.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"

  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-pr2-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-pr2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-pr2"
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
    host = "${var.subnet_prefix}.11"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

  provisioner "file" {
    source = "../../../confluent/standalone-OneNode-server.sh"
    destination = "/home/${var.adminuser}/standalone-OneNode-server.sh"
  }

  provisioner "file" {
    source = "~/standalone-server-build.ini"
    destination = "/home/${var.adminuser}/standalone-server-build.ini"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #     "sudo /bin/bash /home/${var.adminuser}/standalone-OneNode-server.sh /home/${var.adminuser}/standalone-server-build.ini 2 connect,schema,rest 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-OneNode-server.log"
  #  ]
  #}
 


}

#Proxy - Server3
resource "azurerm_virtual_machine" "prvm3" {
  name                  = "${var.prefix}-vm-pr3"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic_I.id}"]
  vm_size               = "${var.vmsize}"
  availability_set_id   = "${azurerm_availability_set.availability_group.id}"
    
  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }
    
  storage_os_disk { 
    name          = "${var.prefix}-vm-pr3-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr3-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
    
  storage_data_disk {
    name          = "${var.prefix}-vm-pr3-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-pr3-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }
    
  os_profile {
    computer_name  = "${var.prefix}-vm-pr3"
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
    host = "${var.subnet_prefix}.12"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found
    timeout = "30s"
  }

  provisioner "file" {
    source = "../../../confluent/standalone-OneNode-server.sh"
    destination = "/home/${var.adminuser}/standalone-OneNode-server.sh"
  }

  provisioner "file" {
    source = "~/standalone-server-build.ini"
    destination = "/home/${var.adminuser}/standalone-server-build.ini"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #     "sudo /bin/bash /home/${var.adminuser}/standalone-OneNode-server.sh /home/${var.adminuser}/standalone-server-build.ini 3 connect,schema 2>&1 |tee /home/${var.adminuser}/remoteExec.standalone-OneNode-server.log"
  #  ]
  #}

}



## single cassandra server
## private IP only 
## 100GB /u01 disk
##
## Customised ini file must be in your home directory

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
variable "prefix" {}
variable "storage_acc" {}
variable "storage_type" {}
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

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-ip-priv"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  ip_configuration {
    name                          = "${var.prefix}-ip-priv"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

#######################################################################################################
# Storage Account
#######################################################################################################
resource "azurerm_storage_account" "sa" {
  name                = "${var.storage_acc}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  account_type        = "${var.storage_type}"

  tags {
    prefix = "staging"
  }
}

resource "azurerm_storage_container" "sc1" {
  name                  = "${var.prefix}-container-0"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm-0"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vmsize}"
  
  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-0-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-0"
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
    host = "${azurerm_network_interface.nic.private_ip_address}"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found 
    timeout = "30s"
  }

  #######################################################################
  provisioner "file" {
     source = "../../../cassandra/cassandra-build.sh"
     destination = "/home/${var.adminuser}/cassandra-build.sh"
  }
  
  provisioner "file" {
     source = "~/cassandra-build.ini"
     destination = "/home/${var.adminuser}/cassandra-build.ini"
  }
  
  provisioner "remote-exec" {
     inline = [ 
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-build.sh /home/${var.adminuser}/cassandra-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-build.log",
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-testsuite.sh /home/${var.adminuser}/cassandra-testsuite.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-testsuite.log"
      ]
  }
  
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm-1"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vmsize}"
  
  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-1-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-1-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-1-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-1-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-1"
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
    host = "${azurerm_network_interface.nic.private_ip_address}"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found 
    timeout = "30s"
  }

  #######################################################################
  provisioner "file" {
     source = "../../../cassandra/cassandra-build.sh"
     destination = "/home/${var.adminuser}/cassandra-build.sh"
  }
  
  provisioner "file" {
     source = "~/cassandra-build.ini"
     destination = "/home/${var.adminuser}/cassandra-build.ini"
  }
  
  provisioner "remote-exec" {
     inline = [ 
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-build.sh /home/${var.adminuser}/cassandra-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-build.log",
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-testsuite.sh /home/${var.adminuser}/cassandra-testsuite.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-testsuite.log"
      ]
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm-2"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vmsize}"
  
  storage_image_reference {
    publisher = "${var.vmpublisher}"
    offer     = "${var.vmoffer}"
    sku       = "${var.vmsku}"
    version   = "${var.vmversion}"
  }

  storage_os_disk {
    name          = "${var.prefix}-vm-2-osdisk"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-2-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-2-datadisk0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-2-datadisk0.vhd"
    disk_size_gb  = "100"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.prefix}-vm-2"
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
    host = "${azurerm_network_interface.nic.private_ip_address}"
    agent = false
    private_key = "${file("~/.ssh/id_rsa")}"
    # Failed to read key ... no key found 
    timeout = "30s"
  }

  #######################################################################
  provisioner "file" {
     source = "../../../cassandra/cassandra-build.sh"
     destination = "/home/${var.adminuser}/cassandra-build.sh"
  }
  
  provisioner "file" {
     source = "~/cassandra-build.ini"
     destination = "/home/${var.adminuser}/cassandra-build.ini"
  }
  
  provisioner "remote-exec" {
     inline = [ 
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-build.sh /home/${var.adminuser}/cassandra-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-build.log",
         "sudo /bin/bash -x /home/${var.adminuser}/cassandra-testsuite.sh /home/${var.adminuser}/cassandra-testsuite.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.cassandra-testsuite.log"
      ]
  }
}

## single instance oracle database
## private IP only 
## 100GB /u01 disk
## 3 x 200GB ASM datadg disks
## 1 x 150GB ASM recodg disk
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

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm0"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-1-asm0.vhd"
    disk_size_gb  = "200"
    create_option = "empty"
    lun           = 1
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm1"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-asm1.vhd"
    disk_size_gb  = "200"
    create_option = "empty"
    lun           = 2
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm2"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-asm2.vhd"
    disk_size_gb  = "200"
    create_option = "empty"
    lun           = 3
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm3"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-asm3.vhd"
    disk_size_gb  = "150"
    create_option = "empty"
    lun           = 4
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm4"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-asm4.vhd"
    disk_size_gb  = "150"
    create_option = "empty"
    lun           = 5
  }

  storage_data_disk {
    name          = "${var.prefix}-vm-0-asm5"
    vhd_uri       = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc1.name}/${var.prefix}-vm-0-asm5.vhd"
    disk_size_gb  = "150"
    create_option = "empty"
    lun           = 6
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
     source = "../../../oracledb/oracledb-build.sh"
     destination = "/home/${var.adminuser}/oracledb-build.sh"
  }

  provisioner "file" {
     source = "~/oracledb-build.ini"
     destination = "/home/${var.adminuser}/oracledb-build.ini"
  }
    
  #######################################################################
  provisioner "file" {
     source = "../../../ogg/ogg-build.sh"
     destination = "/home/${var.adminuser}/ogg-build.sh"
  }

  provisioner "file" {
     source = "~/ogg-build.ini"
     destination = "/home/${var.adminuser}/ogg-build.ini"
  }

  #######################################################################
  provisioner "file" {
     source = "../../../ogg4bd/ogg4bd-build.sh"
     destination = "/home/${var.adminuser}/ogg4bd-build.sh"
  }
  
  provisioner "file" {
     source = "~/ogg4bd-build.ini"
     destination = "/home/${var.adminuser}/ogg4bd-build.ini"
  }
  
  #######################################################################
  provisioner "file" {
     source = "../../../oracledb/oracledb-testsuite.sh"
     destination = "/home/${var.adminuser}/oracledb-testsuite.sh"
  }
      
  provisioner "file" {
     source = "~/oracledb-testsuite.ini"
     destination = "/home/${var.adminuser}/oracledb-testsuite.ini"
  }

  #######################################################################
  provisioner "file" {
     source = "../../../ogg/ogg-testsuite.sh"
     destination = "/home/${var.adminuser}/ogg-testsuite.sh"
  }

  provisioner "file" {
     source = "~/ogg-testsuite.ini"
     destination = "/home/${var.adminuser}/ogg-testsuite.ini"
  }
  
  #######################################################################
  
  provisioner "remote-exec" {
     inline = [ 
        "sudo /bin/bash /home/${var.adminuser}/oracledb-build.sh /home/${var.adminuser}/oracledb-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.oracledb-build.log",
         "sudo /bin/bash /home/${var.adminuser}/ogg-build.sh /home/${var.adminuser}/ogg-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.ogg-build.log",
         "sudo /bin/bash /home/${var.adminuser}/ogg4bd-build.sh /home/${var.adminuser}/ogg4bd-build.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.ogg4bd-build.log",
         "sudo /bin/bash /home/${var.adminuser}/oracledb-testsuite.sh /home/${var.adminuser}/oracledb-testsuite.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.oracledb-testsuite.log",
         "sudo /bin/bash /home/${var.adminuser}/ogg-testsuite.sh /home/${var.adminuser}/ogg-testsuite.ini 2>&1 |tee /home/${var.adminuser}/remoteExec.ogg-testsuite.log"
      ]
  }
  
#   tags {
#      prefix = "${var.prefix}"
#      nodetype    = "${count.index == 0 ? "master" : "managed"}"
#   }
}

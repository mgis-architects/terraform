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
variable "privkeyfilelocation" {}
variable "privkeyfile" {}
variable "pubkeyfilelocation" {}
variable "pubkeyfile" {}
#
variable "buildscriptlocation" {}
variable "buildscript" {}
variable "buildinifilelocation" {}
variable "buildinifile" {}
variable "testsuitescriptlocation" {}
variable "testsuitescript" {}
variable "testsuiteinifilelocation" {}
variable "testsuiteinifile" {}
#
variable "buildscript2location" {}
variable "buildscript2" {}
variable "buildinifile2location" {}
variable "buildinifile2" {}
variable "testsuitescript2location" {}
variable "testsuitescript2" {}
variable "testsuiteinifile2location" {}
variable "testsuiteinifile2" {}


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
    admin_password = "Not@used@hopefully!"
  }


  #######################################################################
  provisioner "file" {
     source = "${var.buildscriptlocation}/${var.buildscript}"
     destination = "/home/${var.adminuser}/${var.buildscript}"
  }

  provisioner "file" {
     source = "${var.buildinifilelocation}/${var.buildinifile}"
     destination = "/home/${var.adminuser}/${var.buildinifile}"
  }

  #######################################################################
  provisioner "file" {
     source = "${var.testsuitescriptlocation}/${var.testsuitescript}"
     destination = "/home/${var.adminuser}/${var.testsuitescript}"
  }

  provisioner "file" {
     source = "${var.testsuiteinifilelocation}/${var.testsuiteinifile}"
     destination = "/home/${var.adminuser}/${var.testsuiteinifile}"
  }


  #######################################################################
  provisioner "file" {
     source = "${var.buildscript2location}/${var.buildscript2}"
     destination = "/home/${var.adminuser}/${var.buildscript2}"
  }

  provisioner "file" {
     source = "${var.buildinifile2location}/${var.buildinifile2}"
     destination = "/home/${var.adminuser}/${var.buildinifile2}"
  }

  #######################################################################
  provisioner "file" {
     source = "${var.testsuitescript2location}/${var.testsuitescript2}"
     destination = "/home/${var.adminuser}/${var.testsuitescript2}"
  }

  provisioner "file" {
     source = "${var.testsuiteinifile2location}/${var.testsuiteinifile2}"
     destination = "/home/${var.adminuser}/${var.testsuiteinifile2}"
  }

  #######################################################################
  
  provisioner "remote-exec" {
     inline = [ 
         "sudo /bin/bash -x /home/${var.adminuser}/${var.buildscript} /home/${var.adminuser}/${var.buildinifile} 2>&1 |tee /home/${var.adminuser}/remoteExec.1-build.log",
         "sudo /bin/bash -x /home/${var.adminuser}/${var.buildscript2} /home/${var.adminuser}/${var.buildinifile2} 2>&1 |tee /home/${var.adminuser}/remoteExec.2-build.log",
         "sudo /bin/bash -x /home/${var.adminuser}/${var.testsuitescript} /home/${var.adminuser}/${var.testsuiteinifile} 2>&1 |tee /home/${var.adminuser}/remoteExec.1-testsuite.log",
         "sudo /bin/bash -x /home/${var.adminuser}/${var.testsuitescript2} /home/${var.adminuser}/${var.testsuiteinifile2} 2>&1 |tee /home/${var.adminuser}/remoteExec.2-testsuite.log"
      ]
  }
  
#   tags {
#      prefix = "${var.prefix}"
#      nodetype    = "${count.index == 0 ? "master" : "managed"}"
#   }
}

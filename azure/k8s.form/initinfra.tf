# Configure the Microsoft Azure Provider
variable "location" {}
variable "root_rg_name" {}
variable "rg_name" {}
variable "vlan_name" {}
variable "subnet_name" {}
variable "cluster_size" {}
variable "environment" {}
variable "storage_acc" {}
variable "adminuser" {}
variable "os_publisher" {}
variable "os_offer" {}
variable "os_sku" {}
variable "vmSize" {}


# Create a resource group
resource "azurerm_resource_group" "k8s" {
    name     = "${var.rg_name}"
    location = "${var.location}"
    lifecycle { 
	prevent_destroy=true
    }
}

resource "azurerm_subnet" "k8s_sub" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${var.root_rg_name}"
  virtual_network_name = "${var.vlan_name}"
  address_prefix       = "10.6.0.0/24"
}

resource "azurerm_network_interface" "ipaddr" {
  count		      = "${var.cluster_size}"
  name                = "${var.environment}-ip-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${var.root_rg_name}"

  ip_configuration {
    name                          = "${var.environment}-ip-conf-${count.index}"
    subnet_id                     = "${azurerm_subnet.k8s_sub.id}"
    private_ip_address_allocation = "dynamic"
  }
}
########
resource "azurerm_storage_account" "k8s" {
  name                = "${var.storage_acc}"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"

  tags {
    environment = "kubernetes"
  }
}

resource "azurerm_storage_container" "k8s" {
  count                 = "${var.cluster_size}"
  name                  = "${var.environment}-container-${count.index}"
  resource_group_name   = "${var.rg_name}"
  storage_account_name  = "${azurerm_storage_account.k8s.name}"
  container_access_type = "private"
}

resource "azurerm_virtual_machine" "k8s" {
  count                 = "${var.cluster_size}"
  name                  = "${var.environment}-vm-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.rg_name}"
  network_interface_ids = ["${element(azurerm_network_interface.ipaddr.*.id,count.index)}"]
  vm_size               = "${var.vmSize}"

  storage_image_reference {
    publisher = "${var.os_publisher}"
    offer     = "${var.os_offer}"
    sku       = "${var.os_sku}"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.k8s.primary_blob_endpoint}${element(azurerm_storage_container.k8s.*.name,count.index)}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.k8s.primary_blob_endpoint}${element(azurerm_storage_container.k8s.*.name,count.index)}/datadisk0.vhd"
    disk_size_gb  = "1023"
    create_option = "empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${var.environment}-vm-${count.index}"
    admin_username = "${var.adminuser}"
    admin_password = "Cdfasdf@2314213f!"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.adminuser}/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/azu_pub.key")}"
    }
  }

  tags {
     environment = "${var.environment}"
     nodetype    = "${count.index == 0 ? "master" : "managed"}"
  }
}

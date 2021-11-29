provider "azurerm" {
   features {}
// subscription_id   = "************"
// tenant_id         = "************"
// client_id         = "************"
// client_secret     = "************"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.84.0"
    }
  }
//required_version = "=1.0.10"
}
### General
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}
### Network
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.network_security_group_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["172.20.0.0/16"]
//dns_servers         = ["172.20.0.4", "172.20.0.5"]
}
resource "azurerm_subnet" "privatesubnet" {
  name                 = "${var.private_subnet_name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefixes     = ["172.20.20.0/24"] 
}
resource "azurerm_subnet" "publicsubnet" {
    name                 = "${var.public_subnet_name}"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefixes     = ["172.20.10.0/24"]
}
resource "azurerm_public_ip" "pip" {
  name                         = "${var.public_ip_name}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  allocation_method            = "Static"
  domain_name_label            = "${var.public_domain_name}"
}
resource "azurerm_network_security_group" "allows" {
  name = "${var.network_security_group_name}"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  security_rule {
    name                       = "AllowSshInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHttpsInBound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHttpInBound"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "jenkinsnic" {
    name                            = "${var.public_network_interface_name}"
    location                        = "${azurerm_resource_group.rg.location}"
    resource_group_name             = "${azurerm_resource_group.rg.name}"
    ip_configuration {
      name                          = "${var.public_network_interface_name}-configuration"
      subnet_id                     = "${azurerm_subnet.publicsubnet.id}"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = "${azurerm_public_ip.pip.id}"
    }
}
resource "azurerm_network_interface" "privatenic" {
    name                            = "${var.private_network_interface_name}"
    location                        = "${azurerm_resource_group.rg.location}"
    resource_group_name             = "${azurerm_resource_group.rg.name}"
    ip_configuration {
      name                          = "${var.private_network_interface_name}-configuration"
      subnet_id                     = "${azurerm_subnet.privatesubnet.id}"
      private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_virtual_machine" "jenkinsvm" {
    name                  = "${var.public_virtual_machine_name}"
    location              = "${azurerm_resource_group.rg.location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.jenkinsnic.id}"]
    vm_size               = "${var.virtual_machine_size}"
    storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    storage_os_disk {
      name                = "${var.public_virtual_machine_osdisk_name}"
      create_option       = "FromImage"
      managed_disk_type   = "${var.virtual_machine_osdisk_type}"
    }
    os_profile {
      computer_name       = "${var.public_virtual_machine_computer_name}"
      admin_username      = "${var.public_admin_username}"
    }
    os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
        path     = "/home/${var.public_admin_username}/.ssh/authorized_keys"
        key_data = "${var.public_ssh_public_key_data}"
      }
    }
}
resource "azurerm_virtual_machine" "privatevm" {
    name                  = "${var.private_virtual_machine_name}"
    location              = "${azurerm_resource_group.rg.location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.privatenic.id}"]
    vm_size               = "${var.virtual_machine_size}"
    storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    storage_os_disk {
      name                = "${var.private_virtual_machine_osdisk_name}"
      create_option       = "FromImage"
      managed_disk_type   = "${var.virtual_machine_osdisk_type}"
    }
    os_profile {
      computer_name       = "${var.private_virtual_machine_computer_name}"
      admin_username      = "${var.public_admin_username}"
    }
    os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
        path              = "/home/${var.public_admin_username}/.ssh/authorized_keys"
        key_data          = "${var.public_ssh_public_key_data}"
    }
  }
}
resource "azurerm_virtual_machine_extension" "jekinsvmextension" {
    name                 = "${var.public_virtual_machine_name}"
    virtual_machine_id   = azurerm_virtual_machine.jenkinsvm.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    protected_settings   = <<PROT
    {
        "script": "${base64encode(file(var.jenkinsvmsc))}"
    }
PROT
}
resource "azurerm_virtual_machine_extension" "privatevmextension" {
    name                 = "${var.private_virtual_machine_name}"
    virtual_machine_id   = azurerm_virtual_machine.privatevm.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    protected_settings   = <<PROT
    {
        "script": "${base64encode(file(var.privatevmsc))}"
    }
PROT
}

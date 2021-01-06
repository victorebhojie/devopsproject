
terraform {
  required_version = "=0.12.13"

}
provider "azurerm" {
  version         = "~>2.0"
  subscription_id = var.sub
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  features {}
}

resource "azurerm_resource_group" "resourcegroup" {

  name = var.rg

  location = "West US"

}

resource "azurerm_virtual_network" "mainnetwork" {

  name                = var.vnet
  address_space       = ["10.0.0.0/16"]
  location            = "West US"
  resource_group_name = var.rg
  depends_on          = [azurerm_resource_group.resourcegroup]

}

resource "azurerm_subnet" "subnet" {
  name                 = "Apache-Subnet"
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
  address_prefix       = "10.0.0.0/24"
  depends_on           = [azurerm_virtual_network.mainnetwork]
}

resource "azurerm_public_ip" "publicip" {
  name                = var.publicip
  resource_group_name = var.rg
  location            = "WestUS"
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.resourcegroup]
}

data "azurerm_public_ip" "publicip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_public_ip.publicip.resource_group_name
  
}


resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = "WestUS"
  resource_group_name = var.rg

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_resource_group.resourcegroup]
}
resource "azurerm_network_interface" "NIC" {
  name                = var.nic_names
  location            = "WestUS"
  resource_group_name = var.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}
output "public_ip" { value = azurerm_public_ip.publicip.ip_address }

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.resourcegroup.name
  }

  byte_length = 8
}

# I Created storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"


}


# I Created Linux virtual machine
resource "azurerm_linux_virtual_machine" "VM" {
  name                  = "ApacherServerVM"
  location              = "westus"
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "apacheserverVM"
  admin_username                  = "var.username"
  admin_password                  = "var.pwd"
  disable_password_authentication = false



  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt -y install apache2",
    ]
  connection {
    type = ssh
    user = var.username
    password =  var.pwd
    host = data.azurerm_public_ip.publicip.ip_address
  }
  }
}
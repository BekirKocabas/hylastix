terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "hylastix-rg" {
  name     = "hylastix-resources"
  location = "West Europe"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "hylastix-vn" {
  name                = "hylastix-vnet"
  resource_group_name = azurerm_resource_group.hylastix-rg.name
  location            = azurerm_resource_group.hylastix-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "hylastix-subnet" {
  name                 = "hylastix-subnet"
  resource_group_name  = azurerm_resource_group.hylastix-rg.name
  virtual_network_name = azurerm_virtual_network.hylastix-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "hylastix-sg" {
  name                = "hylastix-nsg"
  location            = azurerm_resource_group.hylastix-rg.location
  resource_group_name = azurerm_resource_group.hylastix-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "hylastix-dev-rule" {
  name                        = "hyalstix-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" #"95.223.79.162/32" your public IP
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hylastix-rg.name
  network_security_group_name = azurerm_network_security_group.hylastix-sg.name
}

resource "azurerm_subnet_network_security_group_association" "hylastix-sga" {
  subnet_id                 = azurerm_subnet.hylastix-subnet.id
  network_security_group_id = azurerm_network_security_group.hylastix-sg.id
}

resource "azurerm_public_ip" "hyalstix-public-ip" {
  name                = "hylastix-public-ip"
  resource_group_name = azurerm_resource_group.hylastix-rg.name
  location            = azurerm_resource_group.hylastix-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "hylastix-nic" {
  name                = "hylastix-nic"
  location            = azurerm_resource_group.hylastix-rg.location
  resource_group_name = azurerm_resource_group.hylastix-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hylastix-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hyalstix-public-ip.id
  }

  tags = {
    environment = "dev"
  }

}

resource "azurerm_linux_virtual_machine" "hylastix-vm" {
  name                = "hylastix-machine"
  resource_group_name = azurerm_resource_group.hylastix-rg.name
  location            = azurerm_resource_group.hylastix-rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.hylastix-nic.id,
  ]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/hylastixazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", { #instead of windows or linux-ssh-script.tpl use dynamic os selection
      hostname     = self.public_ip_address,
      user         = "",
      identityfile = ""

    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"] #interpreter = ["Powershell", "-Command"]
  }
  tags = {
    environment = "dev"
  }
}

data "azurerm_public_ip" "hyalstix-public-ip-data" {
  name                = azurerm_public_ip.hyalstix-public-ip.name
  resource_group_name = azurerm_resource_group.hylastix-rg.name

}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.hylastix-vm.name}: ${data.azurerm_public_ip.hyalstix-public-ip-data.ip_address}"

}
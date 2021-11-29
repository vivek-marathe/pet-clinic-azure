### General Variables
variable "location" {
  description = "The data center location where all resources will be put into."
  default     = "North Europe"
}
variable "resource_group_name" {
  description = "The name of the resource group which the Jenkins test farm will be created in."
  default     = "resource-group-01"
}
### Network Variables
variable "virtual_network_name" {
  description = "The name of the virtual network connecting all resources."
  default     = "vnet"
}
variable "public_subnet_name" {
  description = "The name of the public subnet."
  default     = "public-subnet"
}
variable "private_subnet_name" {
  description = "The name of the public subnet."
  default     = "private-subnet"
}
variable "public_ip_name" {
  description = "The name of the public IP address for Jenkins virtual machine."
  default     = "jenkins-pip"
}
variable "public_domain_name" {
  description = "The domain name of the Jenkins virtual machine (without azure subdomain)."
  default = "cicd-jenkins01"
}
variable "network_security_group_name" {
  description = "The name of the network security group (firewall rules) for Jenkins virtual machine."
  default     = "ssh-allow"
}
variable "public_network_interface_name" {
  description = "The name of the primary network interface which will be used by the Jenkins virtual machine."
  default     = "jenkins-nic"
}
variable "private_network_interface_name" {
  description = "The name of the primary network interface which will be used by the Jenkins virtual machine."
  default     = "private-nic"
}
### Virtual Machine Variables
variable "public_virtual_machine_name" {
  description = "The name of the Jenkins virtual machine which contains the Jenkins server."
  default     = "jenkins-vm"
}
variable "private_virtual_machine_name" {
  description = "The name of the Jenkins virtual machine which contains the Jenkins server."
  default     = "private-vm"
}
variable "virtual_machine_size" {
  description = "The size of the Jenkins virtual machine."
  default     = "Standard_A2_v2"
}
variable "public_virtual_machine_osdisk_name" {
  description = "The managed OS disk name of the Jenkins virtual machine."
  default     = "jenkins-osdisk"
}
variable "private_virtual_machine_osdisk_name" {
  description = "The managed OS disk name of the private virtual machine."
  default     = "private-osdisk"
}
variable "public_virtual_machine_computer_name" {
  description = "The computer name of the Jenkins virtual machine."
  default     = "cicd-jenkins01"
}
variable "virtual_machine_osdisk_type" {
  description = "The managed OS disk type of the Jenkins virtual machine."
  default     = "Standard_LRS"
}
variable "private_virtual_machine_computer_name" {
  description = "The computer name of the private virtual machine."
  default     = "cicd-private"
}
variable "jenkinsvmsc" {
  description = "The pre extension ecript on the Jenkins virtual machine"
  type        = string
  default     = "jenkinsvmpre.bash"
}
variable "privatevmsc" {
  description = "The pre extension ecript on the private virtual machine"
  type        = string
  default     = "privatevmpre.bash"
}
variable "public_admin_username" {
  description     = "The username of the administrator of the Jenkins virtual machine."
  default         = "azure"
}
variable "public_ssh_public_key_data" {
  description     = "The SSH public key for remote connection of the Jenkins virtual machine."
  default         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0hWyUUEYJYWvVTb+BsJAHeNmW8gJtxLxhdc8sedXn0dALQ8J3VmVpIqzGf+RCGdpP/z79hSMW9Ebv7ADLoEYGjbuqsalMAPaekq7Vj1yG9WVqrfI9kXEs6kAGPMgYgnZLI69BaB9dJrjJIViRZUWnIwSocVyPL5scM5r++dMn4lpT9awpg//krTAi+BCZ6m+Zje+1ZEpr2+gB1p7E26/R0ary2TQbiwi4Uao7V5c+91rQpQf34XuZXBBtLlxhMptiBl8fWxhKhaMLfr9fAQhzfUSvGZH7DaV1qFcjLQsr0M8yaAju2+ZojESdnPxYUP88R8qJdP/oTA1DeDnowtIJirI4EoyI/Vr9/gA9GDmRo7m2VDEIlMOUI80Voir7SJBYm2eDud616+UNW4I2NrwIfPiyzZr3OdktR+JixhiYcyEvVQ/VAK/A7Ich6DOj21n7HYe5a1lbaN6sNa/tDrVn1w1cNSIa3Im2dDdy/HbjYZIUnSrF7D8SkyDeLVoA948= De@DESKTOP-R6BTG9I"
}
variable "public_ssh_private_key_data" {
  description     = "The SSH private key for remote connection. It is used to configure the environment after the virtual machine is created."
  default         = <<-EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF

}
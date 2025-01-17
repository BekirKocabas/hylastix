variable "host_os" {
  description = "The host OS of the machine"
  type        = string  

}

variable "username" {
  description = "The username of the machine"
  type        = string
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key"
  type        = string
}
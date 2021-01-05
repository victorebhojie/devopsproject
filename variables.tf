variable "vnet" {
  type    = string
  default = "Apache-VNET"
}
variable "rg" {
  type    = string
  default = "TestInfra"
}

variable "servers" {
  type    = string
  default = "ApacheVM"

}


variable "publicip" {
  type    = string
  default = "ApacheIP"

}
variable "nic_names" {
  type    = string
  default = "ApacheNIC"
}



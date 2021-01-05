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


variable "sub" { type = string }
variable "client_secret" { type = string }
variable "client_id" { type = string }
variable "tenant_id" { type = string }
variable "vnet" {
  type    = string
  default = "Apache-VNET"
}
variable "rg" {
  type    = string
  default = "ApacheResourceGroup"
}
variable "username" {
  type    = string
  default = "victor"
}
variable "pwd" {
  type    = string
  default = "Pwd@1234"
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
variable "nsg" {
  type    = string
  default = "ApacheNSG"
}

variable "sub" {
  type    = string
  default = "0be5258f-1755-4279-80ff-7485c444defb"
}
variable "client_id" {
  type    = string
  default = "e59ffff8-2dcd-4adc-8a2a-2fbff15f5ced"
}
variable "tenant_id" {
  type    = string
  default = "ae278fc0-4b73-48ef-90b1-063a57846873"
}

variable "client_secret" { type = string }
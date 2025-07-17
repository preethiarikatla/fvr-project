variable "dmz_spoke_vnet_name" {
  default = "ndi"
}

variable "vnet_rg" {
  default = "Preethi"
}
variable "pree" {
  type    = string
  default = "peer-vnet1-to-vnet2-nani"
}
variable "enable_shutdown_script" {
  type    = bool
  default = false
}

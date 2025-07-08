variable "dmz_spoke_vnet_name" {
  default = "ndi"
}

variable "vnet_rg" {
  default = "Preethi"
}
variable "pree" {
  type    = string
  default = "peer-vnet1-to-vnet2-nan"
}
output "simulated_attachment_id" {
  value = local.simulated_attachment_id
}

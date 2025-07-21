variable "resource_group_name" {}
variable "location" {}
variable "nic_name" {}
variable "egress_nic_names" {
  type = map(string)
}
variable "egress_nic_locations" {
  type = map(string)
}
variable "egress_ipconfig_names" {
  type = map(string)
}

terraform {}

terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "2.1.0"
    }
  }
  required_version = ">= 0.13"
}

provider "akamai" {
  config_section = var.akamai_config_section
}

data "akamai_group" "group" {
  group_name  = "terraform-managed"
  contract_id = "contract"
}

data "akamai_contract" "contract" {
  group_name = data.akamai_group.group.group_name
}

variable "akamai_config_section" {
  type    = string
  default = "papi"
}

variable "akamai_environment" {
  type    = string
  default = "staging"
}

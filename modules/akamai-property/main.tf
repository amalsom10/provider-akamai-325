terraform {

  # What provider version to use within this configuration and where to source it from.
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "2.1.0"
    }
  }

  # Constraint to specify which versions of Terraform can be used with this configuration.
  required_version = ">= 1.0.0"
}

# data source that contains the Akamai group based on the name supplied in a variable. A group is tied to an Akamai contract.
data "akamai_group" "group" {
  group_name  = var.group_name
  contract_id = var.contract_id
}

# data source that contains the Akamai contract. An Akamai contract contains all the entitlements and Akamai product/solution usage.
data "akamai_contract" "contract" {
  group_name = var.group_name
}

data "akamai_properties_search" "result" {
  key   = "propertyName"
  value = var.name
}

# resource that creates / manages the Akamai CP Code which is a 6 or 7 digit ID that
# is used for billing, monitoring and reporting. CP Codes are tied to an Akamai Contract
# and Akamai Group as well as an Akamai Product and have a name provided in a variable.
resource "akamai_cp_code" "cp_code" {
  product_id  = var.product_id
  contract_id = data.akamai_group.group.contract_id
  group_id    = data.akamai_group.group.id
  name        = var.name

  # group_id is immutable once created on cp_code
  lifecycle {
    ignore_changes = [group_id]
  }
}

# resource that creates / manages the Akamai Edge Hostname which is used to route traffic to Akamai.
# Usually ends in *.akamaized.net, *.edgesuite.net or *.edgekey.net.
resource "akamai_edge_hostname" "edge_hostname" {
  product_id    = var.product_id
  contract_id   = data.akamai_group.group.contract_id
  group_id      = data.akamai_group.group.id
  ip_behavior   = var.ip_behavior
  edge_hostname = var.edge_hostname
  certificate   = var.certificate_enrollment_id

  # group_id is immutable once created on edge_hostname
  lifecycle {
    ignore_changes = [group_id]
  }
}

data "akamai_property_rules_template" "template" {
  template_file = abspath("${var.path}/property-snippets/main.json")
}

# resource that creates / manages the Akamai Property / delivery configuration.
# Configuration is tied to a Contract and Group. Configuration has a specific Product tied to it as well.
resource "akamai_property" "property" {
  name        = var.name
  product_id  = var.product_id
  contract_id = data.akamai_group.group.contract_id
  group_id    = data.akamai_group.group.id
  rule_format = var.rule_format

  # hostname required to add to the configuration.
  # Also requires the Edge Hostname to add the logical mapping.
  # Please note that a manual step is needed to update your DNS
  # to route traffic properly to Akamai after deployment and testing.
  dynamic "hostnames" {
    for_each = var.hostnames
    content {
      cname_from             = hostnames.value
      cname_to               = akamai_edge_hostname.edge_hostname.edge_hostname
      cert_provisioning_type = var.cert_provisioning_type
    }
  }

  # rules will load in the main.json file added earlier in a data source.
  rules = data.akamai_property_rules_template.template.json
}

# A resource to activate the Akamai Property on either staging or production, depending on env variable supplied.
# Email address is used to notify on completed deployment.
# TODO there is a potential issue here when the property is activated on staging but not production.
# TODO there is a potential for a refactoring into a module.
resource "akamai_property_activation" "activation_staging" {
  property_id = akamai_property.property.id
  network     = upper("staging")
  # staging activation, according to akamai docs, should always keep the latest version
  version = akamai_property.property.latest_version
  contact = [var.email]
}

resource "akamai_property_activation" "activation_production" {
  # We use count here so production activation is not triggerred until after staging is deployed for the first time.
  # This has been added as a null-guard - version set to 0 is considered as null and fails in akamai provider
  count = (var.akamai_network == "staging" && data.akamai_properties_search.result.properties[0].production_status == "INACTIVE") ? 0 : 1

  property_id = akamai_property.property.id
  network     = upper("production")

  # This is controlled by TF_VAR_akamai_environment passed in env vars.
  # Could find a better way to control this - production version will be bumped to:
  # - 1 if there was no previous version on production
  # - otherwise latest_version
  # if the env var is not production, we keep the same version, akamai_property.property.production_version
  version = var.akamai_network == "production" ? (akamai_property.property.production_version == 0 ? 1 : akamai_property.property.latest_version) : akamai_property.property.production_version
  contact = [var.email]
}

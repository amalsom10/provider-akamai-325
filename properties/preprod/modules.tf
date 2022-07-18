module "akamai-property" {
  for_each = { for property in local.map_of_properties : property.folder_name => property }

  source = "../../modules/akamai-property"

  # These two properties are shared across all environments,
  # not sure where to keep them just yet.
  contract_id           = data.akamai_group.group.contract_id
  group_name            = data.akamai_group.group.group_name
  akamai_network        = var.akamai_environment
  edgerc_config_section = var.akamai_config_section

  name                      = each.value.properties.name
  cpcode_name               = each.value.properties.cpcode_name
  edge_hostname             = each.value.properties.edge_hostname
  email                     = each.value.properties.email
  hostnames                 = each.value.properties.hostnames
  ip_behavior               = each.value.properties.ip_behavior
  origin_hostname           = each.value.properties.origin_hostname
  certificate_enrollment_id = each.value.properties.certificate_enrollment_id
  path                      = abspath(each.key)

  # hardcoding rule format to stop automatic rollover to newer version
  # could be added to configurable values
  rule_format = "v2021-09-22"
  rules       = abspath("${each.key}/${each.value.properties.rules_path}")
}

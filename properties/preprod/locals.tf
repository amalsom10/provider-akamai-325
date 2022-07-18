locals {

  # properties found in config.yaml files in all subfolders
  # are transformed into a map of properties:
  #    {
  #      "property-a/config.yaml" = {
  #        "property_key" = "property_value"
  #      }
  #    }
  decoded_properties = { for s in fileset(path.module, "*/config.yaml") : s => yamldecode(file(s)) }

  # we will only enrich the data from decode_properties with a dirname
  #    {
  #      "property-a/config.yaml" = {
  #        "name" = "property-a.my-domain.net"
  #        "properties" = {
  #          "property_key" = "property_value"
  #        }
  #      }
  #    }
  map_of_properties = tomap({ for k, v in local.decoded_properties : k => { folder_name = dirname(k), properties = v } })
}

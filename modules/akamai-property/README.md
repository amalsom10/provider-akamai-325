Akamai property module
======================

Usage
-----

```terraform
module "akamai-property" {
  source = "../../modules/akamai-property"

  name                      = "property-a.my-domain.net"
  cpcode_name               = "property-a.my-domain.net"
  edgerc_config_section     = "papi"
  edge_hostname             = "property-a.my-domain.net.edgekey.net"
  hostnames                 = ["property-a.my-domain.net"]
  ip_behavior               = "IPV6_COMPLIANCE"
  origin_hostname           = "property-a.my-domain.net"
  email                     = "email@example.com"
  contract_id               = "contract_ID"
  group_name                = "your-group"
  rules_path                = "property-snippets/main.json"
  certificate_enrollment_id = "123" 
}
```

Description
-----------
This is [a Terraform module][2] to deploy [an Akamai property][1] including following resources:
* name
* cpcode_name
* edgerc_config_section
* edge_hostname
* hostnames
* ip_behavior
* origin_hostname
* email
* contract_id
* group_name
* rules_path
* certificate_enrollment_id

Modules
-------
No modules.

[1]: <https://techdocs.akamai.com/developer/docs/key-concepts-and-terms> "Akamai key concepts"
[2]: <https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/property>

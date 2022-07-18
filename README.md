provider-akamai-325
===================

How to reproduce
----------------
```shell
$ cd properties/preprod

$ terraform init
Terraform has been successfully initialized!

$ terraform plan
module.akamai-property["property-a"].data.akamai_properties_search.result: Reading...
module.akamai-property["property-b"].data.akamai_property_rules_template.template: Reading...
data.akamai_group.group: Reading...
module.akamai-property["property-b"].data.akamai_properties_search.result: Reading...
module.akamai-property["property-a"].data.akamai_property_rules_template.template: Reading...
module.akamai-property["property-a"].data.akamai_properties_search.result: Read complete after 3s [id=propertyName:property-a.my-domain.net]
module.akamai-property["property-b"].data.akamai_properties_search.result: Read complete after 3s [id=propertyName:property-b.my-domain.net]
╷
│ Error: looking up group with name: terraform-managed: group does not belong to contract: contract
│
│   with data.akamai_group.group,
│   on providers.tf line 17, in data "akamai_group" "group":
│   17: data "akamai_group" "group" {
│
╵
╷
│ Error: template: main:28:18: executing "main" at <{{template "../../shared-behaviours/Accelerate_delivery.json" .}}>: template "../../shared-behaviours/Accelerate_delivery.json" not defined
│
│   with module.akamai-property["property-b"].data.akamai_property_rules_template.template,
│   on ../../modules/akamai-property/main.tf line 62, in data "akamai_property_rules_template" "template":
│   62: data "akamai_property_rules_template" "template" {
│
╵
╷
│ Error: template: main:28:18: executing "main" at <{{template "../../shared-behaviours/Accelerate_delivery.json" .}}>: template "../../shared-behaviours/Accelerate_delivery.json" not defined
│
│   with module.akamai-property["property-a"].data.akamai_property_rules_template.template,
│   on ../../modules/akamai-property/main.tf line 62, in data "akamai_property_rules_template" "template":
│   62: data "akamai_property_rules_template" "template" {
```

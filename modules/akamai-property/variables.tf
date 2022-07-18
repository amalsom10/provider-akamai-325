variable "name" {
  description = "Name of the property"
  type        = string
}

variable "edgerc_config_section" {
  description = "Name of the Akamai config section to define which config_section to use inside the edgerc file."
  type        = string
}

variable "contract_id" {
  description = "Name of your Akamai Contract ID."
  type        = string
}

variable "group_name" {
  description = "The name of your group you want to store your config. Groups are part of an Akamai contract."
  type        = string
}

variable "tags" {
  description = "Tags to set on the property."
  type        = map(string)
  default     = {}
}

variable "product_id" {
  description = "The ID of the Akamai Product that you want to use for Content Delivery."
  type        = string
  default     = "prd_Fresca"
}

variable "hostnames" {
  description = "The list of hostnames you want to Akamaize."
  type        = list(string)
}

variable "cpcode_name" {
  description = "The name you want to give to your Akamai CP Code (Content Provider Code) used for billing, monitoring and reporting."
  type        = string
}

variable "edge_hostname" {
  description = "The Akamai Edge Hostname you want to use, ending in *.akamaized.net, *.edgesuite.net or *.edgekey.net."
  type        = string
}

variable "origin_hostname" {
  description = "The hostname where your Origin is located."
  type        = string
}

variable "ip_behavior" {
  description = "Whether hostname supports IPv4 only or IPv4 + IPv6."
  type        = string
}

variable "rule_format" {
  description = "The Akamai Property Manager rule format which includes updated behaviors for newer versions. By default 'latest'"
  type        = string
  default     = "latest"
}

variable "cert_provisioning_type" {
  description = "Type of HTTPS SSL/TLS Certificate method you use with Akamai. This can be CPS_MANAGED for certificates managed in Certificate Provisioning System or DEFAULT for Secure By Default feature."
  type        = string
  default     = "CPS_MANAGED"
}

variable "akamai_network" {
  description = "Which part of the Akamai platform you wish to deploy your config to, options are 'staging' or 'production'"
  type        = string
  default     = "staging"
}

variable "email" {
  description = "Email address to receive notifications on regarding the deployment of your configuration."
  type        = string
}

variable "rules" {
  description = "Path to the main.json rules file. Currently, cannot be set to anything other than path/property_snippets"
}

variable "path" {
  description = "Path to the Akamai property root folder"
}

variable "certificate_enrollment_id" {
  //TODO come up with a solution to acquiring certificate enrollment id
  description = "Enrollment id of certificate from Akamai Certificate Provisioning service (CPS)."
  default     = 0
  type        = number
}

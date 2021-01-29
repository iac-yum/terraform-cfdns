# @ref: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
provider "cloudflare" {}


##
#  Get zone id
#

variable "zone" {
  description = "CloudFlare zone to query"
  type        = string
}

data "cloudflare_zones" "zones" {
  filter {
    name = var.zone
  }
}

##
#   Configure records
#

resource "cloudflare_record" "a_records" {
  count = length(local.records["A"])

  type    = "A"
  name    = local.records["A"][count.index].name
  value   = local.records["A"][count.index].value
  ttl     = lookup(local.records["A"][count.index], "ttl", 1)
  proxied = lookup(local.records["A"][count.index], "proxied", false)
  zone_id = data.cloudflare_zones.zones.zones[0].id
}

resource "cloudflare_record" "aaaa_records" {
  count = length(local.records["AAAA"])

  type    = "AAAA"
  name    = local.records["AAAA"][count.index].name
  value   = local.records["AAAA"][count.index].value
  ttl     = lookup(local.records["AAAA"][count.index], "ttl", 1)
  proxied = lookup(local.records["AAAA"][count.index], "proxied", false)
  zone_id = data.cloudflare_zones.zones.zones[0].id
}

resource "cloudflare_record" "cname_records" {
  count = length(local.records["CNAME"])

  type    = "CNAME"
  name    = local.records["CNAME"][count.index].name
  value   = local.records["CNAME"][count.index].value
  ttl     = lookup(local.records["CNAME"][count.index], "ttl", 1)
  proxied = lookup(local.records["CNAME"][count.index], "proxied", false)
  zone_id = data.cloudflare_zones.zones.zones[0].id
}

resource "cloudflare_record" "mx_records" {
  count = length(local.records["MX"])

  type     = "MX"
  name     = data.cloudflare_zones.zones.zones[0].name
  value    = local.records["MX"][count.index].value
  ttl      = lookup(local.records["MX"][count.index], "ttl", 1)
  priority = lookup(local.records["MX"][count.index], "priority", 10)
  zone_id  = data.cloudflare_zones.zones.zones[0].id
}

resource "cloudflare_record" "txt_records" {
  count = length(local.records["TXT"])

  type    = "TXT"
  name    = data.cloudflare_zones.zones.zones[0].name
  value   = local.records["TXT"][count.index].value
  zone_id = data.cloudflare_zones.zones.zones[0].id
}

# @ref: https://registry.terraform.io/providers/hashicorp/dns/latest/docs
provider "dns" {
  update {
    server        = "127.0.0.1"
    port          = "54"
    key_name      = "tsig-key.teamvinted.com."
    key_algorithm = "hmac-sha256"
    key_secret    = "hfZr4+rau4kldIB40p+Ze2oLeN4ixdVHDo2pAZEtudc="
  }
}


##
# DNS updates
#

resource "dns_a_record_set" "records" {
  count = length(local.records["A"])

  zone      = "${var.zone}."
  name      = local.records["A"][count.index].name
  ttl       = lookup(local.records["A"][count.index], "ttl", 300)
  addresses = [local.records["A"][count.index].value]
}

resource "dns_aaaa_record_set" "records" {
  count = length(local.records["AAAA"])

  zone      = "${var.zone}."
  name      = local.records["AAAA"][count.index].name
  ttl       = lookup(local.records["AAAA"][count.index], "ttl", 300)
  addresses = [local.records["AAAA"][count.index].value]
}

resource "dns_cname_record" "records" {
  count = length(local.records["CNAME"])

  zone = "${var.zone}."
  name = local.records["CNAME"][count.index].name
  ttl  = lookup(local.records["CNAME"][count.index], "ttl", 300)
  # NOTE: Terraform DNS provider only accepts FQDN with a dot
  cname = "${local.records["CNAME"][count.index].value}."
}

resource "dns_mx_record_set" "records" {
  zone = "${var.zone}."
  # ttl       = 3600  # default

  dynamic "mx" {
    for_each = local.records["MX"]
    content {
      # NOTE: Terraform DNS provider only accepts FQDN with a dot
      exchange   = "${mx.value.value}."
      preference = mx.value.priority
    }
  }
}

terraform {
  required_version = "~> 0.14.5"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.17.0"
      # local build for darwin_arm64, not in registry yet :(
      #version = "99.0.0"  
    }
    dns = {
      source = "hashicorp/dns"
      version = "~> 3.0.1"
      # local build for darwin_arm64, not in registry yet :(
      #version = "99.0.0"
    }
  }
}
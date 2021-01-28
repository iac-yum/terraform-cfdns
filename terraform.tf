terraform {
  required_version = "~> 0.14.5"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      # no mac_arm64 build in registry :(
      # version = "99.0.0"  
    }
  }
}
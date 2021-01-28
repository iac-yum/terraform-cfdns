# terraform-cfdns

Manage [CloudFlare](https://www.cloudflare.com/) DNS records with [Terraform Cloudflare provider](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs).

# USAGE

1. Initialize Terraform with providers

        terraform init
        
2. Setup credentials

    export CLOUDFLARE_EMAIL=your.email@domain.tld
    export CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

3. Apply

      terraform apply

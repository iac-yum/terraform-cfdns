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

# ISSUES

- Idempotency fails: Terraform DNS provider aggregates multiple entries to
  record sets after apply. Need to refactor `records.yml` structure to work
  with IP sets.
- Issue with record ordering in `records.yml`. Inserting or deleting records
  cause changes to previous records.
- Terraform DNS provider does not support `@` (apex entries), nor zone root
  FQDNs for A, records (provider bug).
- Remove secrets from DNS provider - setup variables and a `.tfvars` file.
- TODO: PTR, TXT records
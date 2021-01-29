##
#   Load records from YAML file
#

locals {
  records = yamldecode(file("${path.module}/records.yml"))
  # TODO: sort records automatically so ordering won't be an issue
}

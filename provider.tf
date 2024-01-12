
provider "aws" {
  region = var.main_vpc_region
  profile = "pg"

  # Requester's credentials.
}

provider "aws" {
  alias  = "peer"
  region = var.peer_vpc_region
  profile = "pg"

  # Accepter's credentials.
}


terraform {
  required_version = ">= 0.12"
}

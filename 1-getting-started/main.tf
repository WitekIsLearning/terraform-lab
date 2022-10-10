terraform {
  cloud {
    organization = "wekk"

    workspaces {
      name = "1-getting-started"
    }

  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

locals {
  project_name = "WitekServer"
}
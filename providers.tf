terraform {
  required_providers {
    nexus = {
      source  = "datadrivers/nexus"
      version = "1.21.2"
    }
  }
  required_version = "1.9.1"
  backend "http" {}
}

provider "nexus" {
  insecure = true
}

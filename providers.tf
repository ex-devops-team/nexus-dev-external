terraform {
  required_providers {
    nexus = {
      source  = "datadrivers/nexus"
      version = "1.21.2"
    }
  }
  backend "http" {}
}

provider "nexus" {
  insecure = false
  url      = "https://nexus.dev.domoy.ru"
}
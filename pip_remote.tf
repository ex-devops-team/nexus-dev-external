resource "nexus_blobstore_file" "pip_remote_blobstore" {
  name = "pip-remote"
  path = "pip-remote"
}

resource "nexus_repository_pypi_proxy" "pip_proxy" {
  for_each = var.pip_remote_proxy

  name   = "pip-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = "pip-remote"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = each.value.url
    content_max_age  = 1440
    metadata_max_age = 1440
  }

  negative_cache {
    enabled = true
    ttl     = 1440
  }

  http_client {
    blocked    = false
    auto_block = true
  }

  depends_on = [
    nexus_blobstore_file.pip_remote_blobstore
  ]
}

locals {
  pip_member_names = flatten([
    for key, list_value in var.pip_remote_proxy : "pip-remote-${key}"
  ])
}

resource "nexus_repository_pypi_group" "pypi_remote_group" {

  name   = "pip-remote"
  online = true

  group {
    member_names = local.pip_member_names
  }

  storage {
    blob_store_name                = "pip-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    nexus_blobstore_file.pip_remote_blobstore
  ]
}

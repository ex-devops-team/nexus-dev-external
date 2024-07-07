resource "nexus_blobstore_file" "nuget_remote_blobstore" {
  name = "nuget-remote"
  path = "nuget-remote"
}

resource "nexus_repository_nuget_proxy" "nuget_proxy" {
  for_each = var.nuget_remote_proxy

  name   = "nuget-remote-${each.key}"
  online = true

  nuget_version            = "V3"
  query_cache_item_max_age = 3600

  storage {
    blob_store_name                = "nuget-remote"
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
    nexus_blobstore_file.nuget_remote_blobstore
  ]
}

locals {
  nuget_member_names = flatten([
    for key, list_value in var.nuget_remote_proxy : "nuget-remote-${key}"
  ])
}

resource "nexus_repository_nuget_group" "nuget_remote_group" {

  name   = "nuget-remote"
  online = true

  group {
    member_names = local.nuget_member_names
  }

  storage {
    blob_store_name                = "nuget-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    nexus_blobstore_file.nuget_remote_blobstore
  ]
}

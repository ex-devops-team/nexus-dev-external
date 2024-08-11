
locals {
  nuget_member_names = flatten([
    for key, list_value in var.nuget_remote_proxy : "nuget-remote-${key}"
  ])
}

resource "nexus_blobstore_file" "nuget_remote_blobstore" {
  name  = "nuget-remote"
  path  = "nuget-remote"
  count = lookup(var.s3, "enabled") ? 0 : 1
}

locals {
  nuget_blobstore_depenecies = lookup(var.s3, "enabled") ? nexus_blobstore_s3.nuget_remote_blobstore_s3 : nexus_blobstore_file.nuget_remote_blobstore
}

resource "nexus_blobstore_s3" "nuget_remote_blobstore_s3" {
  name = "nuget-remote"
  bucket_configuration {
    bucket {
      name       = "nuget-remote"
      region     = lookup(var.s3, "region")
      expiration = lookup(var.s3, "expiration")
    }
    advanced_bucket_connection {
      endpoint         = lookup(var.s3, "url")
      force_path_style = lookup(var.s3, "path_style")
    }
    bucket_security {
      access_key_id     = lookup(var.s3, "access_key")
      secret_access_key = lookup(var.s3, "secret_key")
    }
  }
  count = lookup(var.s3, "enabled") ? 1 : 0

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
    local.nuget_blobstore_depenecies,
    nexus_repository_nuget_proxy.nuget_proxy
  ]
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
    local.nuget_blobstore_depenecies,
    nexus_repository_nuget_proxy.nuget_proxy
  ]
}

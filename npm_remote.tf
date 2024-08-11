locals {
  npm_member_names = flatten([
    for key, list_value in var.npm_remote_proxy : "npm-remote-${key}"
  ])
}

locals {
  npm_blobstore_depenecies = lookup(var.s3, "enabled") ? nexus_blobstore_s3.npm_remote_blobstore_s3 : nexus_blobstore_file.npm_remote_blobstore
}

resource "nexus_blobstore_s3" "npm_remote_blobstore_s3" {
  name = "npm-remote"
  bucket_configuration {
    bucket {
      name       = "npm-remote"
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

resource "nexus_blobstore_file" "npm_remote_blobstore" {
  name  = "npm-remote"
  path  = "npm-remote"
  count = lookup(var.s3, "enabled") ? 0 : 1
}

resource "nexus_repository_npm_proxy" "npm_proxy" {
  for_each = var.npm_remote_proxy

  name   = "npm-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = "npm-remote"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = each.value.url
    content_max_age  = -1
    metadata_max_age = 60
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
    local.npm_blobstore_depenecies,
  ]
}

resource "nexus_repository_npm_group" "npm_remote_group" {

  name   = "npm-remote"
  online = true

  group {
    member_names = local.npm_member_names
  }

  storage {
    blob_store_name                = "npm-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    local.npm_blobstore_depenecies,
    nexus_repository_npm_proxy.npm_proxy
  ]
}

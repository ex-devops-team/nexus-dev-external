locals {
  raw_blobstore_depenecies = lookup(var.s3, "enabled") ? nexus_blobstore_s3.raw_remote_blobstore_s3 : nexus_blobstore_file.raw_remote_blobstore
}

resource "nexus_blobstore_s3" "raw_remote_blobstore_s3" {
  name = "raw-remote"
  bucket_configuration {
    bucket {
      name       = "raw-remote"
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

resource "nexus_blobstore_file" "raw_remote_blobstore" {
  # for_each = var.raw_remote_proxy

  name  = "raw-remote"
  path  = "raw-remote"
  count = lookup(var.s3, "enabled") ? 0 : 1
}

resource "nexus_repository_raw_proxy" "raw_proxy" {
  for_each = var.raw_remote_proxy

  name   = "raw-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = "raw-remote"
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
    local.raw_blobstore_depenecies
  ]
}

locals {
  helm_blobstore_depenecies = lookup(var.s3, "enabled") ? nexus_blobstore_s3.helm_remote_blobstore_s3 : nexus_blobstore_file.helm_remote_blobstore
}

resource "nexus_blobstore_s3" "helm_remote_blobstore_s3" {
  name = "helm-remote"
  bucket_configuration {
    bucket {
      name       = "helm-remote"
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

resource "nexus_blobstore_file" "helm_remote_blobstore" {
  name  = "helm-remote"
  path  = "helm-remote"
  count = lookup(var.s3, "enabled") ? 0 : 1
}

resource "nexus_repository_helm_proxy" "helm_proxy" {
  for_each = var.helm_remote_proxy

  name   = "helm-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = "helm-remote"
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
    local.helm_blobstore_depenecies
  ]
}

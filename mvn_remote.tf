locals {
  mvn_member_names = flatten([
    for key, list_value in var.mvn_remote_proxy : "mvn-remote-${key}"
  ])
}

locals {
  mvn_blobstore_depenecies = lookup(var.s3, "enabled") ? nexus_blobstore_s3.mvn_remote_blobstore_s3 : nexus_blobstore_file.mvn_remote_blobstore
}

resource "nexus_blobstore_s3" "mvn_remote_blobstore_s3" {
  name = "mvn-remote"
  bucket_configuration {
    bucket {
      name       = "mvn-remote"
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

resource "nexus_blobstore_file" "mvn_remote_blobstore" {
  name  = "mvn-remote"
  path  = "mvn-remote"
  count = lookup(var.s3, "enabled") ? 0 : 1
}

resource "nexus_repository_maven_proxy" "mvn_proxy" {
  for_each = var.mvn_remote_proxy

  name   = "mvn-remote-${each.key}"
  online = true

  maven {
    version_policy      = "RELEASE"
    layout_policy       = "STRICT"
    content_disposition = "INLINE"
  }

  storage {
    blob_store_name                = "mvn-remote"
    strict_content_type_validation = true
  }

  proxy {
    remote_url       = each.value.url
    content_max_age  = -1
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
    local.mvn_blobstore_depenecies
  ]
}

resource "nexus_repository_maven_group" "mvn_proxy_group" {

  name   = "mvn-remote"
  online = true

  group {
    member_names = local.mvn_member_names
  }

  storage {
    blob_store_name                = "mvn-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    local.mvn_blobstore_depenecies,
    nexus_repository_maven_proxy.mvn_proxy
  ]
}

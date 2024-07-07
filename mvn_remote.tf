resource "nexus_blobstore_file" "mvn_remote_blobstore" {
  name = "mvn-remote"
  path = "mvn-remote"
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
    nexus_blobstore_file.mvn_remote_blobstore
  ]
}

locals {
  mvn_member_names = flatten([
    for key, list_value in var.mvn_remote_proxy : "mvn-remote-${key}"
  ])
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
    nexus_blobstore_file.mvn_remote_blobstore
  ]
}

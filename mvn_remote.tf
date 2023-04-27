resource "nexus_blobstore_file" "nexus_remote_blobstore" {
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
    nexus_blobstore_file.nexus_remote_blobstore
  ]
}
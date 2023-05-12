resource "nexus_blobstore_file" "node_remote_blobstore" {
  name = "npm-remote"
  path = "npm-remote"
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
}

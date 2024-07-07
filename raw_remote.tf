resource "nexus_blobstore_file" "remote_blobstore" {
  for_each = var.raw_remote_proxy

  name = each.value.storage
  path = each.value.storage
}

resource "nexus_repository_raw_proxy" "raw_proxy" {
  for_each = var.raw_remote_proxy

  name   = "raw-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = each.value.storage
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
    nexus_blobstore_file.remote_blobstore
  ]
}

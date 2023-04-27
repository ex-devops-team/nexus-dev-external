resource "nexus_blobstore_file" "helm_remote_blobstore" {
  name = "helm-remote"
  path = "helm-remote"
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
}
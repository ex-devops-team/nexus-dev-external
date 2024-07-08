resource "nexus_blobstore_file" "terraform_remote_blobstore" {
  name = "terraform-remote"
  path = "terraform-remote"
}

resource "nexus_repository_raw_proxy" "terraform_proxy" {
  for_each = var.terraform_remote_proxy

  name   = "terraform-remote-${each.key}"
  online = true

  storage {
    blob_store_name                = "terraform-remote"
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
    nexus_blobstore_file.terraform_remote_blobstore
  ]
}

resource "nexus_blobstore_file" "docker_remote_blobstore" {
  name = "docker-remote"
  path = "docker-remote"
}

resource "nexus_repository_docker_proxy" "docker_proxy" {
  for_each = var.docker_remote_proxy

  name   = "docker-remote-${each.key}"
  online = true

  docker {
    force_basic_auth = false
    v1_enabled       = false
  }

  docker_proxy {
    index_type = each.value.index
  }

  storage {
    blob_store_name                = "docker-remote"
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
    nexus_blobstore_file.docker_remote_blobstore
  ]
}

locals {
  docker_member_names = flatten([
    for key, list_value in var.docker_remote_proxy : "docker-remote-${key}"
  ])
}

resource "nexus_repository_docker_group" "docker_remote_group" {

  name   = "docker-remote"
  online = true

  docker {
    force_basic_auth = false
    v1_enabled       = true
  }

  group {
    member_names = local.docker_member_names
  }

  storage {
    blob_store_name                = "docker-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    nexus_blobstore_file.docker_remote_blobstore
  ]
}

resource "nexus_repository_docker_group" "docker_group" {

  name   = "docker-group"
  online = true

  docker {
    force_basic_auth = false
    v1_enabled       = true
  }

  group {
    member_names = local.docker_member_names
  }

  storage {
    blob_store_name                = "docker-remote"
    strict_content_type_validation = true
  }

  depends_on = [
    nexus_blobstore_file.docker_remote_blobstore
  ]
}

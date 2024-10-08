variable "s3" {
  type = map(any)
  default = {
    url        = "https://minio.example.com"
    region     = "us-central-1"
    expiration = 90
    path_style = true
    access_key = ""
    secret_key = ""
    enabled    = true
  }
}
variable "docker_remote_proxy" {
  type = map(any)
  default = {
    dockerhub = {
      index = "HUB"
      url   = "https://registry-1.docker.io"
    }
    mcr = {
      index = "REGISTRY"
      url   = "https://mcr.microsoft.com"
    },
    k8s = {
      index = "REGISTRY"
      url   = "https://registry.k8s.io"
    },
    gitlab = {
      index = "REGISTRY"
      url   = "https://registry.gitlab.com"
    },
    quay = {
      index = "REGISTRY"
      url   = "https://quay.io"
    },
    ghcr = {
      index = "REGISTRY"
      url   = "https://ghcr.io"
    },
    gcr = {
      index = "REGISTRY"
      url   = "https://k8s.gcr.io"
    },
    gcr-io = {
      index = "REGISTRY"
      url   = "https://gcr.io"
    },
    yandex = {
      index = "REGISTRY"
      url   = "https://cr.yandex"
    },
    deckhouse = {
      index = "REGISTRY"
      url   = "https://registry.deckhouse.io"
    }
    nvcr = {
      index = "REGISTRY"
      url   = "https://nvcr.io"
    }
  }
}

variable "mvn_remote_proxy" {
  type = map(any)

  default = {
    central = {
      url = "https://repo1.maven.org/maven2"
    }
    onehippo = {
      url = "https://maven.onehippo.com/maven2"
    },
    jboss = {
      url = "https://repository.jboss.org/nexus/content/groups/public/org"
    },
    spring = {
      url = "https://repo.spring.io/ui/native/libs-milestone"
    },
    jitpack = {
      url = "https://jitpack.io"
    }
    spring-release = {
      url = "https://repo.spring.io/ui/native/libs-release"
    }
    geomajas = {
      url = "http://maven.geomajas.org"
    }
  }
}

variable "helm_remote_proxy" {
  type = map(any)

  default = {
    awx = {
      url = "https://ansible.github.io/awx-operator"
    },
    dex = {
      url = "https://charts.dexidp.io"
    },
    prometheus = {
      url = "https://prometheus-community.github.io/helm-charts"
    },
    grafana = {
      url = "https://grafana.github.io/helm-charts"
    },
    istio = {
      url = "https://istio-release.storage.googleapis.com/charts"
    }
  }
}

variable "gradle_remote_proxy" {
  type = map(any)

  default = {
    plugins = {
      url = "https://plugins.gradle.org/m2"
    }
  }
}

variable "npm_remote_proxy" {
  type = map(any)

  default = {
    npmjs = {
      url = "https://registry.npmjs.org"
    },
    yarn = {
      url = "https://registry.yarnpkg.com"
    }
  }
}

variable "pip_remote_proxy" {
  type = map(any)

  default = {
    pypi = {
      url = "https://pypi.org"
    }
  }
}

variable "raw_remote_proxy" {
  type = map(any)

  default = {
    yandex = {
      url = "https://mirror.yandex.ru"
      # storage = "raw-remote-yandex"
    },
    github = {
      url = "https://github.com"
      # storage = "raw-remote-github"
    }
  }
}

variable "terraform_remote_proxy" {
  type = map(any)

  default = {
    yandex-providers = {
      url = "https://terraform-mirror.yandexcloud.net"
    }
    yandex-binaries = {
      url = "https://hashicorp-releases.yandexcloud.net/terraform"
    }
  }
}

variable "nuget_remote_proxy" {
  type = map(any)

  default = {
    nuget = {
      url = "https://api.nuget.org/v3/index.json"
    }
  }
}

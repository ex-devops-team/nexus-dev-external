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
    }
  }
}

variable "mvn_remote_proxy" {
  type = map(any)

  default = {
    central = {
      url = "https://repo1.maven.org/maven2/"
    }
    onehippo = {
      url = "https://maven.onehippo.com/maven2/"
    },
    jboss = {
      url = "https://repository.jboss.org/nexus/content/groups/public/org"
    },
    spring = {
      url = "https://repo.spring.io/ui/native/libs-milestone"
    }
  }
}

variable "helm_remote_proxy" {
  type = map(any)

  default = {
    awx = {
      url = "https://ansible.github.io/awx-operator/"
    },
    dex = {
      url = "https://charts.dexidp.io"
    }
  }
}

variable "gradle_remote_proxy" {
  type = map(any)

  default = {
    plugins = {
      url = "https://plugins.gradle.org/m2/"
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
      url = "https://pypi.org/"
    }
  }
}

variable "raw_remote_proxy" {
  type = map(any)

  default = {
    cypress = {
      url     = "https://cdn.cypress.io",
      storage = "npm-remote"
    },
    gradledistribution = {
      url     = "https://services.gradle.org/distributions/",
      storage = "gradle-remote"
    },
    yandex = {
      url     = "https://mirror.yandex.ru/"
      storage = "raw-remote-yandex"
    }
  }
}

variable "terraform_remote_proxy" {
  type = map(any)

  default = {
    yandex = {
      url = "https://terraform-mirror.yandexcloud.net/"
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
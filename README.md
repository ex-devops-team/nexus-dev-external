# Данный репозиторий описывает конфигурацию внешних репозиториев для Nexus на DEV стенде

## Список репозиториев находится в файле ```variables.tf```

- docker
- gradle
- helm
- mvn
- npm
- nuget
- pip
- raw
- terraform

### Для добавления новых репозиториев внести переменные в ```variables.tf```.

#### Перед использованием необходимо задать Nexus url, пользователя и пароль через переменные окружения:

```bash
export NEXUS_URL=https://nexus.dev.lh.samoletgroup.ru/
export NEXUS_USERNAME="admin"
export NEXUS_PASSWORD="password"
```

[Используется провайдер](https://github.com/datadrivers/terraform-provider-nexus)

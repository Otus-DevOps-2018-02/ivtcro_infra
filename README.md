# ivtcro_infra
ivtcro Infra repository

## Подключение через ssh к ВМ GCP
для работы комманд, указанных ниже, приватный ключ для работы с ВМ GCP должен быть добавлен в ssh-агента.

### Команда для подключения в одну команду к someinternalhost
`ssh -J ivtcro@35.195.57.52 ivtcro@someinternalhost`

### Подключение по алиасу к **someinternalhost**
Для подключение к **someinternalhost** командой вида `ssh someinternalhost` необходимо в файле `~/.ssh/config` прописать следующие настройки:
```
	Host someinternalhost
        HostName someinternalhost
        ProxyJump ivtcro@35.195.57.52
        User ivtcro
```

## VPN Подключение к ВМ GCP
На `bastionhost` запущен OpenVPN сервер(*Pritunl*) для доступа ко внетренней сети, в частности для доступа к `someinternalhost`.
Профиль для подключения храниться в файле репозитория `cloud-bastion.ovpn`. Адреса VPN-шлюза и адрес хоста `someinternalhost` ниже
```
bastion_IP = 35.195.57.52
someinternalhost_IP = 10.132.0.3
```
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

## Работа с gcloud
### Создание новой ВМ c приложением Monolith Reddit
Для создания ВМ c приложением Monolith reddit использовать следующую комманду
```
	gcloud compute instances create reddit-app\
	 --boot-disk-size=10GB \
	 --image-family ubuntu-1604-lts \
	 --image-project=ubuntu-os-cloud \
	 --machine-type=g1-small \
	 --tags puma-server \
	 --restart-on-failure \
	 --metadata-from-file startup-script=prepare-vm.sh
 ```

для размещения startup-скрипта в Google Cloud Storage нужно выполнить следующую поледовательность команд:
gsutil mb gs://reddit-testapp/
gsutil cp prepare-vm.sh gs://reddit-testapp/

в этом случае команда для создания ВМ быдут выглядеть следующим образом
```
	gcloud compute instances create reddit-app\
	 --boot-disk-size=10GB \
	 --image-family ubuntu-1604-lts \
	 --image-project=ubuntu-os-cloud \
	 --machine-type=g1-small \
	 --tags puma-server \
	 --restart-on-failure \
	 --metadata startup-script-url=gs://reddit-testapp/prepare-vm.sh
 ```
### Создание правил FW с помощью gcloud
```
gcloud compute firewall-rules create default-puma-server --allow=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```

### Параметры подключения к приложению
```
testapp_IP = 35.205.246.149
testapp_port = 9292
```
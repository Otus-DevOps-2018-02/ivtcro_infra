# HOMEWORK №04: Bastion Host
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

# HOMEWORK №05: gcloud
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
```
gsutil mb gs://reddit-testapp/
gsutil cp prepare-vm.sh gs://reddit-testapp/
```

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

# HOMEWORK №06: packer

Для работы Packer с GCP необходимо получить credentials выполнив команду `gcloud auth application-default login`.

Для создания base-образа(MongoDB + Ruby) нужно выполнить команду `packer build -var-file=variables.json ubuntu16.json` в папке packer
Шаблон образа параметризованный, можно задать параметры `project_id`(обязательный), `source_image_family`(обязательный), `machine_type`(опциональный - по умолчанию значение g1-small)

Для создания immutable-образа(MongoDB + Ruby + с тестовым приложением) нужно выполнить команду `packer build -var-file=variables.json immutable.json`. По сравнению с base-образом есть доп. параметр - `image_family`, опциональный, по дефлоту значение "reddit-full".

в папке `config scripts` лежит скрипт `create-reddit-vm.sh`, создающий ВМ из ранее созданного immutable образа

# HOMEWORK №07: terraform

### Что сделано
 - установлен terraform
 - все материалы по данному дз созданы в папке terraform
 - созданы файлы деплоя для создания инстансов приложения(`main.tf`) а также для настройки http-балансировки между этими инстансами(`lb.tf`)
 - изучены комманды `apply`, `plan`, `refresh`, `tint`, `show`, `destroy`, `taint`, `fmt`
 - настроены input- и output-переменные

### Как провеорить работу
 - выполнить команду `terraform apply` в папке 	`terraform`
 - посмотреть значение output-переменных (`terraform output`)
 - перейти по адерсу http://app_external_ip_on_lb, убедиться, что страница отрывается
 - подключиться к app_external_ip_1 по ssh, остановить сервис puma
 - в консоле GCP провеорить, что для backend-сервиса reddit-app-backend только один инстанс проходит проверку http-check
 - перейти по адерсу http://app_external_ip_on_lb, убедится что страница отрывается


### Задание с добавлением новых ключей в проект
Для добавления новых публичных ключей в проект в шаблон терраформ `main.tf` было добавлен следующий ресурс после провижионера google cloud:
```
resource "google_compute_project_metadata" "default" {
  metadata {
  ssh-keys = "user1:${file(var.public_key_path)} user2:${file(var.public_key_path)} user3:${file(var.public_key_path)}"
  }
}
```
и выполнена комманда terraform apply

После чего через web-консоль GCP был добавлен ключ пользователя appuser_web и еще раз выполнена комманда terraform apply.
Несмотря на то, что по сравнению со state-файлом никаких изменений не было, terraform отследил что фактические метаданные проекта и метаданные заданные в шеблоне не совпадают, и ключи проекта были удалены и созданы заданово. В результате ключ, созданный через WEB-консоль пропал.

### Задание с настройкой балансировщика

Конфигурация http-балансировщика добавлена в файл `lb.tf`. Для подключения к сервису через балансировщик нужно:
- выполнить комманду `terraform output`
- открыть в браузере адрес http://app_external_ip_on_lb

Проблемы настроенной конфигурации:
 - не учитывается загрузка интансов при балансировке.
 - нет автоматического скейлинга при нехватке ресурсов 
 - каждый инстанс приложения независимый, нет репликации данных

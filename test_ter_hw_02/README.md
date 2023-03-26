# Домашнее задание к занятию "Основы Terraform. Yandex Cloud"

### Цель задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чеклист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex Cli.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Подготовка к выполнению домашнего задания

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
2. Запросите preview доступ к данному функционалу в ЛК Yandex Cloud. Обычно его выдают в течении 24-х часов.
https://console.cloud.yandex.ru/folders/<ваш cloud_id>/vpc/security-groups


### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?
> Ошибка - указанное количество ядер (1) недоступно на платформе "standard-v1"; при уровне производительности 5% - допустимое количество ядер: 2, 4 и 0.5, 1, 1.5, 2 Гб RAM на 1 ядро.


5. Ответьте, что означает ```preemptible = true``` и ```core_fraction``` в параметрах ВМ? Как это может пригодится в процессе обучения? Ответ в документации Yandex cloud.
>preemptible = true - с данным параметром создается прерываемая ВМ, такая ВМ может быть принудительно остановлена в любой момент: если с момента запуска прошло 24 часа и в случае нехватки ресурсов для запсука обычной ВМ в тоже зоне доступности.
>core_fraction - этот параметр задает базовую производительность для каждого ядра в %.


В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,
![Снимок экрана от 2023-03-19 21-22-13](https://user-images.githubusercontent.com/108893621/226434921-72598511-a0ec-498a-b306-a3ec593728d4.png)


- скриншот успешного подключения к консоли ВМ через ssh,
![Снимок экрана от 2023-03-19 21-27-31](https://user-images.githubusercontent.com/108893621/226434959-65d341b7-9c90-43cf-86a6-fdd4e75f8887.png)


### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_instance
  platform_id = var.vm_web_platform
...
```

4. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
```
###yandex_compute_image

variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "name web image"
}

###yandex_compute_instance
variable "vm_web_instance" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name web instance"
}

variable "vm_web_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}
...
```

6. Проверьте terraform plan (изменений быть не должно). 
```
Plan: 3 to add, 0 to change, 0 to destroy.
```


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле.
```
# vm2
resource "yandex_compute_instance" "platform2" {
  name        = var.vm_db_instance
  platform_id = var.vm_db_platform
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
...
```
```
# переменные в vms_platform.tf
###yandex_compute_image

variable "vm_db_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "name web image"
}

###yandex_compute_instance
variable "vm_db_instance" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "name web instance"
}


variable "vm_db_platform" {
  type        = string
  default     = "standard-v1"
  description = "yandex platform id"
}
```
4. Примените изменения.
```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

### Задание 4

1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
```
output "ip_address_web" {
  value = yandex_compute_instance.platform.network_interface.0.ip_address
}

output "ip_address_db" {
  value = yandex_compute_instance.platform2.network_interface.0.ip_address
}
```

3. Примените изменения.
```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

ip_address_db = "10.0.1.4"
ip_address_web = "10.0.1.6"
```

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```
```
$ terraform output
ip_address_db = "10.0.1.4"
ip_address_web = "10.0.1.6"
```

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.


### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 7*

Изучите сожержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list?
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?
4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

В качестве решения предоставьте необходимые команды и их вывод.

------
### Правила приема работы

В git-репозитории, в котором было выполнено задание к занятию "Введение в Terraform", создайте новую ветку terraform-02, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-02.

В качестве результата прикрепите ссылку на ветку terraform-02 в вашем репозитории.

**ВАЖНО!Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 

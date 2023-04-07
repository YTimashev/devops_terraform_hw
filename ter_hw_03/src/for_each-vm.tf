resource "yandex_compute_instance" "web" {
  #Ждем создания инстанса db
  depends_on = [yandex_compute_instance.db]

  for_each = { for key, val in var.resources_web : key => val }
  name     = "netology-develop-platform-web-${each.value.vm_name}"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = each.value.disk
    }
  }

  /*
  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }
*/

  metadata = {
    ssh-keys = "ubuntu:${local.file_content}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true

}


variable "resources_web" {
  description = "Ресурсы BM web"
  type = list(object(
    {
      vm_name       = string
      cpu           = number
      ram           = number
      disk          = number
      core_fraction = number
    }
  ))

  default = [
    {
      vm_name       = "first"
      cpu           = 2
      ram           = 1
      disk          = 5
      core_fraction = 5
    },
    {
      vm_name       = "second"
      cpu           = 4
      ram           = 2
      disk          = 8
      core_fraction = 20
    }
  ]
}


#file(path): читает содержимое файла по заданному пути и возвращает его в виде строки
locals {
  #file_content = "${file(~/.ssh/id_rsa.pub)}"
  file_content = file("~/.ssh/id_rsa.pub")
}

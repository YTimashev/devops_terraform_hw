
#Создаем ВМ
resource "yandex_compute_instance" "vm_fri_disks" {
  #depends_on  = [yandex_compute_disk.volume]
  name        = "vm-fri-disks"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }


  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }


  metadata = {
    ssh-keys = "ubuntu:${local.file_content}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true


  #Подключаем дополнительный диск
  dynamic "secondary_disk" {
    for_each = toset([0, 1, 2])
    content {
      disk_id     = yandex_compute_disk.volume[0].id
      auto_delete = true
    }
  }
}


# создаем 3 дополнительных диска
resource "yandex_compute_disk" "volume" {
  count = 3
  name  = "disk-${count.index}"
  type  = "network-hdd"
  zone  = var.default_zone
  size  = 1
}

/*
#Переменная - дополнительные диски
variable "volumes" {
  type    = list(string)
  default = ["disk-0", "disk-1", "disk-2"]
}
*/

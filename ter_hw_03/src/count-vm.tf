resource "yandex_compute_instance" "db" {
  count       = 2
  name        = "netology-develop-platform-db-${count.index}"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
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

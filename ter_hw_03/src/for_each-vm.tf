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

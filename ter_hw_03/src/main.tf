resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}

###
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
  { webservers = [yandex_compute_instance.db[0], yandex_compute_instance.db[1], yandex_compute_instance.web[0], yandex_compute_instance.web[1]] })
  filename = "${abspath(path.module)}/hosts.cfg"
}

/*
variable "all_vm_ip" {
  type    = list(any)
  default = ["yandex_compute_instance.db[0]", "yandex_compute_instance.db[1]", "yandex_compute_instance.web[0]", "yandex_compute_instance.web[1]"]
}
*/

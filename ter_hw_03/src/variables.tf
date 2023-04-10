###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

/*
variable "public_key" {
  type    = string
  default = "ubuntu:~/.ssh/id_rsa.pub"
}
*/

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

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

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7G3Q7qhjk+7/ne6W7hFUm9Lba2mPx8pxhdwYo9rB06WdNAMMuxYk774uxSH5grJodC2Tz338/pe2SkLUcdyFnwrZItJTKH75icZ2kL3f3arhScFwO3+6vw7E1JTDkJ9Nf4m98kr6eTlWpqzq0J1k6Uh+9TtUY0UjRq1uvkM9c67hHM8Nl3vNU0GSKYGH+izSnpN7A6FjXVcJvtvAIhCyRdBfka/XvVS8Zh6cJLmLbc+4NQvMtuBbpOmCadp+QOra/cEcVZGPyTVYd5x8xkU5CYqqpxTy/3MLGhMSp0B7E1Myk9cWpCYooyU3r7WqaDr6WHxwxEX53AHpH35hPXp2okVMrVnahOhwhXay2PSr+0H/9Zjh8IERdUNX5QVILORIBpH7JqsFcgV3W+JKyx6MbkZVCQwo+rGnCnij08jhIu3mOQoK+hbPX5l+ZfHO0k+M4d/cm6X7b0nPXVZVESI62jYTtzTD8G69z6svjBZM0GqsNQwztB5+7wr8qhYXyb58= tim@tim"
}

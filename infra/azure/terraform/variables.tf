variable "region" {
  description = "Azure region"
  type        = string
  default     = "Korea Central"
}

variable "vm_size" {
  description = "VM Size"
  type        = string
  
  # 2 Cores / 8GB Memory
  default     = "Standard_D2s_v3"
}

variable "vm_image" {
  description = "VM Image"
  type        = map(string)
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# GitHub Actions 접속을 위해 임시 개방
variable "storage_network_action" {
  description = "Storage Network Default Action (Allow/Deny)"
  type        = string
  default     = "Allow" # Azure 배포 완료되면 'Deny'로 변경 후 재배포 (외부 접근 차단)
}

# Github Secrets를 통해 배포될 때 주입
variable "public_key" {
  description = "Public Key"
  type        = string
}

variable "admin_name" {
  description = "관리자 계정명"
  type        = string
  default     = "palja"
}

variable "onprem_ip" {
  description = "온프레미스(차량 시뮬레이터) 공인 IP"
  type        = string
}
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

# 원본 데이터 저장 스토리지 계정 생성
resource "azurerm_storage_account" "raw_storage" {
  name                     = "vehicleraw${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # 비용 최적화: LRS (Locally Redundant Storage)

  # 일반 스토리지를 Data Lake Gen2로 변경
  is_hns_enabled           = true

  network_rules {
    default_action             = "Deny" # 기본적으로 외부 인터넷 접속 모두 차단
    virtual_network_subnet_ids = [azurerm_subnet.consumer_subnet.id] # 오직 컨슈머 서브넷만 허용
  }

  tags = {
    environment = "dev"
    purpose     = "raw-data-lake"
  }
}

# 데이터를 담을 Data Lake Gen2 전용 파일 시스템(컨테이너) 생성
resource "azurerm_storage_data_lake_gen2_filesystem" "raw_filesystem" {
  name                  = "raw-topic-container"
  storage_account_id    = azurerm_storage_account.raw_storage.id
}
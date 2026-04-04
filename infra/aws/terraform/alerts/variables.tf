variable "aws_region" {
  description = "AWS region for alerts resources."
  type        = string
  default     = "ap-northeast-2"
}

variable "name_prefix" {
  description = "Prefix used for alerts resource names."
  type        = string
  default     = "ktcloud2nd"
}

variable "network_state_bucket" {
  description = "S3 bucket that stores the network terraform state file."
  type        = string
  default     = "palja-terraform-backend"
}

variable "network_state_key" {
  description = "S3 object key for the network terraform state file."
  type        = string
  default     = "aws/network/terraform.tfstate"
}

variable "network_state_region" {
  description = "AWS region of the S3 bucket that stores the network terraform state file."
  type        = string
  default     = "ap-northeast-2"
}

variable "network_state_access_key" {
  description = "Access key used to read the network terraform state from the tfstate S3 account."
  type        = string
  sensitive   = true
}

variable "network_state_secret_key" {
  description = "Secret key used to read the network terraform state from the tfstate S3 account."
  type        = string
  sensitive   = true
}


variable "slack_webhook_url" {
  description = "Slack incoming webhook URL used for anomaly notifications."
  type        = string
  sensitive   = true
}

variable "alert_webhook_token" {
  description = "Shared secret token used by Azure to authenticate anomaly webhook requests."
  type        = string
  sensitive   = true
}

variable "lambda_timeout_seconds" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda memory size in MB."
  type        = number
  default     = 256
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Additional tags applied to all alerts resources."
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "infra3"
    Service     = "alerts"
  }
}

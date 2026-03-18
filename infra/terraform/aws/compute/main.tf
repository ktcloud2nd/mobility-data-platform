# 1. 인프라 1(Network)의 정보를 가져오는 통로 설정
data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

# 2. 사용할 변수 정의
variable "instance_key_name" {
  description = "EC2에 접속하기 위한 기존 AWS 키페어 이름"
  type        = string
  default     = "8team-key" 
}

# 3. Bastion Host (Remote State 참조)
resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = var.instance_key_name

  # network의 output인 public_subnet_ids 리스트 중 첫 번째 값 사용
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_ids.bastion]

  tags = {
    Name = "${var.name_prefix}-bastion"
    Tier = "public"
  }
}

# 4. K3s Master Node (Remote State 참조)
resource "aws_instance" "k3s_master" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.medium"
  key_name      = var.instance_key_name

  # network의 output인 private_app_subnet_ids 리스트 중 첫 번째 값 사용
  subnet_id              = data.terraform_remote_state.network.outputs.private_app_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_ids.k3s_nodes]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3
              EOF

  tags = {
    Name = "${var.name_prefix}-k3s-master"
    Role = "master"
  }
}

# 5. K3s Worker Nodes (Launch Template & ASG)
resource "aws_launch_template" "k3s_worker_lt" {
  name_prefix   = "${var.name_prefix}-k3s-worker-lt-"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t3.medium"
  key_name      = var.instance_key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [data.terraform_remote_state.network.outputs.security_group_ids.k3s_nodes]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-k3s-worker"
      Role = "worker"
    }
  }
}

resource "aws_autoscaling_group" "k3s_worker_asg" {
  name                = "${var.name_prefix}-k3s-worker-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  
  # network의 모든 프라이빗 앱 서브넷 리스트 참조
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_app_subnet_ids

  launch_template {
    id      = aws_launch_template.k3s_worker_lt.id
    version = "$Latest"
  }
}
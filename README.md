# ktcloud2nd

멀티클라우드 기반 차량 데이터 플랫폼 2차 프로젝트 저장소입니다.

현재 저장소는 멀티클라우드 기반 차량 데이터 플랫폼의 애플리케이션, AWS·Azure 인프라 코드, 엣지 실행 환경, Kubernetes 배포 리소스, 운영 자동화 구성을 함께 관리하는 통합 저장소입니다. `apps/web-platform`, `infra/aws`, `infra/azure`, `infra/edge`, `k8s`를 중심으로 서비스 구현과 배포 구성이 정리되어 있습니다.

## Repository Layout

```text
├── .github/
│   └── workflows/
│       ├── aws-app-deploy.yml
│       ├── aws-deploy.yml
│       ├── azure-deploy.yml
│       └── README.md
├── apps/
│   └── web-platform/
│       ├── backend/
│       ├── frontend/
│       ├── .env.example
│       ├── deploy.env.example
│       ├── docker-compose.deployment.yml
│       └── package-lock.json
├── infra/
│   ├── aws/
│   │   ├── ansible/
│   │   ├── lambda/
│   │   └── terraform/
│   ├── azure/
│   │   ├── ansible/
│   │   ├── scripts/
│   │   └── terraform/
│   └── edge/
│       ├── docker-compose.yml
│       ├── Dockerfile
│       ├── README.md
│       └── vehicle_simulator.py
├── k8s/
│   ├── backend-login/
│   ├── backend-operator/
│   ├── backend-user/
│   ├── frontend-operator-app/
│   └── frontend-user-app/
├── .gitignore
├── AGENTS.md
└── README.md
```

## Branch Strategy

- `main`: 리뷰 후 병합되는 기본 브랜치
- `feature/aws-network`: 인프라 1 네트워크 작업
- `feature/aws-compute`: 인프라 2 플랫폼 작업
- `feature/aws-data`: 인프라 3 데이터 계층 작업
- `feature/aws-dashboard-cicd`: 인프라 4 배포 및 CI/CD 작업

## Tech Stack

- `apps/web-platform/frontend`: React 18, React Router, Vite, Tailwind CSS, PostCSS
- `apps/web-platform/backend`: Node.js, Express, PostgreSQL(`pg`), dotenv, CORS
- `infra/aws/terraform`: Terraform, AWS VPC, NAT Gateway, ALB, Route 53, RDS PostgreSQL, EC2, Auto Scaling Group, NLB, Lambda Function URL
- `infra/aws/ansible`: Ansible, K3s, Argo CD, Linkerd, Prometheus, Cluster Autoscaler, AWS CCM
- `infra/aws/lambda`: Node.js Lambda 기반 Slack anomaly notifier
- `infra/azure/terraform`: Terraform, Azure 네트워크, Bastion 접근 구조, 브로커/컨슈머 VM 인프라
- `infra/azure/ansible`: Ansible, Docker, Kafka Broker, Kafka Connect 기반 Consumer 배포 자동화
- `infra/edge`: Docker Compose, Python 차량 시뮬레이터
- `k8s`: Kubernetes manifests, Ingress, HPA, 서비스별 배포 리소스
- `.github/workflows`: GitHub Actions 기반 AWS/Azure 배포 자동화

## Project Flow

1. `infra/edge/vehicle_simulator.py`가 차량 단말 역할을 하면서 속도, 위치, 연료량, 주행 상태, 이상 이벤트 후보 데이터를 계속 생성합니다.
2. 이 시뮬레이터는 `infra/edge/docker-compose.yml`로 실행되며, Azure 쪽 Kafka 브로커로 메시지를 보내는 실시간 데이터 발생 지점입니다.
3. Azure 배포 파이프라인은 브로커 VM과 컨슈머 VM을 만들고, Ansible로 Kafka Broker와 Kafka Connect 기반 Consumer 환경을 올립니다.
4. Azure Consumer는 Kafka Connect 커넥터를 통해 수집 데이터를 두 갈래로 보냅니다.
5. 원본 이벤트는 Azure Data Lake sink 커넥터로 적재되어 raw 데이터 보관 용도로 사용됩니다.
6. 정제된 차량 상태 데이터는 JDBC sink를 통해 AWS RDS PostgreSQL의 `vehicle_stats` 테이블로 들어갑니다.
7. 이상 탐지 데이터는 별도 JDBC sink를 통해 같은 RDS의 `vehicle_anomaly_alerts` 테이블로 들어갑니다.
8. AWS 쪽에서는 Terraform으로 네트워크, 데이터, 컴퓨트, 알림 인프라를 순서대로 구성합니다.
9. 네트워크 계층은 VPC, 퍼블릭/프라이빗 서브넷, 라우팅, NAT Gateway, ALB, Route 53 등 서비스 공통 기반을 제공합니다.
10. 데이터 계층은 RDS PostgreSQL과 DB Subnet Group, 프라이빗 DNS 레코드, SSM 파라미터를 구성해 애플리케이션이 참조할 데이터 저장소를 준비합니다.
11. 컴퓨트 계층은 K3s 마스터 노드, user/operator 워커 ASG, 내부 NLB를 구성해 Kubernetes 실행 환경을 만듭니다.
12. AWS Ansible은 K3s 설치 이후 Argo CD, Linkerd, Prometheus, AWS CCM, Cluster Autoscaler 같은 운영 구성 요소를 클러스터에 배포합니다.
13. `k8s` 디렉터리의 매니페스트는 로그인 백엔드, 사용자 백엔드, 운영자 백엔드와 각 프론트엔드 앱을 user/operator 역할에 맞게 배포합니다.
14. 백엔드는 Express 기반 단일 코드베이스를 `APP_TARGET` 값으로 나눠 로그인, 사용자, 운영자 API를 각각 제공합니다.
15. 이 백엔드는 `accounts`, `user_vehicle_mapping`, `vehicle_stats`, `vehicle_anomaly_alerts` 같은 PostgreSQL 데이터를 조회해 사용자 대시보드와 운영자 화면을 구성합니다.
16. 사용자 화면은 본인 차량 기준 최신 상태, 최근 주행 기록, 연료량, 이동 거리, 최근 알림을 보여줍니다.
17. 운영자 화면은 이상 탐지 집계, 차량 모니터링, Grafana 임베드 기반 인프라 대시보드를 제공합니다.
18. AWS Lambda 알림 함수는 HTTP 요청을 받아 이상 탐지 payload를 검증한 뒤 Slack 웹훅으로 운영 알림을 전송합니다.
19. GitHub Actions는 Azure 인프라와 이미지 빌드, AWS Terraform 적용, 앱 이미지 배포를 자동화해 전체 파이프라인 변경 사항을 실제 환경에 반영합니다.

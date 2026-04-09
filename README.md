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
- `infra/aws/terraform`: Terraform, AWS VPC, NAT Gateway, ALB, Route 53, S3 Gateway Endpoint, RDS PostgreSQL, EC2, Auto Scaling Group, NLB
- `infra/aws/ansible`: Ansible, K3s, Argo CD, Linkerd, Prometheus, Cluster Autoscaler, AWS CCM
- `infra/aws/lambda`: Node.js Lambda 기반 Slack anomaly notifier
- `infra/azure/terraform`: Terraform, Azure 네트워크, Bastion 접근 구조, 브로커/컨슈머 인프라
- `infra/azure/ansible`: Ansible, Docker, Kafka Broker, Kafka Consumer 배포 자동화
- `infra/edge`: Docker Compose, Python 차량 시뮬레이터
- `k8s`: Kubernetes manifests, Ingress, HPA, 서비스별 배포 리소스
- `.github/workflows`: GitHub Actions 기반 AWS/Azure 배포 자동화

## Project Flow

1. `infra/edge`의 차량 시뮬레이터가 실제 차량 단말처럼 속도, 위치, 연료량, 이상 상황 같은 데이터를 주기적으로 생성합니다.
2. 생성된 이벤트는 Docker 기반 Edge 실행 환경에서 외부 브로커로 전송되며, 프로젝트의 실시간 데이터 유입 시작점 역할을 합니다.
3. Azure 영역에서는 브로커와 컨슈머가 이 데이터를 수신하고, 원시 이벤트를 후속 처리 가능한 형태로 정리하는 중간 파이프라인을 담당합니다.
4. 이 단계에서 데이터는 단순 수집에 그치지 않고, 대시보드 조회와 이상 탐지에 필요한 형태로 가공되어 저장 계층으로 전달됩니다.
5. AWS 쪽 Terraform 네트워크 모듈은 VPC, 퍼블릭/프라이빗 서브넷, 라우팅, NAT Gateway, ALB, Route 53, S3 Gateway Endpoint 같은 서비스 공통 기반을 먼저 구성합니다.
6. 데이터 계층에서는 S3와 RDS PostgreSQL을 사용해 정제 데이터 보관과 조회용 서빙 데이터를 분리하고, 대시보드가 바로 조회할 수 있는 구조를 유지합니다.
7. 컴퓨트 계층에서는 EC2 기반 K3s 마스터 노드와 워커 노드 Auto Scaling Group을 구성해 user 영역과 operator 영역이 분리된 실행 환경을 만듭니다.
8. 내부 NLB와 보안그룹, 노드 역할 분리 정책을 통해 클러스터 통신과 서비스 운영 경로를 안정적으로 유지합니다.
9. Ansible은 K3s 설치, 클러스터 초기 설정, Argo CD, Linkerd, Prometheus, Cluster Autoscaler 같은 운영 구성 요소 배포를 자동화합니다.
10. 이후 `k8s` 매니페스트가 로그인 백엔드, 사용자 백엔드, 운영자 백엔드와 각 프론트엔드 앱을 클러스터에 배포합니다.
11. 프론트엔드는 React 기반으로 사용자용 화면과 운영자용 화면을 제공하고, 백엔드 API를 통해 로그인, 차량 상태 조회, 이상 이벤트 조회, 운영 대시보드 기능을 사용합니다.
12. 백엔드는 Express와 PostgreSQL을 기반으로 인증, 세션 검증, 차량 대시보드 데이터 조회, 운영자용 집계 데이터 제공, Grafana 임베드 연동을 처리합니다.
13. 운영자는 Grafana와 인프라 대시보드를 통해 시스템 상태를 확인하고, 사용자 영역은 차량 정보와 알림 중심의 화면을 제공받습니다.
14. GitHub Actions 워크플로는 AWS/Azure 인프라 배포와 애플리케이션 배포를 연결해 코드 변경이 실제 실행 환경에 반영되는 자동화 경로를 담당합니다.

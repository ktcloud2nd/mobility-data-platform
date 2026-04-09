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
├── .gitignore
├── AGENTS.md
├── README.md
├── apps/
│   └── web-platform/
│       ├── .env.example
│       ├── deploy.env.example
│       ├── docker-compose.deployment.yml
│       ├── package-lock.json
│       ├── backend/
│       │   ├── .dockerignore
│       │   ├── .env.example
│       │   ├── Dockerfile
│       │   ├── package-lock.json
│       │   ├── package.json
│       │   └── src/
│       │       ├── anomalyDashboard.js
│       │       ├── authSecurity.js
│       │       ├── db.js
│       │       ├── grafana.js
│       │       ├── initSchema.js
│       │       ├── operatorVehicleDashboard.js
│       │       ├── server.js
│       │       └── userDashboard.js
│       └── frontend/
│           ├── .dockerignore
│           ├── .env.example
│           ├── Dockerfile
│           ├── index.html
│           ├── nginx-login.conf
│           ├── nginx-operator.conf
│           ├── nginx-user.conf
│           ├── nginx.conf
│           ├── nginx.login-operator.conf
│           ├── nginx.login.conf
│           ├── nginx.operator.conf
│           ├── nginx.user.conf
│           ├── package-lock.json
│           ├── package.json
│           ├── postcss.config.js
│           ├── tailwind.config.js
│           ├── vite.config.js
│           ├── public/
│           │   └── models/
│           │       ├── avante.png
│           │       ├── grandeur.png
│           │       ├── santafe.png
│           │       └── tucson.png
│           └── src/
│               ├── App.jsx
│               ├── index.css
│               ├── main.jsx
│               ├── api/
│               │   ├── anomalyDashboard.js
│               │   ├── auth.js
│               │   ├── grafana.js
│               │   ├── operatorVehicleDashboard.js
│               │   ├── sessionRequest.js
│               │   └── userDashboard.js
│               ├── components/
│               │   ├── AppRedirect.jsx
│               │   ├── DashboardLayout.jsx
│               │   └── GrafanaEmbedFrame.jsx
│               ├── config/
│               │   └── appTarget.js
│               ├── pages/
│               │   ├── auth/
│               │   │   └── LoginPage.jsx
│               │   ├── operator/
│               │   │   ├── OperatorAnomalyPage.jsx
│               │   │   ├── OperatorDashboardPage.jsx
│               │   │   ├── OperatorInfraServicePage.jsx
│               │   │   └── OperatorVehiclePage.jsx
│               │   └── user/
│               │       └── UserDashboardPage.jsx
│               ├── routes/
│               │   ├── AppRouter.jsx
│               │   └── ProtectedRoute.jsx
│               └── utils/
│                   └── authStorage.js
├── infra/
│   ├── aws/
│   │   ├── ansible/
│   │   │   ├── ansible.cfg
│   │   │   ├── README.md
│   │   │   ├── playbooks/
│   │   │   │   ├── README.md
│   │   │   │   └── setup_k3s_cluster.yml
│   │   │   ├── roles/
│   │   │   │   ├── README.md
│   │   │   │   ├── argocd/
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── aws-ccm/
│   │   │   │   │   ├── files/
│   │   │   │   │   │   └── aws-ccm-values.yaml
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── cluster-autoscaler/
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── db_setup/
│   │   │   │   │   ├── defaults/
│   │   │   │   │   │   └── main.yml
│   │   │   │   │   ├── files/
│   │   │   │   │   │   └── schema.sql
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── k3s_master/
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── linkerd/
│   │   │   │   │   └── tasks/
│   │   │   │   │       └── main.yml
│   │   │   │   ├── prometheus/
│   │   │   │   │   ├── files/
│   │   │   │   │   │   ├── kube-prometheus-stack-values.yaml
│   │   │   │   │   │   └── grafana-dashboards/
│   │   │   │   │   │       └── k3s-infra-overview.json
│   │   │   │   │   ├── tasks/
│   │   │   │   │   │   └── main.yml
│   │   │   │   │   └── templates/
│   │   │   │   │       └── grafana-dashboard-k3s-infra-overview-configmap.yaml.j2
│   │   │   │   └── web_platform_env/
│   │   │   │       └── tasks/
│   │   │   │           └── main.yml
│   │   │   └── vault/
│   │   │       └── vault.yml
│   │   ├── lambda/
│   │   │   └── slack-anomaly-notifier/
│   │   │       ├── index.mjs
│   │   │       ├── package-lock.json
│   │   │       └── package.json
│   │   └── terraform/
│   │       ├── alerts/
│   │       │   ├── lambda.tf
│   │       │   ├── outputs.tf
│   │       │   ├── provider.tf
│   │       │   ├── terraform.tfvars.example
│   │       │   └── variables.tf
│   │       ├── compute/
│   │       │   ├── .terraform.lock.hcl
│   │       │   ├── ansible_inventory.tf
│   │       │   ├── iam.tf
│   │       │   ├── main.tf
│   │       │   ├── outputs.tf
│   │       │   ├── provider.tf
│   │       │   ├── README.md
│   │       │   ├── remote_state.tf
│   │       │   ├── terraform.tfvars.example
│   │       │   └── variables.tf
│   │       ├── data/
│   │       │   ├── .terraform.lock.hcl
│   │       │   ├── main.tf
│   │       │   ├── outputs.tf
│   │       │   ├── provider.tf
│   │       │   ├── README.md
│   │       │   ├── terraform.tfvars.example
│   │       │   └── variables.tf
│   │       └── network/
│   │           ├── .terraform.lock.hcl
│   │           ├── checks.tf
│   │           ├── main.tf
│   │           ├── outputs.tf
│   │           ├── provider.tf
│   │           ├── README.md
│   │           ├── terraform.tfvars.example
│   │           └── variables.tf
│   ├── azure/
│   │   ├── ansible/
│   │   │   ├── playbook.yml
│   │   │   └── roles/
│   │   │       ├── docker/
│   │   │       │   └── tasks/
│   │   │       │       └── main.yml
│   │   │       ├── kafka-broker/
│   │   │       │   ├── tasks/
│   │   │       │   │   └── main.yml
│   │   │       │   └── templates/
│   │   │       │       └── docker-compose.yml.j2
│   │   │       └── kafka-consumer/
│   │   │           ├── files/
│   │   │           │   ├── processor.py
│   │   │           │   └── requirements.txt
│   │   │           ├── tasks/
│   │   │           │   └── main.yml
│   │   │           └── templates/
│   │   │               ├── docker-compose.yml.j2
│   │   │               └── Dockerfile.j2
│   │   ├── scripts/
│   │   │   └── install-self-hosted-runner.sh
│   │   └── terraform/
│   │       ├── bastion.tf
│   │       ├── broker.tf
│   │       ├── connect.tf
│   │       ├── consumer.tf
│   │       ├── network.tf
│   │       ├── outputs.tf
│   │       ├── providers.tf
│   │       ├── README.md
│   │       ├── storage.tf
│   │       └── variables.tf
│   └── edge/
│       ├── docker-compose.yml
│       ├── Dockerfile
│       ├── README.md
│       └── vehicle_simulator.py
└── k8s/
    ├── backend-login/
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── rds-env.example.yaml
    │   └── service.yaml
    ├── backend-operator/
    │   ├── deployment.yaml
    │   ├── rds-env.example.yaml
    │   └── service.yaml
    ├── backend-user/
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── rds-env.example.yaml
    │   └── service.yaml
    ├── frontend-operator-app/
    │   ├── coraza-middleware.yml
    │   ├── deployment.yaml
    │   ├── grafana-ingress.yml
    │   ├── linkerd-viz-ingress.yml
    │   ├── operator-ingress.yml
    │   └── service.yaml
    └── frontend-user-app/
        ├── coraza-middleware.yml
        ├── deployment.yaml
        ├── hpa.yaml
        ├── service.yaml
        └── user-ingress.yml
```

## Branch Strategy

- `main`: 리뷰 후 병합되는 기본 브랜치
- `feature/aws-network`: 인프라 1 네트워크 작업
- `feature/aws-compute`: 인프라 2 플랫폼 작업
- `feature/aws-data`: 인프라 3 데이터 계층 작업
- `feature/aws-dashboard-cicd`: 인프라 4 배포 및 CI/CD 작업

## Infra 1 Quick Start

1. `docs/network-matrix.md`에서 CIDR, AZ, 보안그룹 규칙을 팀 기준으로 확정합니다.
2. `infra/aws/terraform/network/terraform.tfvars.example`를 복사해 실제 값으로 수정합니다.
3. `infra/aws/terraform/network`에서 Terraform plan으로 네트워크 베이스라인을 검증합니다.
4. ALB Listener, Target Group, WAF 연동은 플랫폼/배포 흐름이 정리된 뒤 이어서 붙입니다.

## Notes

- 시크릿, 실제 관리자 IP, 실제 계정 정보는 커밋하지 않습니다.
- `docs/*`는 발표 자료 초안이 아니라 구현 기준 문서로 유지합니다.
- `infra/aws/terraform/network`는 현재 VPC, 서브넷, 라우팅, NAT, S3 Endpoint, 보안그룹, ALB 베이스라인까지 포함합니다.

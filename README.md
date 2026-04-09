# ktcloud2nd

멀티클라우드 기반 차량 데이터 플랫폼 2차 프로젝트 저장소입니다.

현재 저장소는 멀티클라우드 기반 차량 데이터 플랫폼의 애플리케이션, AWS·Azure 인프라 코드, 엣지 실행 환경, Kubernetes 배포 리소스, 운영 자동화 구성을 함께 관리하는 통합 저장소입니다. `apps/web-platform`, `infra/aws`, `infra/azure`, `infra/edge`, `k8s`를 중심으로 서비스 구현과 배포 구성이 정리되어 있습니다.

## Repository Layout

다크 테마 기준으로 폴더는 파란색, 파일은 흰색으로 구분했습니다.

<pre>
├── <span style="color:#58a6ff;">.github/</span>
│   └── <span style="color:#58a6ff;">workflows/</span>
│       ├── <span style="color:#f0f6fc;">aws-app-deploy.yml</span>
│       ├── <span style="color:#f0f6fc;">aws-deploy.yml</span>
│       ├── <span style="color:#f0f6fc;">azure-deploy.yml</span>
│       └── <span style="color:#f0f6fc;">README.md</span>
├── <span style="color:#f0f6fc;">.gitignore</span>
├── <span style="color:#f0f6fc;">AGENTS.md</span>
├── <span style="color:#f0f6fc;">README.md</span>
├── <span style="color:#58a6ff;">apps/</span>
│   └── <span style="color:#58a6ff;">web-platform/</span>
│       ├── <span style="color:#f0f6fc;">.env.example</span>
│       ├── <span style="color:#f0f6fc;">deploy.env.example</span>
│       ├── <span style="color:#f0f6fc;">docker-compose.deployment.yml</span>
│       ├── <span style="color:#f0f6fc;">package-lock.json</span>
│       ├── <span style="color:#58a6ff;">backend/</span>
│       │   ├── <span style="color:#f0f6fc;">.dockerignore</span>
│       │   ├── <span style="color:#f0f6fc;">.env.example</span>
│       │   ├── <span style="color:#f0f6fc;">Dockerfile</span>
│       │   ├── <span style="color:#f0f6fc;">package-lock.json</span>
│       │   ├── <span style="color:#f0f6fc;">package.json</span>
│       │   └── <span style="color:#58a6ff;">src/</span>
│       │       ├── <span style="color:#f0f6fc;">anomalyDashboard.js</span>
│       │       ├── <span style="color:#f0f6fc;">authSecurity.js</span>
│       │       ├── <span style="color:#f0f6fc;">db.js</span>
│       │       ├── <span style="color:#f0f6fc;">grafana.js</span>
│       │       ├── <span style="color:#f0f6fc;">initSchema.js</span>
│       │       ├── <span style="color:#f0f6fc;">operatorVehicleDashboard.js</span>
│       │       ├── <span style="color:#f0f6fc;">server.js</span>
│       │       └── <span style="color:#f0f6fc;">userDashboard.js</span>
│       └── <span style="color:#58a6ff;">frontend/</span>
│           ├── <span style="color:#f0f6fc;">.dockerignore</span>
│           ├── <span style="color:#f0f6fc;">.env.example</span>
│           ├── <span style="color:#f0f6fc;">Dockerfile</span>
│           ├── <span style="color:#f0f6fc;">index.html</span>
│           ├── <span style="color:#f0f6fc;">nginx-login.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx-operator.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx-user.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx.login-operator.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx.login.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx.operator.conf</span>
│           ├── <span style="color:#f0f6fc;">nginx.user.conf</span>
│           ├── <span style="color:#f0f6fc;">package-lock.json</span>
│           ├── <span style="color:#f0f6fc;">package.json</span>
│           ├── <span style="color:#f0f6fc;">postcss.config.js</span>
│           ├── <span style="color:#f0f6fc;">tailwind.config.js</span>
│           ├── <span style="color:#f0f6fc;">vite.config.js</span>
│           ├── <span style="color:#58a6ff;">public/</span>
│           │   └── <span style="color:#58a6ff;">models/</span>
│           │       ├── <span style="color:#f0f6fc;">avante.png</span>
│           │       ├── <span style="color:#f0f6fc;">grandeur.png</span>
│           │       ├── <span style="color:#f0f6fc;">santafe.png</span>
│           │       └── <span style="color:#f0f6fc;">tucson.png</span>
│           └── <span style="color:#58a6ff;">src/</span>
│               ├── <span style="color:#f0f6fc;">App.jsx</span>
│               ├── <span style="color:#f0f6fc;">index.css</span>
│               ├── <span style="color:#f0f6fc;">main.jsx</span>
│               ├── <span style="color:#58a6ff;">api/</span>
│               │   ├── <span style="color:#f0f6fc;">anomalyDashboard.js</span>
│               │   ├── <span style="color:#f0f6fc;">auth.js</span>
│               │   ├── <span style="color:#f0f6fc;">grafana.js</span>
│               │   ├── <span style="color:#f0f6fc;">operatorVehicleDashboard.js</span>
│               │   ├── <span style="color:#f0f6fc;">sessionRequest.js</span>
│               │   └── <span style="color:#f0f6fc;">userDashboard.js</span>
│               ├── <span style="color:#58a6ff;">components/</span>
│               │   ├── <span style="color:#f0f6fc;">AppRedirect.jsx</span>
│               │   ├── <span style="color:#f0f6fc;">DashboardLayout.jsx</span>
│               │   └── <span style="color:#f0f6fc;">GrafanaEmbedFrame.jsx</span>
│               ├── <span style="color:#58a6ff;">config/</span>
│               │   └── <span style="color:#f0f6fc;">appTarget.js</span>
│               ├── <span style="color:#58a6ff;">pages/</span>
│               │   ├── <span style="color:#58a6ff;">auth/</span>
│               │   │   └── <span style="color:#f0f6fc;">LoginPage.jsx</span>
│               │   ├── <span style="color:#58a6ff;">operator/</span>
│               │   │   ├── <span style="color:#f0f6fc;">OperatorAnomalyPage.jsx</span>
│               │   │   ├── <span style="color:#f0f6fc;">OperatorDashboardPage.jsx</span>
│               │   │   ├── <span style="color:#f0f6fc;">OperatorInfraServicePage.jsx</span>
│               │   │   └── <span style="color:#f0f6fc;">OperatorVehiclePage.jsx</span>
│               │   └── <span style="color:#58a6ff;">user/</span>
│               │       └── <span style="color:#f0f6fc;">UserDashboardPage.jsx</span>
│               ├── <span style="color:#58a6ff;">routes/</span>
│               │   ├── <span style="color:#f0f6fc;">AppRouter.jsx</span>
│               │   └── <span style="color:#f0f6fc;">ProtectedRoute.jsx</span>
│               └── <span style="color:#58a6ff;">utils/</span>
│                   └── <span style="color:#f0f6fc;">authStorage.js</span>
├── <span style="color:#58a6ff;">infra/</span>
│   ├── <span style="color:#58a6ff;">aws/</span>
│   │   ├── <span style="color:#58a6ff;">ansible/</span>
│   │   │   ├── <span style="color:#f0f6fc;">ansible.cfg</span>
│   │   │   ├── <span style="color:#f0f6fc;">README.md</span>
│   │   │   ├── <span style="color:#58a6ff;">playbooks/</span>
│   │   │   │   ├── <span style="color:#f0f6fc;">README.md</span>
│   │   │   │   └── <span style="color:#f0f6fc;">setup_k3s_cluster.yml</span>
│   │   │   ├── <span style="color:#58a6ff;">roles/</span>
│   │   │   │   ├── <span style="color:#f0f6fc;">README.md</span>
│   │   │   │   ├── <span style="color:#58a6ff;">argocd/</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">aws-ccm/</span>
│   │   │   │   │   ├── <span style="color:#58a6ff;">files/</span>
│   │   │   │   │   │   └── <span style="color:#f0f6fc;">aws-ccm-values.yaml</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">cluster-autoscaler/</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">db_setup/</span>
│   │   │   │   │   ├── <span style="color:#58a6ff;">defaults/</span>
│   │   │   │   │   │   └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   │   ├── <span style="color:#58a6ff;">files/</span>
│   │   │   │   │   │   └── <span style="color:#f0f6fc;">schema.sql</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">k3s_master/</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">linkerd/</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   ├── <span style="color:#58a6ff;">prometheus/</span>
│   │   │   │   │   ├── <span style="color:#58a6ff;">files/</span>
│   │   │   │   │   │   ├── <span style="color:#f0f6fc;">kube-prometheus-stack-values.yaml</span>
│   │   │   │   │   │   └── <span style="color:#58a6ff;">grafana-dashboards/</span>
│   │   │   │   │   │       └── <span style="color:#f0f6fc;">k3s-infra-overview.json</span>
│   │   │   │   │   ├── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │   │   │   └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   │   │   └── <span style="color:#58a6ff;">templates/</span>
│   │   │   │   │       └── <span style="color:#f0f6fc;">grafana-dashboard-k3s-infra-overview-configmap.yaml.j2</span>
│   │   │   │   └── <span style="color:#58a6ff;">web_platform_env/</span>
│   │   │   │       └── <span style="color:#58a6ff;">tasks/</span>
│   │   │   │           └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │   └── <span style="color:#58a6ff;">vault/</span>
│   │   │       └── <span style="color:#f0f6fc;">vault.yml</span>
│   │   ├── <span style="color:#58a6ff;">lambda/</span>
│   │   │   └── <span style="color:#58a6ff;">slack-anomaly-notifier/</span>
│   │   │       ├── <span style="color:#f0f6fc;">index.mjs</span>
│   │   │       ├── <span style="color:#f0f6fc;">package-lock.json</span>
│   │   │       └── <span style="color:#f0f6fc;">package.json</span>
│   │   └── <span style="color:#58a6ff;">terraform/</span>
│   │       ├── <span style="color:#58a6ff;">alerts/</span>
│   │       │   ├── <span style="color:#f0f6fc;">lambda.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">outputs.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">provider.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">terraform.tfvars.example</span>
│   │       │   └── <span style="color:#f0f6fc;">variables.tf</span>
│   │       ├── <span style="color:#58a6ff;">compute/</span>
│   │       │   ├── <span style="color:#f0f6fc;">.terraform.lock.hcl</span>
│   │       │   ├── <span style="color:#f0f6fc;">ansible_inventory.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">iam.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">main.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">outputs.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">provider.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">README.md</span>
│   │       │   ├── <span style="color:#f0f6fc;">remote_state.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">terraform.tfvars.example</span>
│   │       │   └── <span style="color:#f0f6fc;">variables.tf</span>
│   │       ├── <span style="color:#58a6ff;">data/</span>
│   │       │   ├── <span style="color:#f0f6fc;">.terraform.lock.hcl</span>
│   │       │   ├── <span style="color:#f0f6fc;">main.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">outputs.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">provider.tf</span>
│   │       │   ├── <span style="color:#f0f6fc;">README.md</span>
│   │       │   ├── <span style="color:#f0f6fc;">terraform.tfvars.example</span>
│   │       │   └── <span style="color:#f0f6fc;">variables.tf</span>
│   │       └── <span style="color:#58a6ff;">network/</span>
│   │           ├── <span style="color:#f0f6fc;">.terraform.lock.hcl</span>
│   │           ├── <span style="color:#f0f6fc;">checks.tf</span>
│   │           ├── <span style="color:#f0f6fc;">main.tf</span>
│   │           ├── <span style="color:#f0f6fc;">outputs.tf</span>
│   │           ├── <span style="color:#f0f6fc;">provider.tf</span>
│   │           ├── <span style="color:#f0f6fc;">README.md</span>
│   │           ├── <span style="color:#f0f6fc;">terraform.tfvars.example</span>
│   │           └── <span style="color:#f0f6fc;">variables.tf</span>
│   ├── <span style="color:#58a6ff;">azure/</span>
│   │   ├── <span style="color:#58a6ff;">ansible/</span>
│   │   │   ├── <span style="color:#f0f6fc;">playbook.yml</span>
│   │   │   └── <span style="color:#58a6ff;">roles/</span>
│   │   │       ├── <span style="color:#58a6ff;">docker/</span>
│   │   │       │   └── <span style="color:#58a6ff;">tasks/</span>
│   │   │       │       └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │       ├── <span style="color:#58a6ff;">kafka-broker/</span>
│   │   │       │   ├── <span style="color:#58a6ff;">tasks/</span>
│   │   │       │   │   └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │       │   └── <span style="color:#58a6ff;">templates/</span>
│   │   │       │       └── <span style="color:#f0f6fc;">docker-compose.yml.j2</span>
│   │   │       └── <span style="color:#58a6ff;">kafka-consumer/</span>
│   │   │           ├── <span style="color:#58a6ff;">files/</span>
│   │   │           │   ├── <span style="color:#f0f6fc;">processor.py</span>
│   │   │           │   └── <span style="color:#f0f6fc;">requirements.txt</span>
│   │   │           ├── <span style="color:#58a6ff;">tasks/</span>
│   │   │           │   └── <span style="color:#f0f6fc;">main.yml</span>
│   │   │           └── <span style="color:#58a6ff;">templates/</span>
│   │   │               ├── <span style="color:#f0f6fc;">docker-compose.yml.j2</span>
│   │   │               └── <span style="color:#f0f6fc;">Dockerfile.j2</span>
│   │   ├── <span style="color:#58a6ff;">scripts/</span>
│   │   │   └── <span style="color:#f0f6fc;">install-self-hosted-runner.sh</span>
│   │   └── <span style="color:#58a6ff;">terraform/</span>
│   │       ├── <span style="color:#f0f6fc;">bastion.tf</span>
│   │       ├── <span style="color:#f0f6fc;">broker.tf</span>
│   │       ├── <span style="color:#f0f6fc;">connect.tf</span>
│   │       ├── <span style="color:#f0f6fc;">consumer.tf</span>
│   │       ├── <span style="color:#f0f6fc;">network.tf</span>
│   │       ├── <span style="color:#f0f6fc;">outputs.tf</span>
│   │       ├── <span style="color:#f0f6fc;">providers.tf</span>
│   │       ├── <span style="color:#f0f6fc;">README.md</span>
│   │       ├── <span style="color:#f0f6fc;">storage.tf</span>
│   │       └── <span style="color:#f0f6fc;">variables.tf</span>
│   └── <span style="color:#58a6ff;">edge/</span>
│       ├── <span style="color:#f0f6fc;">docker-compose.yml</span>
│       ├── <span style="color:#f0f6fc;">Dockerfile</span>
│       ├── <span style="color:#f0f6fc;">README.md</span>
│       └── <span style="color:#f0f6fc;">vehicle_simulator.py</span>
└── <span style="color:#58a6ff;">k8s/</span>
    ├── <span style="color:#58a6ff;">backend-login/</span>
    │   ├── <span style="color:#f0f6fc;">deployment.yaml</span>
    │   ├── <span style="color:#f0f6fc;">hpa.yaml</span>
    │   ├── <span style="color:#f0f6fc;">rds-env.example.yaml</span>
    │   └── <span style="color:#f0f6fc;">service.yaml</span>
    ├── <span style="color:#58a6ff;">backend-operator/</span>
    │   ├── <span style="color:#f0f6fc;">deployment.yaml</span>
    │   ├── <span style="color:#f0f6fc;">rds-env.example.yaml</span>
    │   └── <span style="color:#f0f6fc;">service.yaml</span>
    ├── <span style="color:#58a6ff;">backend-user/</span>
    │   ├── <span style="color:#f0f6fc;">deployment.yaml</span>
    │   ├── <span style="color:#f0f6fc;">hpa.yaml</span>
    │   ├── <span style="color:#f0f6fc;">rds-env.example.yaml</span>
    │   └── <span style="color:#f0f6fc;">service.yaml</span>
    ├── <span style="color:#58a6ff;">frontend-operator-app/</span>
    │   ├── <span style="color:#f0f6fc;">coraza-middleware.yml</span>
    │   ├── <span style="color:#f0f6fc;">deployment.yaml</span>
    │   ├── <span style="color:#f0f6fc;">grafana-ingress.yml</span>
    │   ├── <span style="color:#f0f6fc;">linkerd-viz-ingress.yml</span>
    │   ├── <span style="color:#f0f6fc;">operator-ingress.yml</span>
    │   └── <span style="color:#f0f6fc;">service.yaml</span>
    └── <span style="color:#58a6ff;">frontend-user-app/</span>
        ├── <span style="color:#f0f6fc;">coraza-middleware.yml</span>
        ├── <span style="color:#f0f6fc;">deployment.yaml</span>
        ├── <span style="color:#f0f6fc;">hpa.yaml</span>
        ├── <span style="color:#f0f6fc;">service.yaml</span>
        └── <span style="color:#f0f6fc;">user-ingress.yml</span>
</pre>

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

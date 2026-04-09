# AWS Ansible 운영 가이드

`infra/aws/ansible`은 AWS에 생성된 K3s 마스터 노드에 접속해 클러스터 초기화와 운영 구성 요소 설치를 수행합니다.
워커 노드는 Terraform의 EC2 Auto Scaling Group과 user data로 조인되므로, Ansible은 마스터 노드와 클러스터 설정 중심으로 사용됩니다.

## 현재 구조

```text
ansible/
├── ansible.cfg
├── playbooks/
│   └── setup_k3s_cluster.yml
├── roles/
│   ├── argocd/
│   ├── aws-ccm/
│   ├── cluster-autoscaler/
│   ├── db_setup/
│   ├── k3s_master/
│   ├── linkerd/
│   ├── prometheus/
│   └── web_platform_env/
└── vault/
    └── vault.yml
```

## 사전 조건

### 로컬 도구

- AWS CLI가 설치되어 있어야 합니다.
- Ansible이 설치되어 있어야 합니다.
- `community.postgresql`, `amazon.aws` 컬렉션을 사용할 수 있어야 합니다.
- `~/.ssh/infra.pem` 키 파일이 있어야 합니다.
- `infra/aws/ansible/vault/vault_pass` 파일이 로컬에 있어야 합니다.

### 선행 인프라

- `infra/aws/terraform/network`가 먼저 적용되어 있어야 합니다.
- `infra/aws/terraform/data`가 먼저 적용되어 있어야 합니다.
- `infra/aws/terraform/compute`가 적용되어 `infra/aws/ansible/inventory/hosts.ini`가 생성되어 있어야 합니다.
- AWS SSM Parameter Store에 `/config/vehicle/db_password` 값이 있어야 합니다.

## 실행 방법

```bash
cd infra/aws/ansible
ansible-playbook playbooks/setup_k3s_cluster.yml
```

기본 인벤토리는 `ansible.cfg`에서 `./inventory/hosts.ini`로 지정되어 있습니다.

## 플레이북이 하는 일

`playbooks/setup_k3s_cluster.yml`은 아래 순서로 작업합니다.

1. `masters` 그룹에 순차적으로 K3s server를 설치합니다.
2. 첫 번째 마스터에서 PostgreSQL 스키마를 적용합니다.
3. Linkerd를 설치합니다.
4. Cluster Autoscaler를 설치합니다.
5. AWS Cloud Controller Manager를 설치합니다.
6. Prometheus와 Grafana를 설치합니다.
7. 웹 플랫폼용 namespace, ConfigMap, Secret, Ingress를 준비합니다.
8. Argo CD 애플리케이션을 설치합니다.

## 접속 방법

Terraform이 생성한 인벤토리의 `ansible_host` 값은 EC2 인스턴스 ID이며, 운영 접속은 AWS SSM Session Manager를 사용합니다.

```bash
aws ssm start-session --target <instance-id> --region ap-northeast-2
```

세션에 접속한 뒤 확인할 기본 명령은 아래와 같습니다.

```bash
sudo kubectl get nodes
sudo kubectl get pods -A
sudo kubectl get ingress -A
```

## 자주 확인할 파일

- `playbooks/setup_k3s_cluster.yml`: 전체 설치 순서
- `roles/k3s_master/tasks/main.yml`: K3s 및 Traefik 기본 설정
- `roles/db_setup/files/schema.sql`: PostgreSQL 스키마
- `roles/web_platform_env/tasks/main.yml`: 앱 namespace, ConfigMap, Secret, Ingress 설정
- `roles/prometheus/tasks/main.yml`: Prometheus/Grafana 설치

## 운영 메모

- 워커 노드는 Ansible이 아니라 Terraform user data로 자동 조인됩니다.
- DB 비밀번호는 Vault가 아니라 AWS SSM Parameter Store에서 조회합니다.
- Vault 파일은 K3s 공유 토큰과 Ansible 실행 시 필요한 시크릿 값을 보관하는 용도로만 사용합니다.

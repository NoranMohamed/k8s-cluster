# Kubernetes Cluster on AWS using Terraform & Ansible

This project automates the deployment of a production‑ready Kubernetes cluster (1 master + 1 worker) on AWS EC2 using Infrastructure as Code (IaC) and Configuration Management.

## 🧱 Architecture Overview

- **Terraform**:
  - VPC with CIDR `10.0.0.0/16`
  - Public subnet `10.0.1.0/24`
  - Internet Gateway + Route Table
  - Security Groups (SSH, Kubernetes API, NodePorts, internal traffic)
  - EC2 instances:
    - Master: `t2.medium` (2 vCPU, 4 GB RAM)
    - Worker: `t2.small` (1 vCPU, 2 GB RAM)
  - AMI: Amazon Linux 2 (customizable)

- **Ansible**:
  - Common role (all nodes):
    - Disable swap, load kernel modules, set sysctl
    - Install containerd (with SystemdCgroup enabled)
    - Install kubeadm, kubelet, kubectl v1.29
    - Add Kubernetes yum repository
  - Master role:
    - Initialize cluster with `kubeadm init` (Pod CIDR `192.168.0.0/16`)
    - Configure kubectl for `ec2-user`
    - Install Calico CNI
    - Generate and save join command
  - Worker role:
    - Copy join command from control node
    - Join the cluster

## 📋 Prerequisites

- **AWS account** with permissions to create EC2, VPC, IGW, Subnets, Security Groups.
- **AWS CLI** installed and configured (`aws configure`).
- **Terraform** >= 1.0 (https://terraform.io)
- **Ansible** >= 2.14 (https://ansible.com)
- **SSH key pair**:
  ```bash
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
Git (to clone this repo).

🚀 Step‑by‑Step Deployment
1. Clone the repository
bash
git clone https://github.com/NoranMohamed/k8s-cluster.git
cd k8s-cluster
2. Deploy infrastructure with Terraform
bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
After completion, note the public IPs of master and worker (displayed as outputs).

3. Prepare Ansible inventory
bash
cd ../ansible
cp inventory.ini.example inventory.ini
Edit inventory.ini and replace:

<MASTER_PUBLIC_IP> with the actual master public IP

<WORKER_PUBLIC_IP> with the actual worker public IP

4. Run Ansible playbook
bash
ansible-playbook playbook.yml
This will take 5‑10 minutes (pulling container images, initializing cluster, etc.).

5. Verify the cluster
SSH into the master node:

bash
ssh -i ~/.ssh/id_rsa ec2-user@<MASTER_PUBLIC_IP>
kubectl get nodes
You should see both master and worker in Ready state.

6. (Optional) Deploy a test nginx pod
bash
kubectl run nginx --image=nginx --port=80
kubectl expose pod nginx --type=NodePort --port=80
kubectl get svc
Access it via http://<WORKER_PUBLIC_IP>:<NODEPORT>.

🧹 Cleanup (avoid AWS charges)
bash
cd terraform
terraform destroy -auto-approve
🔧 Troubleshooting
Issue	Likely cause	Solution
InvalidAMIID.NotFound	Wrong AMI for your region	Change manual_ami_id in terraform/variables.tf
SSH permission denied	Wrong username or key	Use ec2-user and verify key path
Worker fails to join	Master not ready or token expired	Run kubeadm token create --print-join-command on master and join manually on worker

📬 ContactEOF
Created by Noran Mohamed – feel free to reach out via GitHub.


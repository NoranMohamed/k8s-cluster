# Kubernetes Cluster on AWS using Terraform & Ansible

This project provisions a Kubernetes cluster (1 master + 1 worker) on AWS EC2 using:
- Terraform for infrastructure (VPC, subnet, security groups, EC2 instances).
- Ansible for configuration (containerd, kubeadm, Calico CNI).

## Usage
See `terraform/` and `ansible/` directories.

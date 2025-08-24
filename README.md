<img width="1097" height="318" alt="image" src="https://github.com/user-attachments/assets/666537c4-4f30-4c0f-8f52-b39b0cec2987" /># Jenkins Deployment on Kubernetes

This repository contains all the steps, YAML manifests, and troubleshooting steps for deploying Jenkins on a Kubernetes cluster.

---

## Table of Contents
- [Prerequisites](#prerequisites)
- [Setup Steps](#setup-steps)
  - [1. Namespace Creation](#1-namespace-creation)
  - [2. Service Account and RBAC](#2-service-account-and-rbac)
  - [3. Persistent Volume & Claim](#3-persistent-volume--claim)
  - [4. Jenkins Deployment](#4-jenkins-deployment)
  - [5. Exposing Jenkins Service](#5-exposing-jenkins-service)
  - [6. Access Jenkins](#6-access-jenkins)
- [Troubleshooting](#troubleshooting)
Issue	Steps Taken / Commands
apt-get install vim fails inside pod	Used apt-get update && apt-get install -y vim in container shell. Built custom Jenkins image with tools.
Pod stuck in ContainerCreating	Checked PVC and PV status: kubectl get pvc -n jenkins. Verified pod events: kubectl describe pod <pod> -n jenkins
NodePort not accessible	Verified Node IP and firewall rules. Confirmed service selector matches deployment labels: kubectl get svc -n jenkins
Plugins not installing	Built custom Jenkins image with pre-installed plugins using Dockerfile.
Permission denied on volume	Added securityContext in deployment: fsGroup: 0, runAsUser: 0.
Cannot access Jenkins externally	Checked cluster networking and firewall. NodePort 30000 allowed, browser using correct Node IP.
Jenkins initialization stuck	Checked pod logs: kubectl logs <jenkins-pod> -n jenkins. Verified all plugins installed and container has enough resources.
<img width="1097" height="318" alt="image" src="https://github.com/user-attachments/assets/b5a174eb-06e6-430a-950e-c079974e6d25" />


---

## Prerequisites
- Kubernetes cluster up and running (single/multi-node).
- `kubectl` configured to access your cluster.
- Docker images for Jenkins (`rakesh6nm/jenkins:lts-tools`).

##

# Installed vim inside pod
kubectl exec -it <jenkins-pod-name> -n jenkins -- bash
apt-get update
apt-get install -y vim

# Pod stuck in ContainerCreating
kubectl describe pod <jenkins-pod-name> -n jenkins
kubectl get pvc -n jenkins
kubectl get pv

# NodePort not accessible
kubectl get svc -n jenkins
curl http://<Node-IP>:30081

# Pod permission denied on volume
# Fixed via securityContext:
# fsGroup: 0, runAsUser: 0

# Jenkins initialization or plugin issues
kubectl logs <jenkins-pod-name> -n jenkins



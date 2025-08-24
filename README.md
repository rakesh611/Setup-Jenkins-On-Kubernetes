# Jenkins Deployment on Kubernetes

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
- | Issue                                          | Solution / Steps                                                                                                 |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `apt-get install vim` fails inside Jenkins pod | Install packages in Dockerfile before building custom image, or use container shell with `apt-get update` first. |
| Jenkins pod stuck in `ContainerCreating`       | Check PV/PVC binding status, storage permissions, and pod events: `kubectl describe pod <pod>`                   |
| NodePort not accessible                        | Ensure firewall allows port 30000, check node IP, verify service selector matches deployment labels.             |
| Plugins not installing automatically           | Use Jenkins custom image with pre-installed plugins, or mount Jenkins home from PVC.                             |
| Pod fails with `Permission denied` on volume   | Use `securityContext` in deployment: `fsGroup: 0, runAsUser: 0` for Jenkins container.                           |
| Unable to access Jenkins externally            | Check Kubernetes networking, Node IP, service type, and cluster firewall rules.                                  |
| Jenkins initialization stuck                   | Check pod logs for errors: `kubectl logs <jenkins-pod> -n jenkins` and ensure required plugins are installed.    |

- [References](#references)

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



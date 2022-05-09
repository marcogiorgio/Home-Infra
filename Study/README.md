# Kubernetes-Helm-Terraform

The aim of this folder is to collect some basic applications/infra developed during the self-study of Kubernetes/Helm/Terraform:
To deploy a Kubernetes cluster I followed the guide provided here: https://www.cloudsigma.com/how-to-install-and-use-kubernetes-on-ubuntu-20-04/, using two Ubuntu VMs deployed on the ESXi host deployed on my home infrastructure.


## Kubernetes/Helm

This exercise is contained in 2 subfolders:
- **Kubernetes-Exercise**: Contains a simple web app that prints the name of the pod. The app is exposed internally using ClusterIP and externally using a Nginx ingress controller. HTTPS is handled externally by a HAProxy instance deployed on my home infrastructure. To collect the logs of the application, I used a fluentD Daemon Set in conjunction with an Elasticsearch instance. Like the web app, Elasticsearch is exposed internally using a clusterIP and externally by using another ingress route (another subdomain).

- **Kubernetes-Exercise-Helm**: Contains the same web app ready to be deployed with Helm. Since the purpose of this exercise was to study the basics of Helm, I didn't focus on what was right to be written as a template and what not. Probably in a real world scenario, the whole fluentD part would be static, as it collects the logs of all Kubernetes cluster and it's not bound to a particular namespace/environment

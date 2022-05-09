# ESXi

All my main servers are virtual and deployed on a VMWare ESXi host. They rall run Ubuntu 22.04 except for SRVBACKUP and SRVSURVEILLANCE, which run Windows Server 2022 Standard. There is a virtual switch configured on the node which trunks the VLANs needed by the servers:
- **SRVUPS:** Contains the software which monitors my UPS and send the shutdown signal to ESXi in case of power outage
- **SRVMMONITOR:** Contains my two monitoring software, LibreNMS and Uptime Kuma. LibreNMS monitors all the devices via SNMP and sends an email if one device is down or in case of other issues. Uptime Kuma monitors the state of the services via HTTP requests.
- **SRVBACKUP:** Contains Veeam Backup and replication, the software used to backup all my virtual servers on my NAS.
- **SRVDOCKER:** Contains my services deployed via Docker/Docker compose
- **SRVDEVELOPMENT:** This is a server used as a playground to test things
- **SRVADGUARD:** Contains AdGuard Home, a DNS server also used to block ads during internet browsing
- **SRVGUACAMOLE:** Contains Apache Guacamole, a gateway used to initiate RDP, SSH connections via HTTPS
- **SRVSURVEILLANCE:** Contains BlueIris, a software used to control all the security cameras
- **KUBERNEETES-MASTER:** Kubernetes Master node
- **KUBERNEETES-WORKER-01:** Kubernetes Worker node

![Alt text](vswitch.png?raw=true "vSwitch topology")

# NAS01

Besides my ESXi host, I own a NAS which also acts as a Docker server, here I installed all the services which needs disk space.
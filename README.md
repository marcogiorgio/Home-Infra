# Home-Infrastructure

This repo contains all the information about the infrastructure I deployed at my home. I built all this for fun, for personal edification and in order to deploy some useful self hosted apps.
I will describe the high level architecture here and I'll use different subfolders for network, server, storage details etc.

All the apps I run were deployed using Docker and Docker Compose. I chose to do this mainly for three reasons:
- It provided a good opportunity to learn Docker
- It allowed me to install many apps, all using different technologies, on the same server without polluting the server itself with libraries and dependencies.
- It simplified the maintenance of the apps (upgrades etc.)

All the containers are distributed between a Synology NAS (mainly the ones that need storage) and an Ubuntu Server 22.04 running on an ESXi host. The apps are served by an HAProxy instance which runs on my OPNSense firewall. HAProxy also handles HTTPS with a valid certificate issued for my domain by Let's Encrypt, which is validated using a DNS-01 challenge thanks to Cloudflare APIs (my DNS provider). This kind of challenge is the best choice because it allows you to receive a wildcard certificate valid for all subdomains and because it doesn't use port 80, which is essential for HTTP.

OPNSense acts as a DHCP/DNS server as well, for this reason I can internally reach all my web apps by using dns names with no issues caused by self signed HTTPS certificates on browsers.

If I want to externally access my services I can use two methods:
- A Wireguard VPN configured on the firewall
- "Directly" connect using the DNS name: for these kind of services I rely on Cloudflare DNS reverse proxy functionality, in order to hide my real IP address/configure firewall rules.

In order to segregate the networks used by servers, client devices, security devices like surveillance cameras etc. I used different subnets/VLANs with different firewall rules.

I refer you to the specific folders for the details of the infrastructure.

Last but not least, in the folder "Study" there are some examples of an app deployed via Kubernetes/Helm and a virtual AWS infrastructure deployed via Terraform. These are not to be intended as "production ready", but served the purpose of becoming familiar with the tools. 


![Alt text](infra.jpg?raw=true "Home infrastructure")
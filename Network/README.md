# Network Infrastructure overview

The network infrastructure is composed by an OPNSense firewall/router, two managed core switches and two peripheral ones.
In order to segregate the devices based on their role, I defined these VLANs:

- **MANAGEMENT:** This is where all the management IP interfaces of the devices are placed, as well as all my trusted devices
- **CLIENT:** This is where normal clients like laptops, Chromecast, mobile phones are placed.
- **SERVER:** This is where all servers running Docker are placed
- **DMZ:** This is where HAProxy instance is placed, as well as my first DNS server AdGuard Home and Apache Guacamole
- **IOT:** This is where all my IoT devices )Philips Hue, Dishwasher, Roomba etc.. are placed
- **GUEST:** This is where guest devices are placed (friends' phone, PC) when they need internet access
- **SECURITY:** This is where security cameras and the alarm system (based on Home Assistant) are placed, this network has no "internet" access

![Alt text](vlans.png?raw=true "VLANs")


# Access to services

Whenever I try to reach my services from Internet, the request follows this flow:
- All the requests to my domain are handled by Cloudflare, which is my DNS server. Cloudflare acts also as a reverse proxy/firewall/perimetral HTTPS provider: it hides my public IP, checks if the source IP can access the specific resource and forwards the request to my public IP.
- When the requests arrives on my firewall, a specific NAT rule redirects the traffic from all Cloudflare's IP ranges to my HAproxy instance listening on the DMZ interface
- HAProxy analyzes the request and forwards the traffic to the correct socket of the backend server based on subdomains. Before doing this, it removes HTTPS in order to let the IPS (Suricata) analyze the traffic and blocks threats

HTTPS is enforced along all the communication flow from Cloudflare to my HAProxy instance.

![Alt text](servicelogic.png?raw=true "Service access flow")
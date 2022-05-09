# LibreNMS

The first tool I use to monitor my infrastructure is LibreNMS. This software uses SNMP to query many probes either virtual (OS monitoring), or physical (hardware monitoring). For my use case, the main things I need to monitor are:
- Device is down
- Root disk space exceeds 80% of free space

This tool is deployed via Docker on the server SRVMONITOR. When an alarm is triggered a mail is sent with its details.

![Alt text](librenms-main-page.png?raw=true "LibreNMS main page")

![Alt text](librenms-device-page.png?raw=true "LibreNMS device page")

# Uptime Kuma

The second tool I use to monitor my infrastructure is Uptime Kuma. This software uses HTTP GET requests and it monitors if the response is 200.. For this reason I mainly use it to monitor my web app status.
Besides, I configured a probe that pings 8.8.8.8 in order to check if Internet is down. In this case I receive an alarm in my LAN via Gotify (https://gotify.net/).

![Alt text](uptimekuma-main-page.png?raw=true "Uptime Kuma main page")

![Alt text](uptimekuma-dashboard-page.png?raw=true "Uptime Kuma status page")
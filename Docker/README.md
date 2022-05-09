This subfolder contains all the docker compose files used to deploy my services. Here's a brief description of each of them, grouped by their deployment server:

## SRVDOCKER

- **Portainer:** Container management system, useful to monitor the stack using a web browser
- **2FAuth:** A service used to store TOTP codes
- **Bookstack:** A personal wiki
- **Collaboraonline:** A container used by Seafile to edit Office documents via browser
- **Etesync-DAV:** CalDAV and CardDAV adapter for Etesync server
- **Etebase:** CardDAV and CalDAV server
- **Etesync app:**: Web app frontend for Etebase server
- **FireflyIII:** Financial manager, uso to track all the expenses
- **Gitea:** Git Server
- **Gotify:** Server to send and receive messages using REST API. Useful to send notifications in LAN whene internet is not available
- **Hedgedoc:** Collaborative markdown editor
- **IHatemoney:** App used to manage shared expenses
- **Joplin:** Note editor with markdown support
- **Homer:** Personal dashboard, useful to have a single starting point for all services
- **Miniflux:** RSS feed reader
- **Piped:** A privacy oriented frontend for YouTube
- **Snaprop:** A webapp used to send/receive files via browser between devices in the same LAN
- **Libreddit:** A privacy oriented frontend for Reddit
- **Whoogle:** A privacy oriented frontend for Google
- **Lingva:** A privacy oriented frontend for Google Translate
- **Wireguard VPN client:** A VPN client used with Mullvad VPN, used to route traffic for other containers that needs privacy
- **Watchtower:** Container that sends an email when a docker container image is updated

## NAS01

- **Calibre Web:** eBook reader
- **qBittorrent:** Torrent client
- **Prowlarr:** Indexer manager/proxy
- **Bazarr:** Service to automatically download subtitles for Movies/TV Series
- **Lidarr:** Music collection manager
- **Sonarr:** TV Series collection manager
- **aMule:** eDonkey client
- **Readarr:** eBook collection manager
- **Flaresolverr:** Proxy server to bypass Cloudflare protection
- **Radarr:** Movies collection manager
- **OpenVPN Client:** A VPN client used with Mullvad VPN, used to route traffic for other containers that needs privacy
- **Ombi:** Webapp to request content in Emby/Plex media centers
- **Paperless-ngx:** Documental server
- **Seafile:** File host service
- **Watchtower:** Container that sends an email when a docker container image is updated

## SRVADGUARD

- **AdGuard:**  Network-wide software for blocking ads & tracking. Acts as a DNS server

## SRVGUACAMOLE

- **Guacamole:**  Contains Apache Guacamole, a gateway used to initiate RDP, SSH connections via HTTPS


## SRVMONITOR

- **Uptime Kuma:** Software used to monitor my services using HTTP GET
- **LibreNMS:** Software used to monitor all my devices using SNMP

Whenever possible, all credentials were stored used Secrets, there were many containers that didn't support them though. In this case I had to configure the approriate env variables.
# Backup strategy

## Virtual machines

In order to backup all the VMs deployed on the ESXi host I installed Veeam Backup and Replication on SRVBACKUP. I configured a forever incremental backup job with a 7 days retention which runs every day at 01.00 am. The backup repository is a folder on my backup NAS, NAS02.
In order to backup the database and maintain their consistency, I wrote a pre freeze script which backups all of them with a retention policy of 7 days.

## NAS01

All the shared folders on the NAS are backed up every Saturday at 02.00 am by Snapshot replication, a software owned by Synology, the NAS vendor. Since all the docker volumes on the NAS were configured as bind mounts, this method permits to backup even all the docker containers' data.
Similar to what I did with the other docker databases, I wrote a backup script which runs every day at 02:00.

## Cloud replica

Every Saturday at 04:00 am, the software Hyper Backup on NAS01 copies the folders which contain Virtual machine backup/NAS 01 backup on a folder which is constantly synced with OneDrive.
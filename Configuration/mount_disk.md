Unit Location:
```
/lib/systemd/system/home-ubuntu-Share.mount
```
Unit:
```ini
[Install]
WantedBy=multi-user.target

[Unit]
Description=Share

[Mount]
What=/dev/sda1
Where=/home/ubuntu/Share
Options=rw
DirectoryMode=0744
```
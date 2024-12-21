Unit Location:
```
/lib/systemd/system/yuko-bot.service
```
Unit:
```ini                                                                                                                          
[Unit]
Description=Downloading attachments from Discord channels
After=network.target mariadb.service
Requires=network.target mariadb.service

[Service]
ExecStart=/opt/dotnet-runtime-3-1/dotnet /opt/yuko-bot/YukoBot.dll
Type=idle
Restart=on-failure
KillMode=process
SyslogIdentifier=yuko-bot
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
```
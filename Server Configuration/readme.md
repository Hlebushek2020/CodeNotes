## Yuko Bot
Unit Location:
```
/lib/systemd/system/yuko-bot.service
```
Unit:
```bash                                                                                                                          
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
## Volt Bot
Unit Location:
```
/lib/systemd/system/volt-bot.service
```
Unit:
```bash
[Unit]
Description=Bot for Misty Owl & Dr.Sly discord server
#After=network.target mariadb.service
#Requires=network.target mariadb.service

[Service]
ExecStart=/opt/dotnet-runtime-7/dotnet /opt/volt-bot/Volt_Bot.dll
Type=idle
Restart=on-failure
KillMode=process
SyslogIdentifier=volt-bot
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
```
## Примонтированный диск (Share)
Unit Location:
```
/lib/systemd/system/home-ubuntu-Share.mount
```
Unit:
```bash
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

## My Website
Unit Location:
```
/lib/systemd/system/my-website.service
```
Unit:
```bash
[Unit]
Description=My Website (Apache Tomcat Web Application Container)
After=network.target postgresql.service

[Service]
Type=forking

Environment=JAVA_HOME=/opt/semeru-open-jdk-17
Environment=CATALINA_PID=/opt/my-website/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/my-website
Environment=CATALINE_BASE=/opt/my-website
Environment='CATALINE_OPTS=-Xms128M -Xmx765M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.haedless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/my-website/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

[Install]
WantedBy=multi-user.target
```
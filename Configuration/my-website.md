Unit Location:
```
/lib/systemd/system/my-website.service
```
Unit:
```ini
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
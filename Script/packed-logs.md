```bash
#!/bin/bash
cd /opt/volt-bot
mkdir packed-logs
tar -zcvf ./packed-logs/$(date +%d-%m-%Y).tar.gz logs
rm -R logs
```
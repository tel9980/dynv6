# Dynv6 updater script for linux

1. Download script: wget https://raw.githubusercontent.com/dantavares/dynv6/main/dynv6.sh
2. Set script as executable: sudo chmod +x dynv6.sh
3. Edit the script, give a hostname and token
4. Execute script, test and check
5. Create a cron job. Example script on /opt and check every hour:
   sudo crontab -e
   0 * * * * /opt/dynv6.sh &>/dev/null 2>&1

Done!

# dynv6 updater script for linux

1. Edit lines behind, give a hostname and token
2. Set this script as executable: sudo chmod +x dynv6.sh
3. Execute script, test and check.
4. Create a cron job. Example script on /opt and check every hour:
   sudo crontab -e
   0 * * * * /opt/dynv6.sh &>/dev/null 2>&1

Done!

#!/bin/bash

# Reusable for more jobs
function addCron()
{
    USER=$(logname)

    CRONJOB="$PWD/cronjobs/check-battery"

    echo "adding cron job"
    cp $CRONJOB /etc/cron.d/
    sudo crontab -u $USER /etc/cron.d/check-battery

    systemctl is-active --quiet cron

    if [ $? != 0 ]; then
        echo "cron is not running, starting..."
        sudo service cron start
    else
        echo "cron is running"
    fi
}

addCron;

#!/bin/bash
/bin/systemctl status --full "$1" >> /home/bruno/.log_error
sleep 20
/bin/systemctl stop "$1"
sleep 3
/bin/systemctl start "$1"

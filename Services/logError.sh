#!/bin/bash
sudo /bin/systemctl status --full "$1" >> /home/bruno/.log_error

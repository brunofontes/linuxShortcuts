#!/bin/bash
# Add a SSH identity if nothing were found
ssh-add -l > /dev/null || ssh-add

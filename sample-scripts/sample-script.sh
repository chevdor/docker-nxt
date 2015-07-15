#!/bin/bash

# This is a stupid sample script.
# You could do anything you want here.
# This script runs before anything else
# just after the container started.
target=/sample-script.log
echo "New start" `date` >> "$target" 
ls -al /nxt >> "$target"

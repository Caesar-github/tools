#!/usr/bin/expect -f
set timeout 30
spawn ssh wxt@172.16.22.104
expect "*password:"
send "caesar\r"

interact

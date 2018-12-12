#!/usr/bin/expect -f

set timeout -1
#spawn git push rk-pull atf-github/master:master -f
#spawn git push rk-pull atf-github/integration:integration -f
#expect "Username*"
#send "rkchrome\r"
#expect "Password*"
#send "rk83991906\r"

spawn git push origin test:master -f
expect "Username*"
send "caesar-github\r"
expect "Password*"
send "wxt040501\r"

expect eof

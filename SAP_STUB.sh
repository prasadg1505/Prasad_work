#!/usr/local/bin/expect -f

set timeout -1

set choice1 1
set choice2 4

spawn ./tib_switcher.sh

expect "Select option ([A] to abort):" { send "$choice1\r" }
expect "Select option ([A] to abort):" { send "$choice2\r" }
expect "Starting esb2sap in STUB mode.....Switch successfully completed."

expect eof 
 

#!/bin/bash
# fuzzel-askpass.sh – запрос пароля через fuzzel
password=$(fuzzel --dmenu --cache=/dev/null --prompt-only="   " --mesg="🔑 Enter password:" --password)
echo "$password"

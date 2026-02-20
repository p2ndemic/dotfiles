#!/bin/bash
# fuzzel-askpass.sh – запрос пароля через fuzzel
password=$(fuzzel --dmenu --prompt-only="" --mesg="🔑 Enter password" --password --cache=/dev/null)
echo "$password"

#!/bin/bash
# fuzzel-askpass.sh – запрос пароля через fuzzel
password=$(fuzzel --dmenu --prompt-only="🔑 Password: " --password --cache=/dev/null)
echo "$password"

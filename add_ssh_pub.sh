#!/bin/sh

# Script der einen unter der Variable public_key definierten ssh public-key zum Einloggen
# ohne Passwort im authorized_keys File vom user Vagrant und dem root Account speichert

# hier den eigenen public-key eintragen
public_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUWjC+CuhrJW4eH50K68jVu8Y3FmBibEg6fNaW82OB8yo7tITrNfw4V44GWvSRC3aCnA6GOLWcw1NDb85gfY2jKG1IGZuVc3VvpFC+v9O0sYVlT+f8JvNWQKAEy+0dneKwhCYir6pdOrKPch6ViLAEHMlvDmANwheVGCvwDt5CK9l7lGDJJyEjxMpuEW1f6FjST5nsVFxFU3fbUi9IpV4Nr4DzRbmLDmpoTk3Bei6oUVEZVNC57sBft8PDvN8XHUsluD/PAkuRcfLnFwDph86y1HP4syw/lET628nCCjv7v1qQ3AYznaUDlQnq4SIVw6pGKatT2VMGGT+eOzLjCEieEGyrrONzf12+Vb+ivYrWIvxCB9IIV07i4x7vU4AgkOtZCWMpdYdOxYnFmWArngy3uDZ47TRYQN56jBYDBlLurvkn6s6SrYaYgK64P6PNH5iWfqHsmI3XuJEHKSBllEWOYsDZuzbA8zkAjzTKWCL4umzskZJ60cslptSyhmm2cpylu3YKB4R6u73A9qEwzuyC/MoZA080D93HCvTiyeMcDYOgUsADUjp1dtf73/unXBXNAVVg+umTWPrXQJYNlPGhhDZRwkUKloxn5VyZysspCsKBl1wkPbnedSLQWVroGFKA2rqzKYizjdPp4zcFJxAgXZCB4hCCjzIGj2/JQJnFfw== mbe@nportege'

# add public key for usr vagrant
echo $public_key >> /home/vagrant/.ssh/authorized_keys

# add public key for root
chmod 700 /root/.ssh
echo $public_key >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

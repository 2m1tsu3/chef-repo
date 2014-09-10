#!/bin/bash
ADMIN_USER=chefclient
groupadd wheel
useradd $ADMIN_USER -G wheel -m
sudo -u $ADMIN_USER sh -c "cd /home/$ADMIN_USER && mkdir .ssh && chmod 700 .ssh && echo \"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxQErtEMjveagihSWlB0rcOUzjTlq0cH75fujykCPpktjsUlS/NxIJZNVOzBZ7Rm2O+OCeO9cfKfzIVmMrIYZ6Tk0gmBeJ8TbXtcFHc1fsXgyphhfxvm3QiuJ0HYs60fDB5s2/P7AKwFjjsIzTzwZJ1F2h/P6RsnKPvuqpcLwKpZ3zK7sL6SK3i1GEdQWaOZf6g1kOMf1K57Zt8f6c9SBaqeP5K+L83C4xAo7kJkSC6W7LtokUj4ZCd9Lnb3DKS4zg9ChcVzQC2VqHUYUuDOptthaleC2WKYVBElOwXVG7aWoCgMkyRkwzCosR/6Q9kIdOKfxiwIt7/KkV5VeYhjPHw== root@cloudbox\" > .ssh/authorized_keys && chmod 600 .ssh/authorized_keys"

echo '%wheel  ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

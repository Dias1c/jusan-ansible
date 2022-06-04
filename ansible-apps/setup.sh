sudo docker compose down
sudo docker compose up -d
# ssh-copy-id not work, why? "sh: 1: cannot create .ssh/authorized_keys: Is a directory"
ssh-copy-id -f -p 2222 root@127.0.0.1 
ssh-copy-id -f -p 2223 root@127.0.0.1
ssh-copy-id -f -p 2224 root@127.0.0.1
ansible -i hosts.ini all -m ping -u root
ansible-playbook -i hosts.ini playbook.yml
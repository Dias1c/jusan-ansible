sudo docker compose down
sudo docker compose up -d
ssh-copy-id -f -i ~/.ssh/id_rsa.pub -p 2222 root@127.0.0.1
ansible -i hosts.ini all -m ping -u root
ansible-playbook -i hosts.ini playbook.yml
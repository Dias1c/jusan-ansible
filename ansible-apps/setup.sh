docker compose down
docker compose up -d
ansible -i hosts.ini all -m ping -u root
ansible-playbook -i hosts.ini playbook.yaml

bash checker-apps.sh
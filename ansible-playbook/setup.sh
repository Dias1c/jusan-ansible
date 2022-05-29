#!/bin/bash
echo "Clearing files and containers"
sudo docker container rm $(sudo docker container ps -a | grep -o local-vps-....) -f

# 

ports="
2421_2221
2422_2222
"

# запускает образ atlekbai/local-vps с именем контейнера local-vps-22 и перенаправялет порты 22 и 80 внутрь контейнера; <- Это не будет работать
for line in $ports
do
	port_nginx="$(echo $line | cut -d '_' -f 1)"
	port_ssh="$(echo $line | cut -d '_' -f 2)"
	sudo docker run -d --rm --name "local-vps-$port_nginx" -p $port_nginx:80 -p $port_ssh:$port_ssh atlekbai/local-vps $port_ssh
done

sudo docker ps -a

sleep 1
SSH_PASSWORD="password"
# 
for line in $ports
do
	port_ssh="$(echo $line | cut -d '_' -f 2)"
	echo "PORT_SSH: $port_ssh"
	ssh-copy-id -f -p $port_ssh -i ~/.ssh/id_rsa.pub root@127.0.0.1;
done


# 
sleep 1;

# Creating hosts.ini file
FILE_HOSTS="hosts.ini"

echo "[lb]" > $FILE_HOSTS
for line in $ports
do
	port_ssh="$(echo $line | cut -d '_' -f 2)"
	echo "PORT_SSH: $port_ssh"
	echo "127.0.0.1 ansible_user=root ansible_port=$port_ssh" >> $FILE_HOSTS
done


# Creating playbook.yml file
FILE_PLAYBOOK="playbook.yml"

cat << EOF > $FILE_PLAYBOOK
---
- hosts: "lb"
  become: yes

  tasks:
    - name: "Установка nginx"
      apt:
        name: nginx
        state: latest

    - name: "Включение сервиса"
      ansible.builtin.service:
        name: nginx
        state: started
EOF

# Run playbook
ansible-playbook -i $FILE_HOSTS $FILE_PLAYBOOK
bash rm-files.sh

# Recomendation
for line in $ports
do
        port_nginx="$(echo $line | cut -d '_' -f 1)"
	echo "try: curl localhost:$port_nginx"
done

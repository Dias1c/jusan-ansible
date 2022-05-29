#!/bin/bash
echo "Clearing files and containers"
sudo docker container rm $(sudo docker container ps -a | grep -o local-vps-....) -f

# 
ports=$(echo {2221..2222})

# запускает образ atlekbai/local-vps с именем контейнера local-vps-22 и перенаправялет порты 22 и 80 внутрь контейнера; <- Это не будет работать
for port in $ports
do
	sudo docker run -d --rm --name "local-vps-$port" -p $port:$port atlekbai/local-vps $port
done

sudo docker ps -a
sleep 1
SSH_PASSWORD="password"
# 
for port in $ports
do
	echo $port
	ssh-copy-id -f -p $port -i /home/dias/.ssh/id_rsa.pub root@127.0.0.1;
done


# 
sleep 1;

# Creating hosts.ini file
FILE_HOSTS="hosts.ini"
rm $FILE_HOSTS

echo "[lb]" > $FILE_HOSTS
for port in $ports
do
	echo "127.0.0.1 ansible_user=root ansible_port=$port" >> $FILE_HOSTS
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

echo "$(whoami)"

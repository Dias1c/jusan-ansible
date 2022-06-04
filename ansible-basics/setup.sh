bash rm-files.sh

V_PORT_NGINX=8030
V_PORT_SSH=2230

# Creating Jinja2 template file for ansible playbook file
cat << EOF > server.conf.j2
server {
    listen {{ server_port }};

    server_name {{ server_name }};

    location / {
        return 200 '{{ hello_message }}';
    }
}
EOF

cat << EOF > hello.sh
echo "Hello, where am I?"
sleep 1
echo "I hope I am in docker container. Because I must copied from local machine as hello.sh"
EOF


cat << EOF > playbook.yml
---
- hosts: all
  become: yes

  tasks:
    - apt: name=nginx state=present

    - copy:
        src: "./hello.sh"
        dest: "~/run-me.sh"

    - name: "Adding Users"
      user:
        name: "{{ item.name }}"
        state: present
        groups: "{{ item.group }}"
      loop: # about loop more here https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html
        - name: dias
          group: sudo
        - name: dias1c
          group: dias

    - template: # < using for adding files to template, with changed data. Templates in ansible writes by Jinja2: https://jinja.palletsprojects.com/en/3.1.x/templates/#synopsis
        src: "./server.conf.j2" # <-- .j2 - is extention for Jinja2
        dest: "/etc/nginx/conf.d/server.conf"
      vars:
        server_port: $V_PORT_NGINX
        server_name: jusan
        hello_message: Hello, from jusan-template example!
      notify: "reload nginx"

  handlers: # <-- new task handlers which runs after succesfull runned tasks and runs by "notify" in tasks
   - name: "reload nginx"
     service: name=nginx state=reloaded
EOF

cat << EOF > hosts.ini
[container]
127.0.0.1 ansible_user=root ansible_port=$V_PORT_SSH
EOF


# Run Containers
sudo docker container rm $(sudo docker container ps -a | grep -o local-vps-....) -f
sudo docker run -d --rm --name "local-vps-$V_PORT_NGINX" -p $V_PORT_NGINX:$V_PORT_NGINX -p $V_PORT_SSH:$V_PORT_SSH atlekbai/local-vps $V_PORT_SSH
sudo docker container ps
sleep 2

ssh-copy-id -p $V_PORT_SSH -i ~/.ssh/id_rsa.pub -f root@127.0.0.1

# Run ansible
ansible-playbook -i hosts.ini playbook.yml
bash rm-files.sh
echo "try: curl localhost:$V_PORT_NGINX"

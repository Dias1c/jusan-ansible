# jusan-ansible
## Description
This is a solution to ansible problems, and also a cheat sheet for the future if you remember working with ansible.

### How to use it?
Just go to any directory and you can run `bash setup.sh` .
It will also be useful if you will disassemble the scripts, and change, and see how it will work.
> Also you can watch ansible course on <img src="https://www.youtube.com/s/desktop/a14aba22/img/favicon_144x144.png" height="12"/> youtube by this [link](https://youtube.com/playlist?list=PLg5SS_4L6LYufspdPupdynbMQTBnZd31N)

### Worked on
- Debian GNU/Linux 11 (bullseye) 
- Docker version 20.10.16, build aa7e414
- ansible [core 2.12.6]
> Versions of applications under which the scripts worked

## Viewing order
You can parse the scripts in this order
- [x] [ansible-hello](ansible-hello)
- [x] [ansible-playbook](ansible-playbook) link to [apt](https://stepik.org/media/attachments/lesson/698792/checker-vault.sh), [service](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)
- [x] [ansible-basics](ansible-basics) link to [loop](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html), [jinja2](https://jinja.palletsprojects.com/en/3.1.x/templates/#synopsis)
- [x] [ansible-template](ansible-template) link to [jinja2](https://jinja.palletsprojects.com/en/3.1.x/templates/#synopsis), [copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html), [file](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html), [template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- [x] [ansible-apps](ansible-apps) link to [upstream in nginx](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)
- [x] [ansible-roles](ansible-roles) link to [roles in ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
- [x] [ansible-vault](ansible-vault) link to [vault in ansible](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
<!-- - [ ] [ansible-galaxy](ansible-galaxy) -->

## Explanations of frequently used commands in the script
These commands were often used in the script. I wrote explanations to them.

A command that deletes all containers which are called `local-vps-....` and have any characters after instead of a dot. Try running the command that is inside the brackets to see how it works.
```bash
docker container rm $(sudo docker container ps -a | grep -o local-vps-....) -f
```

The command launches a container with certain ports, and to which you can connect via ssh. Here is:
- `-d` - named `detach` which, after launching the container, exits from its console
- `--rm` - remove which, removes container after stopping it.
- `--name "CONTAINER_NAME"` - The `--name` parameter that sets the `CONTAINER_NAME` name to the created container. Using the name it is easy to manage the container. 
- `-p OUTSIDE_PORT:INSIDE_PORT` -  param `-p` translates the container's `INSIDE_PORT` port to the computer's `OUTSIDE_PORT`. The question will appear, why did I write twice? The first parameter -p is used for nginx server translation. And the second parameter -p is used to simply open the port, which is also used for `ssh` connection.
- `nginx:mainline` - name of `image` by which the docker container is created. It should be last parametr for docker. Why? After name of image we writes arguments, which sends to image or container as arguments. For example, here is [`atlekbai/local-vps`](https://hub.docker.com/r/atlekbai/local-vps) image takes 1 argument. It is port for opening ssh port in container.
```bash
V_PORT_SSH=2222
V_PORT_NGINX=2422
docker run -d --rm --name local-vps-$V_PORT_NGINX -p $V_PORT_NGINX:80 -p $V_PORT_SSH:$V_PORT_SSH atlekbai/local-vps $V_PORT_SSH
```

Connection to the device via the `V_PORT_SSH` (which equal to value which you set. Ex: 2222) port.
> Default password to the container is `password`.
- `-p PORT` - params using for try to connect host in port `PORT`.
- `root@127.0.0.1` - is last param where writes `username` before symbol `@`, and `host` value which equal to `IP`.
```bash
ssh -p $V_PORT_SSH root@127.0.0.1
```

The command after which you can connect to the device **without a password**. Try entering the command above, after this command.
- `-p PORT` - params using for try to connect host in port `PORT`.
- `-f` - force, which enters the data and immediately proceeds to enter the `password`.
- `root@127.0.0.1` - is last param where writes `username` before symbol `@`, and `host` value which equal to `IP`.
```bash
ssh-copy-id -p $V_PORT_SSH -f root@127.0.0.1
```

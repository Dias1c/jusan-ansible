# jusan-ansible
## Description
This is a solution to ansible problems, and also a cheat sheet for the future if you remember working with ansible.

### How to use it?
Just go to any file and you can run `bash setup.sh` .
It will also be useful if you will disassemble the scripts, and change, and see how it will work.

### Worked on
- Debian GNU/Linux 11 (bullseye) 
- Docker version 20.10.16, build aa7e414
- ansible [core 2.12.6]
> Versions of applications under which the scripts worked

## Viewing order
You can parse the scripts in this order
- [x] [ansible-hello](ansible-hello)
- [x] [ansible-playbook](ansible-playbook)
- [x] [ansible-basics](ansible-basics)
- [ ] [ansible-template](ansible-template)
- [ ] [ansible-apps](ansible-apps)
- [ ] [ansible-roles](ansible-roles)
- [ ] [ansible-vault](ansible-vault)
- [ ] [ansible-galaxy](ansible-galaxy)

## Notes ab scripts
These commands were often used in the script. I wrote explanations to them.


```bash
docker container rm $(sudo docker container ps -a | grep -o local-vps-....) -f
```


```bash
V_PORT_SSH=2222
V_PORT_NGINX=2422
docker run -d --rm --name local-vps-$V_PORT_NGINX -p $V_PORT_NGINX:$V_PORT_NGINX -p $V_PORT_SSH:$V_PORT_SSH atlekbai/local-vps $V_PORT_SSH
```


```bash
ssh -p $V_PORT_SSH root@127.0.0.1
```


```bash
ssh-copy-id -p $V_PORT_SSH -f root@127.0.0.1
```
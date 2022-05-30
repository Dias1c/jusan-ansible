PORT=2000

sudo docker container rm -f local-vps-$PORT 
sudo docker run -d --rm --name local-vps-$PORT -p $PORT:$PORT atlekbai/local-vps $PORT
sudo docker ps -a


echo "Try To enter to container:"
ssh -p $PORT root@127.0.0.1

echo "Initing file hosts.ini"
rm hosts.ini
cat << EOF > hosts.ini
[hello]
127.0.0.1 ansible_user=root ansible_port=$PORT
EOF

ansible -i hosts.ini hello -m ping
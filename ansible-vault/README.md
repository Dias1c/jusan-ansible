# Ansible Vault

Ansible Vault работает следующим образом:

1. Берем переменные, которые хотим зашифровать и сохраняем в файл переменных.
2. Ansible шифрует файл с переменными с помощью ключа (пароль).
3. Ключ (пароль) хранится отдельно от плейбука в том месте, к которому только вы имеете доступ.
4. Ключ используется, чтобы Ansible расшифровывал зашифрованный файл каждый раз, когда запускается плейбук.

- Документация [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

> Vault Password for [nginx_secret_token.yaml](./vars/nginx_secret_token.yaml) is `kazakhstan2022`
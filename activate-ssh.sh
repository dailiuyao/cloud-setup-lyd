chmod 600 ~/.ssh/id_cloud

ssh-keyscan -H 34.168.35.180 >> ~/.ssh/known_hosts
ssh-keyscan -H 35.230.3.106 >> ~/.ssh/known_hosts


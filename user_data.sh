#!/bin/bash

# Atualiza o sistema
sudo yum update -y

# Instala o Docker
sudo yum install docker -y

# Inicializa e habilita o Docker no início da instância
sudo systemctl start docker
sudo systemctl enable docker

# Instala o Docker Compose curl -L
"https://github.com/docker/compose/releases/latest/download/docker-compose-$(una
me -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Baixa o arquivo .yaml do GitHub curl -sL
"https://raw.githubusercontent.com/Ana408/atv_docker.PBAWS/main/docker-compos
e.yaml" --output "/home/ec2-user/docker-compose.yaml"

# Instala o cliente NFS
sudo yum install nfs-utils -y

# Cria um diretório para montagem
sudo mkdir /mnt/efs

# Define permissões no diretório para leitura, escrita e execução
sudo chmod 777 /mnt/efs

# Monta o sistema de arquivos com o EFS
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-07c68e847f4ea9744.efs.us-east-1.amazonaws.com:/ /mnt/efs

# Habilita a montagem automática na inicialização
echo "fs-07c68e847f4ea9744.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs defaults 0 0" | sudo tee -a /etc/fstab.

# Adiciona o usuário atual ao grupo do Docker
sudo usermod -aG docker ${USER}

# Dá permissões de leitura e escrita no docker.sock
sudo chmod 666 /var/run/docker.sock

# Cria o contêiner com o Docker Compose usando a imagem do .yaml
docker-compose -f /home/ec2-user/docker-compose.yaml up -d

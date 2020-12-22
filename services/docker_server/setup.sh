echo "[bootstrap] Configure Docker"
# Install and start Docker
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

systemctl start docker
systemctl enable docker

# Pull Docker secrets from AWS parameter store
cat > /usr/local/bin/docker_login << 'EOF'
  echo $(get_ssm_param docker-deployment-token) | \
    docker login --username $(get_ssm_param docker-deployment-user) --password-stdin
EOF
chmod +x /usr/local/bin/docker_login

for u in $(lid -g -n coretechs); do
  usermod -a -G docker $u
done

${additional_setup}

#!/bin/bash
# log output
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

PATH=$PATH:/usr/local/bin

${setup_logging}

echo "[bootstrap] Configure base server"

# Apply security updates
cat > /etc/cron.daily/security_updates << 'EOF'
yum update -y --security
EOF
chmod +x /etc/cron.daily/security_updates

yum update -y

# epel-release required for yum to find some packages
yum install -y epel-release
yum install -y unzip jq git wget python3 tmux vim

ln -sf /usr/bin/pip3 /usr/bin/pip

# Install AWS CLI
if ! which aws; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
fi

cat > /usr/local/bin/get_ssm_param << 'EOF'
/usr/local/bin/aws ssm get-parameter --name "$1" --with-decryption | jq --raw-output '.Parameter.Value'
EOF
chmod +x /usr/local/bin/get_ssm_param

CORETECHS_USERS_DIR=/opt/coretechs-users
if ! ls $CORETECHS_USERS_DIR > /dev/null ; then
  git_username=$(get_ssm_param github-user)
  git_password=$(get_ssm_param github-password)
  git clone https://$git_username:$git_password@github.com/gma-coretechs/coretechs-users $CORETECHS_USERS_DIR
fi

GIT_TAG="$${GIT_TAG-master}"
cd $CORETECHS_USERS_DIR && git fetch && git checkout $GIT_TAG && git pull && pip install -r requirements.txt

/opt/coretechs-users/sync_system_users.sh ${environment} ${sync_groups}

${additional_setup}

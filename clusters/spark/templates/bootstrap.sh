#!/bin/bash
set -e
#sudo exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#exec > >(tee /var/log/user-data.log) 2>&1

pwd

cat > setup_instance.sh << 'EOS'
echo "[bootstrap] Starting configure EMR instance"

echo "CORETECHS_PREFIX=${prefix}" >> /etc/environment

yum update -y && \
  yum install -y epel-release && \
  yum install -y unzip jq git wget tmux

IS_MASTER=$(jq .isMaster /mnt/var/lib/info/instance.json)
echo "IS_MASTER: $IS_MASTER"
export AWS_DEFAULT_REGION=${aws_region}

CORETECHS_USERS_DIR=/opt/coretechs-users
if ! ls $CORETECHS_USERS_DIR > /dev/null ; then
  echo "Cloning coretechs-users into $CORETECHS_USERS_DIR"
  git_username=$(aws ssm get-parameter --with-decryption --name "github-user" | jq .Parameter.Value --raw-output)
  git_password=$(aws ssm get-parameter --with-decryption --name "github-password" | jq .Parameter.Value --raw-output)
  git clone https://$git_username:$git_password@github.com/gma-coretechs/coretechs-users $CORETECHS_USERS_DIR
fi

GIT_TAG="$${GIT_TAG-master}"
cd $CORETECHS_USERS_DIR && git fetch && git checkout $GIT_TAG && git pull && pip install -r requirements.txt

/opt/coretechs-users/sync_system_users.sh ${environment} engineering data_science

cat > requirements.txt << EOF
${python_requirements}
EOF

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

if which pip; then
  pip -V
  sudo /usr/local/bin/pip uninstall -y numpy
  sudo /usr/local/bin/pip uninstall -y numpy
  sudo /usr/local/bin/pip uninstall -y numpy
  pip install -r requirements.txt
fi

/usr/local/bin/pip3 -V
/usr/local/bin/pip3 install -r requirements.txt

cat > /usr/local/bin/get_ssm_param << 'EOF'
/usr/local/bin/aws ssm get-parameter --name "$1" --with-decryption | jq --raw-output '.Parameter.Value'
EOF
chmod +x /usr/local/bin/get_ssm_param
EOS

aws s3 cp ${setup_logging_path} setup_logging.sh

sudo bash setup_logging.sh
sudo bash setup_instance.sh

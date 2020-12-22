echo "[bootstrap] Configure logging"
echo "CORETECHS_PREFIX=${prefix}" >> /etc/environment

cat > /etc/logrotate.d/coretechs << EOF
/var/log/coretechs/*.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    copytruncate
    sharedscripts
    dateext
    dateformat .%Y-%m-%d-%s
    extension .log
    lastaction
        /usr/local/bin/aws s3 sync /var/log/coretechs s3://${bucket_path}/${prefix}/$(hostname)/coretechs --sse --exclude "*.log"
    endscript
}
EOF

cat > /etc/logrotate.d/apache2 << EOF
/var/log/apache2/*.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    copytruncate
    sharedscripts
    dateext
    dateformat .%Y-%m-%d-%s
    extension .log
    lastaction
        /usr/local/bin/aws s3 sync /var/log/apache2 s3://${bucket_path}/${prefix}/$(hostname)/apache2 --sse --exclude "*.log"
    endscript
}
EOF

cat > /etc/logrotate.d/nginx << EOF
/var/log/nginx/*.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    copytruncate
    sharedscripts
    dateext
    dateformat .%Y-%m-%d-%s
    extension .log
    lastaction
        /usr/local/bin/aws s3 sync /var/log/nginx s3://${bucket_path}/${prefix}/$(hostname)/nginx --sse --exclude "*.log"
    endscript
}
EOF

if cat /etc/*-release | grep Amazon --silent; then
  wget http://packages.treasuredata.com.s3.amazonaws.com/3/amazon/1/2018.03/x86_64/td-agent-3.3.0-1.amazon2018.03.x86_64.rpm -O td-agent.rpm
  yum -y localinstall td-agent.rpm
else
  curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
fi

## Pre-requisites for install fluent plugins
yum -y -d1 install gcc gcc-c++ ruby-devel
/usr/sbin/td-agent-gem install fluent-plugin-s3 fluent-plugin-logit

## Configure fluentd
cat > /etc/td-agent/td-agent.conf << 'EOF'
${fluentd_conf}
EOF


## Set permissions for fluentd to read log files
for dir in nginx apache2 coretechs; do
  mkdir -p /var/log/$dir
  setfacl -m group:td-agent:x /var/log/$dir/
done
setfacl -m group:td-agent:r /var/log/secure

## Start fluentd daemon
sudo /etc/init.d/td-agent start

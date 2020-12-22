echo "[bootstrap] Configure landing zone"

yum install -y epel-release
yum install -y incron
chkconfig incrond on
service incrond start

## Set up upload sync and sftp server
LOG_DIR=/var/log/coretechs
SCRIPT_DIR=/opt/coretechs-lz

UPLOAD_DIR=/data/upload
DECRYPT_DIR=/data/decrypt
DOWNLOAD_DIR=/data/download

for dir in $LOG_DIR $SCRIPT_DIR $DOWNLOAD_DIR $UPLOAD_DIR $DECRYPT_DIR; do
  mkdir -p $dir
  chmod 777 $dir
done

cat > $SCRIPT_DIR/sync_upload << 'EOF'
${sync_upload}
EOF
chmod +x $SCRIPT_DIR/sync_upload

cat > $SCRIPT_DIR/sync_decrypt << 'EOF'
${sync_decrypt}
EOF
chmod +x $SCRIPT_DIR/sync_decrypt

## Incrond script to upload file upon detecting new file written to the UPLOAD_DIR
cat > /etc/incron.d/upload_sync << EOF
$UPLOAD_DIR IN_CLOSE_WRITE $SCRIPT_DIR/sync_upload \$# >> $LOG_DIR/landingzone.log 2>&1
$DECRYPT_DIR IN_CLOSE_WRITE $SCRIPT_DIR/sync_decrypt \$# >> $LOG_DIR/landingzone.log 2>&1
EOF

cat > $SCRIPT_DIR/start_sftp_server << 'EOF'
${start_sftp_server}
EOF
chmod +x $SCRIPT_DIR/start_sftp_server

cat > /etc/cron.d/sftp_server << EOF
@reboot sudo $SCRIPT_DIR/start_sftp_server >> $LOG_DIR/landingzone.log 2>&1
EOF

cat >> /etc/ssh/sshd_config << EOF

Port ${ssh_port}
EOF
semanage port -a -t ssh_port_t -p tcp ${ssh_port}
service sshd restart || service ssh restart
systemctl status sshd.service
journalctl -xe

$SCRIPT_DIR/start_sftp_server

${additional_setup}

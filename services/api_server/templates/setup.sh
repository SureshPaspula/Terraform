echo "[bootstrap] Configure API server"
mkdir -p /opt/coretechs

if ! ls /opt/coretechs/rds-combined-ca-bundle.pem > /dev/null; then
  wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -O /opt/coretechs/rds-combined-ca-bundle.pem
fi

cat > /usr/local/bin/get_mongodb_uri << 'EOF'
  db_username=$1
  db_password=$(get_ssm_param docdb-password-client)
  db_host=${mongodb_host}
  db_port=27017
  echo "mongodb://$db_username:$db_password@$db_host:$db_port/coretechs?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred"
EOF
chmod +x /usr/local/bin/get_mongodb_uri

cat > /opt/coretechs/start_api_server.sh << 'EOF'
${start_api_server}
EOF
chmod +x /opt/coretechs/start_api_server.sh

cat > /opt/coretechs/run_telnet_health_check.sh << 'EOF'
${run_telnet_health_check}
EOF
chmod +x /opt/coretechs/run_telnet_health_check.sh

cat > /opt/coretechs/run_api_health_checks.sh << 'EOF'
${run_api_health_checks}
EOF
chmod +x /opt/coretechs/run_api_health_checks.sh

cat > /etc/cron.d/health_checks << 'EOF'
* * * * * root /opt/coretechs/run_telnet_health_check.sh ${mongodb_host} ${mongodb_port} mongodb
* * * * * root /opt/coretechs/run_api_health_checks.sh
EOF

/opt/coretechs/start_api_server.sh

${additional_setup}

echo "[bootstrap] Configure web server"
mkdir -p /opt/coretechs

cat > /opt/coretechs/start_web_server.sh << 'EOF'
${start_web_server}
EOF
chmod +x /opt/coretechs/start_web_server.sh

/opt/coretechs/start_web_server.sh
${additional_setup}

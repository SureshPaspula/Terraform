cat > /etc/cron.hourly/sync_hadoop_group << 'EOF'
for u in $(lid -g -n coretechs); do
  usermod -a -G hadoop $u
  su hdfs -c "hdfs dfs -mkdir -p /user/$u && hdfs dfs -chown $u:hadoop /user/$u"
done
EOF
chmod +x /etc/cron.hourly/sync_hadoop_group

echo 'export PYSPARK_PYTHON=/usr/bin/python3' >> /etc/spark/conf/spark-env.sh

chmod 444 /var/aws/emr/userData.json

mkdir -p /mnt/var/{cache,tmp}
chmod -R 777 /mnt
chmod -R 777 /mnt1

mkdir -p /mnt/var/log/spark/user
chmod -R 777 /mnt/var/log/spark
chown -R :hadoop /mnt/var/log/spark

#!/usr/bin/bash
PATH=$PATH:/usr/local/bin
docker_login
docker stop api
docker run \
  -d \
  --rm \
  --name api \
  -p ${port}:80 \
  -e MONGODB_HOST="$(get_mongodb_uri coretechs-api)" \
  -e JWT_SECRET_KEY=$(get_ssm_param api-jwt-key) \
  -e MAIL_USERNAME=$(get_ssm_param mail-username) \
  -e MAIL_PASSWORD=$(get_ssm_param mail-password) \
  -e LOGLEVEL=INFO \
  -v /opt/coretechs/rds-combined-ca-bundle.pem:/var/www/coretechs-api/rds-combined-ca-bundle.pem \
  -v /var/log/apache2:/var/log/apache2 \
  --log-driver=fluentd \
  --log-opt tag="docker.api" \
  graymatteranalytics/coretechs-api:${docker_tag}

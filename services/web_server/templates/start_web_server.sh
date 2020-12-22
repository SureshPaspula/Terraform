#!/usr/bin/bash
PATH=/usr/local/bin:$PATH

docker_login
docker stop web
docker run -d \
       --rm \
       --name web \
       -p ${port}:80 \
       -e CORETECHS_API_HOST="${api_url}" \
       -e SHORT_HOSPITAL_NAME="${short_hospital_name}" \
       -e HOSPITAL_NAME="${hospital_name}" \
       -v /var/log/apache2:/var/log/apache2 \
       -v /var/log/nginx:/var/log/nginx \
       --log-driver=fluentd \
       --log-opt tag="docker.web" \
       graymatteranalytics/coretechs-web-2:${docker_tag}

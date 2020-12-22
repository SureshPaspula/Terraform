HOST=$1
PORT=$2
SERVICE_NAME=$3
d1=$(( $(date '+%s%N') / 1000));
echo -e '\x1dclose\x0d' | telnet $HOST $PORT;
d2=$(( $(date '+%s%N') / 1000));
d1seconds=$((d1 / 1000000))
if [ "$?" = "0" ]; then
    printf '{"health-check.host": "%s", "health-check.port": %s, "health-check.service_name": "%s", "health-check.successful": 1, "time": %s, "health-check.duration-micros": %s}\n' "$HOST" "$PORT" "$SERVICE_NAME" "$d1seconds" "$(($d2-$d1))" >> /var/log/coretechs/health-checks.log
else
    printf '{"health-check.host": "%s", "health-check.port": %s, "health-check.service_name": "%s", "health-check.successful": 0, "time": %s, "health-check.duration-micros": %s}\n' "$HOST" "$PORT" "$SERVICE_NAME" "$d1seconds" "$(($d2-$d1))" >> /var/log/coretechs/health-checks.log
fi

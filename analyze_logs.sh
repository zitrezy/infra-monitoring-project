#!/bin/bash

> access.log
for i in {1..300}; do
    IP_POOL=("192.168.1.10" "10.0.0.5" "172.16.0.20" "8.8.8.8" "192.168.0.108")
    IP=${IP_POOL[$RANDOM % ${#IP_POOL[@]}]}
    METHODS=("GET" "POST" "PUT" "DELETE")
    METHOD=${METHODS[$RANDOM % ${#METHODS[@]}]}
    CODES=(200 200 200 301 400 401 403 404 500 502)
    CODE=${CODES[$RANDOM % ${#CODES[@]}]}
    PATHS=("/api/users" "/api/login" "/api/items" "/index.html")
    REQ_PATH=${PATHS[$RANDOM % ${#PATHS[@]}]}
    echo "$IP - - [15/Aug/2026:10:15:32] \"$METHOD $REQ_PATH HTTP/1.1\" $CODE" | tr -d '\r' >> access.log
done

TOTAL=`cat access.log | wc -l`
echo "Общее количество запросов: $TOTAL"

echo "Топ-3 IP-адреса:"
grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' access.log | sort | uniq -c | sort -nr | head -n 3

echo "Количество запросов с кодами 4xx и 5xx:"
awk '$NF >= 400 && $NF < 500 { count_4xx++ } $NF >= 500 && $NF < 600 { count_5xx++ } END { print "4xx: " count_4xx; print "5xx: " count_5xx }' access.log

#!/bin/bash

docker run --name nginx_con --privileged -p 8080:80 -p 44300:443  -dit yama_nginx:test1 /bin/bash
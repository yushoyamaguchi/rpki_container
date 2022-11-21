#!/bin/bash

docker run --name krill_con --privileged -p 8080:80  -p 8030:3000 -dit yama_krill:test1 /bin/bash
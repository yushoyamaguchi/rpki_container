#!/bin/bash

docker run --name CACHE --privileged -p 8080:8080 -dit yama_routinator_build:test1 /bin/bash
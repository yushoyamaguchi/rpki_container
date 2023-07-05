#!/bin/bash

docker run --name openbgpd_test --privileged -p 8080:8080 -dit --entrypoint /bin/bash yama_openbgpd1:aspa /bin/bash
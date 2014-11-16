#!/bin/bash

PATH="$PATH:/opt/docker/bin/"

 cd $(dirname $(readlink -f $0)) &&
(cd base    && docker build -t local/base .    ) &&
(cd apache2 && docker build -t local/apache .  ) &&
(cd vulcand && docker build -t local/vulcand . )

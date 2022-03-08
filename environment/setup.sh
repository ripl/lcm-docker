#!/bin/bash

# NOTE: this setup script will be executed right before the launcher file inside the container,
#       use it to configure your environment.

export LCM_DEFAULT_URL="udpm://${LCM_IP}:${LCM_PORT}?ttl=${LCM_TTL}"

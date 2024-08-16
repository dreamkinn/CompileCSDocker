#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$1" == "docker" ] || [ "$1" == "podman" ]; then
    ENGINE=$1
else
    echo -e "${RED}Invalid argument. Please specify either 'docker' or 'podman'.${NC}"
    exit 1
fi

ln -sf Dockerfiles/Dockerfile_$ENGINE Dockerfile || exit 1

echo -e "${GREEN}[+] Building ${ENGINE^} image...${NC}"
$ENGINE build -t csbuild . || exit 1

echo -e "${GREEN}[+] You can run : ${ENGINE} run -it -v $(pwd):/data --rm csbuild <tool>${NC}"
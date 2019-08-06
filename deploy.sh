#!/usr/bin/env bash
set -e

echo "--------------------- Compile with docker"
docker run -v $(pwd):/opt/build --rm -it elixir-ubuntu:latest ./build-release.sh
echo "--------------------- rsync to the server"
rsync -r _build/prod/rel/njuus/* web@njuus.ee:/home/web/njuus/
echo "--------------------- Extract and restart service"
ssh root@njuus.ee 'systemctl restart njuus'
echo "--------------------- Done"
ssh -t root@njuus.ee 'journalctl -n 300 -f -t njuus'

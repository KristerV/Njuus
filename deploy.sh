#!/usr/bin/env bash
set -e

echo "--------------------- Create base image"
docker build -t elixir-ubuntu:latest .
echo "--------------------- Compile with docker"
docker run -v $(pwd):/opt/build --rm -it elixir-ubuntu:latest ./build.sh
echo "--------------------- SCP to the server"
scp -r rel/artifacts/njuus-0.1.0.tar.gz web@68.183.208.25:/home/web/
echo "--------------------- Extract and restart service"
# 1. clean out previous files
# 2. scp and extract
# 3. chown web:web
# 4. start service
ssh root@68.183.208.25 'cd /home/web/ && rm -rf njuus/* && tar -xzf njuus-0.1.0.tar.gz -C njuus && chown -R web:web * && systemctl restart njuus'
echo "--------------------- Done"
ssh -t root@68.183.208.25 'journalctl -n 300 -f -t njuus'

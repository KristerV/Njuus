#!/usr/bin/env bash
echo "--------------------- Compile with docker"
docker run -v $(pwd):/opt/build --rm -it elixir-ubuntu:latest ./build.sh
echo "--------------------- SCP to the server"
scp -r rel/artifacts/njuus-0.1.0.tar.gz web@68.183.208.25:/home/web/
echo "--------------------- Extract and restart service"
ssh root@68.183.208.25 'cd /home/web/ && tar -xzvf njuus-0.1.0.tar.gz -C njuus && systemctl restart njuus'
echo "--------------------- Done"
ssh -t root@68.183.208.25 'journalctl -n 300'

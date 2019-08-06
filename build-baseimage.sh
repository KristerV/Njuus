#!/usr/bin/env bash
set -e

echo "--------------------- Create base image"
docker build -t elixir-ubuntu:latest .
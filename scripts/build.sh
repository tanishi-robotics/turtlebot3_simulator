#!/usr/bin/env bash
set -euo pipefail

docker build -f docker/Dockerfile -t turtlebot3-sim:humble .

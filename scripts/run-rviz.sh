#!/usr/bin/env bash
set -euo pipefail

: "${ROS_DOMAIN_ID:?ROS_DOMAIN_ID must be set on the host before starting Docker}"

if command -v xhost >/dev/null 2>&1; then
  xhost +local:docker >/dev/null
fi

docker compose -f docker/docker-compose.yml run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_rviz.launch.py

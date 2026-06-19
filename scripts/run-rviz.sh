#!/usr/bin/env bash
set -euo pipefail

if command -v xhost >/dev/null 2>&1; then
  xhost +local:docker >/dev/null
fi

docker compose run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_rviz.launch.py

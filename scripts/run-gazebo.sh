#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./scripts/run-gazebo.sh [--cpu|--gpu]

Options:
  --cpu    Use CPU-only software rendering. This is the default.
  --gpu    Use the NVIDIA GPU Docker Compose override.
  -h, --help
           Show this help.
USAGE
}

use_gpu=0

while (($#)); do
  case "$1" in
    --cpu)
      use_gpu=0
      ;;
    --gpu)
      use_gpu=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

: "${ROS_DOMAIN_ID:?ROS_DOMAIN_ID must be set on the host before starting Docker}"

if command -v xhost >/dev/null 2>&1; then
  xhost +local:docker >/dev/null
fi

container_name=turtlebot3-sim-humble
compose_files=(-f docker/docker-compose.yml)
mode_name=CPU

if ((use_gpu)); then
  compose_files+=(-f docker/docker-compose.gpu.yml)
  mode_name=GPU
fi

container_is_running() {
  docker ps --format '{{.Names}}' | grep -qx "$container_name"
}

container_is_gpu() {
  docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$container_name" 2>/dev/null \
    | grep -qx 'NVIDIA_VISIBLE_DEVICES=all'
}

if container_is_running; then
  if ((use_gpu)) && ! container_is_gpu; then
    echo "Container '$container_name' is already running in CPU mode." >&2
    echo "Stop it first with: docker stop $container_name" >&2
    exit 1
  fi

  if ((! use_gpu)) && container_is_gpu; then
    echo "Container '$container_name' is already running in GPU mode." >&2
    echo "Stop it first with: docker stop $container_name" >&2
    exit 1
  fi
else
  docker rm -f "$container_name" >/dev/null 2>&1 || true
  docker compose "${compose_files[@]}" \
    run -d --name "$container_name" sim sleep infinity
fi

echo "Starting Gazebo in $mode_name mode. Press Ctrl-C to stop Gazebo; the Docker container will keep running."

docker exec -ti "$container_name" bash -lc \
  'source /opt/ros/humble/setup.bash && source /ros2_ws/install/setup.bash && ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_world.launch.py'

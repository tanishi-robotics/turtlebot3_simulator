#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./scripts/run-rviz.sh [--cpu|--gpu]

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

compose_files=(-f docker/docker-compose.yml)

if ((use_gpu)); then
  compose_files+=(-f docker/docker-compose.gpu.yml)
fi

docker compose "${compose_files[@]}" \
  run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_rviz.launch.py

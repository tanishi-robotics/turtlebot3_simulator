# TurtleBot3 Simulator on ROS 2 Humble

This workspace runs a ROS 2 Humble TurtleBot3 Waffle Gazebo simulation in Docker.
The default world is AWS RoboMaker Small House World from AWS Robotics, and the robot model includes an Intel RealSense R200 RGB/depth camera configuration.
CycloneDDS is used as the ROS middleware implementation.

## Requirements

- Docker
- Docker Compose v2
- Linux desktop environment with X11
- `ROS_DOMAIN_ID` set on the host

## Quick Start

```bash
export ROS_DOMAIN_ID=30
./scripts/build.sh
./scripts/run-gazebo.sh
```

For NVIDIA GPU rendering, install NVIDIA Container Toolkit on the host and run:

```bash
export ROS_DOMAIN_ID=30
./scripts/run-gazebo-gpu.sh
```

![Quick start demo](docs/assets/quick-start.gif)

To visualize the robot model, LiDAR scan, RGB image, and depth image in RViz, start the Gazebo simulation first and then run this from another terminal:

```bash
export ROS_DOMAIN_ID=30
./scripts/run-rviz.sh
```

When Gazebo is running with GPU rendering, RViz can also be started with the GPU override:

```bash
export ROS_DOMAIN_ID=30
./scripts/run-rviz-gpu.sh
```

The Docker container uses the exact `ROS_DOMAIN_ID` value provided by the host environment. The run scripts stop with an error if it is not set.

## Published Interfaces

Expected ROS 2 topics published by the simulation:

- `/cmd_vel_safe`
- `/odom`
- `/scan`
- `/imu`
- `/joint_states`
- `/camera/image_raw`
- `/camera/camera_info`
- `/camera/depth/image_raw`
- `/camera/depth/camera_info`
- `/camera/depth/points`
- `/tf`
- `/tf_static`

Teleoperation commands should be published to `/cmd_vel`. The simulation relays `/cmd_vel` through a watchdog to `/cmd_vel_safe`, and the Gazebo diff drive plugin consumes `/cmd_vel_safe` so the robot stops if teleoperation commands disappear.

Camera TF frames are provided by the TurtleBot3 Waffle URDF:

- `base_link` -> `camera_link`
- `camera_link` -> `camera_rgb_frame`
- `camera_link` -> `camera_depth_frame`

## Useful Commands

Open a shell inside the container:

```bash
export ROS_DOMAIN_ID=30
./scripts/shell.sh
```

Launch the default AWS Small House simulation manually:

```bash
docker compose -f docker/docker-compose.yml run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_world.launch.py
```

Run keyboard teleoperation from another terminal:

```bash
docker compose -f docker/docker-compose.yml run --rm sim ros2 run turtlebot3_teleop teleop_keyboard
```

CycloneDDS is configured by:

```bash
RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI=file:///etc/cyclonedds/cyclonedds.xml
```

## Directory Map

```text
.
|-- docker/
|   |-- Dockerfile
|   |-- Dockerfile.dockerignore
|   |-- docker-compose.gpu.yml
|   |-- docker-compose.yml
|   |-- cyclonedds.xml
|   `-- ros_entrypoint.sh
|-- docs/
|   `-- assets/
|       `-- quick-start.gif
|-- scripts/
|   |-- build.sh
|   |-- run-gazebo-gpu.sh
|   |-- run-gazebo.sh
|   |-- run-rviz-gpu.sh
|   |-- run-rviz.sh
|   `-- shell.sh
|-- src/
|   `-- turtlebot3_stereo_sim/
|       |-- CMakeLists.txt
|       |-- package.xml
|       |-- launch/
|       |   |-- turtlebot3_stereo_rviz.launch.py
|       |   `-- turtlebot3_stereo_world.launch.py
|       |-- models/
|       |   `-- turtlebot3_waffle_stereo/
|       |       |-- model.config
|       |       `-- model.sdf
|       |-- rviz/
|       |   `-- turtlebot3_stereo.rviz
|       `-- scripts/
|           `-- cmd_vel_watchdog.py
|-- .gitignore
|-- LICENSE
`-- README.md
```

## Notes

- The Docker image clones AWS RoboMaker Small House World from `aws-robotics/aws-robomaker-small-house-world` during build.
- `./scripts/run-gazebo.sh` uses CPU-only software rendering.
- `./scripts/run-gazebo-gpu.sh` enables the Docker Compose GPU override for NVIDIA GPU rendering.

## License

This repository is licensed under the Apache License 2.0. See `LICENSE`.
Third-party software installed or downloaded by the Docker image, including ROS 2, TurtleBot3, Gazebo, CycloneDDS, and AWS RoboMaker Small House World, is distributed under each upstream project's license.
AWS RoboMaker Small House World is distributed under the MIT-0 license.

AWS RoboMaker Small House World is provided by AWS Robotics:
https://github.com/aws-robotics/aws-robomaker-small-house-world

---

# ROS 2 Humble TurtleBot3 Simulator

このワークスペースは、ROS 2 Humble の TurtleBot3 Waffle Gazebo simulation を Docker 上で起動します。
デフォルトの world は AWS Robotics の AWS RoboMaker Small House World です。
robot model には Intel RealSense R200 RGB/depth camera 構成を含めています。
ROS middleware implementation には CycloneDDS を使います。

## 必要環境

- Docker
- Docker Compose v2
- X11 が使える Linux desktop environment
- host 側で `ROS_DOMAIN_ID` が設定されていること

## クイックスタート

```bash
export ROS_DOMAIN_ID=30
./scripts/build.sh
./scripts/run-gazebo.sh
```

NVIDIA GPU rendering を使う場合は、host に NVIDIA Container Toolkit を入れたうえで次を実行します。

```bash
export ROS_DOMAIN_ID=30
./scripts/run-gazebo-gpu.sh
```

![Quick start demo](docs/assets/quick-start.gif)

robot model、LiDAR scan、RGB image、depth image を RViz で可視化する場合は、先に Gazebo simulation を起動し、別ターミナルで次を実行します。

```bash
export ROS_DOMAIN_ID=30
./scripts/run-rviz.sh
```

Gazebo を GPU rendering で起動している場合は、RViz も GPU override 付きで起動できます。

```bash
export ROS_DOMAIN_ID=30
./scripts/run-rviz-gpu.sh
```

Docker container 内の `ROS_DOMAIN_ID` は、host 環境変数の値に固定されます。未設定の場合、起動スクリプトはエラーで停止します。

## 公開インターフェース

simulation が publish する ROS 2 topics:

- `/cmd_vel_safe`
- `/odom`
- `/scan`
- `/imu`
- `/joint_states`
- `/camera/image_raw`
- `/camera/camera_info`
- `/camera/depth/image_raw`
- `/camera/depth/camera_info`
- `/camera/depth/points`
- `/tf`
- `/tf_static`

teleop の速度指令は `/cmd_vel` に publish してください。simulation は `/cmd_vel` を watchdog 経由で `/cmd_vel_safe` へ relay し、Gazebo の diff drive plugin は `/cmd_vel_safe` を使います。これにより teleop の指令が途切れた場合も robot が停止します。

camera TF frames は TurtleBot3 Waffle URDF から publish されます。

- `base_link` -> `camera_link`
- `camera_link` -> `camera_rgb_frame`
- `camera_link` -> `camera_depth_frame`

## 便利なコマンド

コンテナ内の shell を開く:

```bash
export ROS_DOMAIN_ID=30
./scripts/shell.sh
```

default の AWS Small House simulation を手動起動する:

```bash
docker compose -f docker/docker-compose.yml run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_world.launch.py
```

別ターミナルから keyboard teleoperation を起動する:

```bash
docker compose -f docker/docker-compose.yml run --rm sim ros2 run turtlebot3_teleop teleop_keyboard
```

CycloneDDS は次の設定で使います。

```bash
RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI=file:///etc/cyclonedds/cyclonedds.xml
```

## ディレクトリマップ

```text
.
|-- docker/
|   |-- Dockerfile
|   |-- Dockerfile.dockerignore
|   |-- docker-compose.gpu.yml
|   |-- docker-compose.yml
|   |-- cyclonedds.xml
|   `-- ros_entrypoint.sh
|-- docs/
|   `-- assets/
|       `-- quick-start.gif
|-- scripts/
|   |-- build.sh
|   |-- run-gazebo-gpu.sh
|   |-- run-gazebo.sh
|   |-- run-rviz-gpu.sh
|   |-- run-rviz.sh
|   `-- shell.sh
|-- src/
|   `-- turtlebot3_stereo_sim/
|       |-- CMakeLists.txt
|       |-- package.xml
|       |-- launch/
|       |   |-- turtlebot3_stereo_rviz.launch.py
|       |   `-- turtlebot3_stereo_world.launch.py
|       |-- models/
|       |   `-- turtlebot3_waffle_stereo/
|       |       |-- model.config
|       |       `-- model.sdf
|       |-- rviz/
|       |   `-- turtlebot3_stereo.rviz
|       `-- scripts/
|           `-- cmd_vel_watchdog.py
|-- .gitignore
|-- LICENSE
`-- README.md
```

## 補足

- Docker image build 時に `aws-robotics/aws-robomaker-small-house-world` から AWS RoboMaker Small House World を clone します。
- `./scripts/run-gazebo.sh` は CPU-only の software rendering で起動します。
- `./scripts/run-gazebo-gpu.sh` は Docker Compose の GPU override を有効にして NVIDIA GPU rendering で起動します。

## ライセンス

このリポジトリのライセンス詳細は `LICENSE` を参照してください。
Docker image 内で install または download される ROS 2、TurtleBot3、Gazebo、CycloneDDS、AWS RoboMaker Small House World などの third-party software は、それぞれの upstream project の license に従います。
AWS RoboMaker Small House World は MIT-0 license で配布されています。

AWS RoboMaker Small House World は AWS Robotics により提供されています:
https://github.com/aws-robotics/aws-robomaker-small-house-world

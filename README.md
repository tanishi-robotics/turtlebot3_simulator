# TurtleBot3 Simulator on ROS 2 Humble

This workspace runs the ROS 2 Humble TurtleBot3 Gazebo simulation in Docker.
The default simulation is TurtleBot3 Waffle with an Intel RealSense R200 RGB/depth camera configuration.
CycloneDDS is used as the ROS middleware implementation.

## Requirements

- Docker
- Docker Compose v2
- Linux desktop environment with X11

## Quick Start

```bash
./scripts/build.sh
./scripts/run-gazebo.sh
```

![Quick start demo](docs/assets/quick-start.gif)

The Gazebo model uses the TurtleBot3 Waffle built-in Intel RealSense R200 RGB camera and adds a depth sensor aligned with the R200 depth frame.

To visualize the robot model, LiDAR scan, RGB image, and depth image in RViz, start the Gazebo simulation first and then run this from another terminal:

```bash
./scripts/run-rviz.sh
```

## Published Interfaces

Expected ROS 2 topics:

- `/camera/image_raw`
- `/camera/camera_info`
- `/camera/depth/image_raw`
- `/camera/depth/camera_info`
- `/camera/depth/points`
- `/tf_static`

Camera TF frames are provided by the TurtleBot3 Waffle URDF:

- `base_link` -> `camera_link`
- `camera_link` -> `camera_rgb_frame`
- `camera_link` -> `camera_depth_frame`

## Useful Commands

Open a shell inside the container:

```bash
./scripts/shell.sh
```

Launch the Gazebo world manually:

```bash
docker compose run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_world.launch.py
```

Launch an empty world:

```bash
docker compose run --rm sim ros2 launch turtlebot3_gazebo empty_world.launch.py
```

Run keyboard teleoperation from another terminal:

```bash
docker compose run --rm sim ros2 run turtlebot3_teleop teleop_keyboard
```

```bash
RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
CYCLONEDDS_URI=file:///etc/cyclonedds/cyclonedds.xml
```

## Directory Map

```text
.
|-- Dockerfile
|-- docker-compose.yml
|-- docker/
|   |-- cyclonedds.xml
|   `-- ros_entrypoint.sh
|-- docs/
|   `-- assets/
|       `-- quick-start.gif
|-- scripts/
|   |-- build.sh
|   |-- run-gazebo.sh
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
|       `-- rviz/
|           `-- turtlebot3_stereo.rviz
|-- .dockerignore
|-- .gitignore
|-- LICENSE
`-- README.md
```

## Notes
- To use an NVIDIA GPU, install NVIDIA Container Toolkit on the host and add GPU options to the Compose configuration.

## License

This repository is licensed under the Apache License 2.0. See `LICENSE`.
Third-party software installed by the Docker image, including ROS 2, TurtleBot3, Gazebo, and CycloneDDS, is distributed under each upstream project's license.

---

# ROS 2 Humble TurtleBot3 Simulator

このワークスペースは、ROS 2 Humble の TurtleBot3 Gazebo simulation を Docker 上で起動します。
デフォルトの simulation は Intel RealSense R200 RGB/depth camera 構成の TurtleBot3 Waffle です。
ROS middleware implementation には CycloneDDS を使います。

## 必要環境

- Docker
- Docker Compose v2
- X11 が使える Linux desktop environment

## クイックスタート

```bash
./scripts/build.sh
./scripts/run-gazebo.sh
```

![Quick start demo](docs/assets/quick-start.gif)

Gazebo model は TurtleBot3 Waffle 標準の Intel RealSense R200 RGB camera を使い、R200 の depth frame に合わせた depth sensor を追加します。

robot model、LiDAR scan、RGB image、depth image を RViz で可視化する場合は、先に Gazebo simulation を起動し、別ターミナルで次を実行します。

```bash
./scripts/run-rviz.sh
```

## 公開インターフェース

期待する ROS 2 topics:

- `/camera/image_raw`
- `/camera/camera_info`
- `/camera/depth/image_raw`
- `/camera/depth/camera_info`
- `/camera/depth/points`
- `/tf_static`

camera TF frames は TurtleBot3 Waffle URDF から publish されます。

- `base_link` -> `camera_link`
- `camera_link` -> `camera_rgb_frame`
- `camera_link` -> `camera_depth_frame`

## 便利なコマンド

コンテナ内の shell を開く:

```bash
./scripts/shell.sh
```

Gazebo world を手動起動する:

```bash
docker compose run --rm sim ros2 launch turtlebot3_stereo_sim turtlebot3_stereo_world.launch.py
```

空の world を起動する:

```bash
docker compose run --rm sim ros2 launch turtlebot3_gazebo empty_world.launch.py
```

別ターミナルから keyboard teleoperation を起動する:

```bash
docker compose run --rm sim ros2 run turtlebot3_teleop teleop_keyboard
```

## ディレクトリマップ

```text
.
|-- Dockerfile
|-- docker-compose.yml
|-- docker/
|   |-- cyclonedds.xml
|   `-- ros_entrypoint.sh
|-- docs/
|   `-- assets/
|       `-- quick-start.gif
|-- scripts/
|   |-- build.sh
|   |-- run-gazebo.sh
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
|       `-- rviz/
|           `-- turtlebot3_stereo.rviz
|-- .dockerignore
|-- .gitignore
|-- LICENSE
`-- README.md
```

## 補足
- NVIDIA GPU を使う場合は、host に NVIDIA Container Toolkit を入れたうえで Compose configuration に GPU options を追加してください。

## ライセンス

このリポジトリのライセンス詳細は `LICENSE` を参照してください。
Docker image 内で install される ROS 2、TurtleBot3、Gazebo、CycloneDDS などの third-party software は、それぞれの upstream project の license に従います。

FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle
ENV CYCLONEDDS_URI=file:///etc/cyclonedds/cyclonedds.xml
ENV ROS_WS=/ros2_ws

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    git \
    python3-colcon-common-extensions \
    python3-rosdep \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-turtlebot3 \
    ros-humble-turtlebot3-gazebo \
    ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3-simulations \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init 2>/dev/null || true

RUN mkdir -p "${ROS_WS}/src" /etc/cyclonedds

COPY docker/cyclonedds.xml /etc/cyclonedds/cyclonedds.xml
COPY docker/ros_entrypoint.sh /ros_entrypoint.sh
COPY src ${ROS_WS}/src

RUN chmod +x /ros_entrypoint.sh

WORKDIR ${ROS_WS}

RUN source "/opt/ros/${ROS_DISTRO}/setup.bash" \
    && if [ -n "$(find "${ROS_WS}/src" -mindepth 1 -maxdepth 1 -type d)" ]; then \
         colcon build --symlink-install --base-paths "${ROS_WS}/src"; \
       fi

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

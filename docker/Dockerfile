FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV TURTLEBOT3_MODEL=waffle
ENV CYCLONEDDS_URI=file:///etc/cyclonedds/cyclonedds.xml
ENV ROS_WS=/ros2_ws
ENV SMALL_HOUSE_WORLD_PATH=/opt/aws-robomaker-small-house-world

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

RUN git clone --depth 1 --branch ros1 \
      https://github.com/aws-robotics/aws-robomaker-small-house-world.git "${SMALL_HOUSE_WORLD_PATH}" \
    && perl -0pi -e 's/\s*<include>\s*<pose>-3\.5 -4\.5 0\.0 0\.0 0\.0 1\.58<\/pose>\s*<uri>model:\/\/turtlebot3_waffle_pi<\/uri>\s*<\/include>//s' \
      "${SMALL_HOUSE_WORLD_PATH}/worlds/small_house.world" \
    && perl -0pi -e 's#<gui>.*?</gui>#<gui>\n      <camera name="gzclient_camera">\n        <pose>-5.0 -5.7 1.2 0 0.35 0.85</pose>\n        <view_controller>orbit</view_controller>\n        <projection_type>perspective</projection_type>\n        <track_visual>\n          <name>waffle::base_link::base_visual</name>\n          <static>false</static>\n          <use_model_frame>true</use_model_frame>\n          <xyz>-1.8 0 0.8</xyz>\n          <inherit_yaw>true</inherit_yaw>\n        </track_visual>\n      </camera>\n    </gui>#s' \
      "${SMALL_HOUSE_WORLD_PATH}/worlds/small_house.world" \
    && sed -i 's#<shadows>1</shadows>#<shadows>false</shadows>#' \
      "${SMALL_HOUSE_WORLD_PATH}/worlds/small_house.world" \
    && find "${SMALL_HOUSE_WORLD_PATH}/models" -name model.sdf -print0 \
      | xargs -0 sed -i \
          "s#file://models/#file://${SMALL_HOUSE_WORLD_PATH}/models/#g"

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

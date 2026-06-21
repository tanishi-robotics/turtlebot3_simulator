cmake_minimum_required(VERSION 3.8)
project(turtlebot3_stereo_sim)

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY launch models rviz
  DESTINATION share/${PROJECT_NAME}
)

install(
  PROGRAMS
    scripts/cmd_vel_watchdog.py
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()

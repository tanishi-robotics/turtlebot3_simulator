import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    pkg_stereo_sim = get_package_share_directory('turtlebot3_stereo_sim')
    rviz_config = os.path.join(
        pkg_stereo_sim,
        'rviz',
        'turtlebot3_stereo.rviz',
    )

    return LaunchDescription([
        Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            arguments=['-d', rviz_config],
            output='screen',
        ),
    ])

cmake_minimum_required(VERSION 3.0.2)
project(msgs)

add_compile_options(-std=c++17)

find_package(catkin REQUIRED COMPONENTS
  std_msgs
  geometry_msgs
  message_generation
)

# 消息定义
set(MSG_FILES
  Localization.msg
  VehicleState.msg
  Obstacle.msg
  ObstacleArray.msg
  TrajectoryPoint.msg
  Trajectory.msg
  Mission.msg
)

add_message_files(
  FILES
  ${MSG_FILES}
)

generate_messages(
  DEPENDENCIES
  std_msgs
  geometry_msgs
)

catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS std_msgs geometry_msgs message_runtime
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

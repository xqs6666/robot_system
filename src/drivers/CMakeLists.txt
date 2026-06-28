cmake_minimum_required(VERSION 3.0.2)
project(drivers)

add_compile_options(-std=c++17)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  sensor_msgs
  geometry_msgs
  tf
)

catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS roscpp sensor_msgs geometry_msgs tf
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

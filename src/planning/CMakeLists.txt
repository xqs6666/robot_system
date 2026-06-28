cmake_minimum_required(VERSION 3.0.2)
project(planning)

add_compile_options(-std=c++17)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  geometry_msgs
  nav_msgs
  tf
  msgs
)

catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS roscpp geometry_msgs nav_msgs tf msgs
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

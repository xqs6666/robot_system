cmake_minimum_required(VERSION 3.0.2)
project(robot_navigation)

add_compile_options(-std=c++17)

find_package(catkin REQUIRED COMPONENTS
  amcl
  geometry_msgs
  gmapping
  map_server
  move_base
  nav_msgs
  roscpp
  rospy
  sensor_msgs
  std_msgs
  tf
)

catkin_package(
  INCLUDE_DIRS include
  CATKIN_DEPENDS amcl geometry_msgs gmapping map_server move_base nav_msgs roscpp rospy sensor_msgs std_msgs tf
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

# === 以下根据实际节点添加 ===
# add_executable(${PROJECT_NAME}_node src/robot_navigation_node.cpp)
# target_link_libraries(${PROJECT_NAME}_node ${catkin_LIBRARIES})
# add_dependencies(${PROJECT_NAME}_node ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

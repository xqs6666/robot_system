# 任务/目标消息
Header header

# 目标点
geometry_msgs/Point goal_position
float64 goal_yaw

# 任务ID
uint32 mission_id

# 任务类型
uint8 TYPE_PARKING    = 0
uint8 TYPE_NAVIGATION = 1
uint8 TYPE_STOP       = 2
uint8 mission_type

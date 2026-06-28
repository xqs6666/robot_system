# 障碍物消息
uint32 id

# 类型
uint8 UNKNOWN   = 0
uint8 CAR       = 1
uint8 PEDESTRIAN = 2
uint8 CYCLIST   = 3
uint8 TRUCK     = 4
uint8 BUS       = 5
uint8 OTHER     = 6

uint8 type

# 位置与尺寸
geometry_msgs/Point position
# 长宽高
geometry_msgs/Vector3 dimensions

# 朝向
float64 yaw

# 速度
geometry_msgs/Vector3 velocity

# 置信度
float32 confidence

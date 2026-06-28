# 自动驾驶系统功能模块划分设计文档（V1.0）

## 1. 项目概述

本项目基于 ROS1 构建自动驾驶系统，以激光雷达为核心传感器，实现定位、建图、环境感知、路径规划和车辆控制等核心能力。

系统采用模块化设计思想，参考 Apollo 与 Autoware 的架构分层，并结合单人开发场景进行适当简化，保证系统具备良好的扩展性、维护性和工程落地能力。

当前规划支持：

* Livox 激光雷达
* Innovusion 激光雷达
* IMU
* RTK/GNSS
* 相机
* FAST-LIO2
* 点云建图
* 障碍物检测
* 自动驾驶规划控制

---

# 2. 系统总体架构

系统核心数据流如下：

```text
激光雷达
    │
    ▼
FAST-LIO2
    │
    ▼
车辆定位

激光雷达/相机
    │
    ▼
环境感知

定位 + 地图 + 障碍物
    │
    ▼
路径规划
    │
    ▼
轨迹生成
    │
    ▼
车辆控制
    │
    ▼
车辆执行
```

系统各模块之间通过 ROS Topic、TF 和自定义消息进行通信。

---

# 3. 软件架构

```text
src
├── common
├── msgs

├── drivers

├── localization

├── mapping

├── perception

├── planning

├── control

└── bringup
```

各模块均为独立一级功能模块，彼此平级，通过标准接口进行数据交互。

---

# 4. 功能模块划分

## 4.1 Drivers（驱动层）

### 职责

负责硬件设备接入与原始数据采集。

### 主要内容

* Livox Driver
* Innovusion Driver
* IMU Driver
* RTK Driver
* Camera Driver
* Chassis Driver

### 输出

* 点云数据
* IMU数据
* GNSS数据
* 图像数据
* 底盘状态数据

---

## 4.2 Localization（定位层）

### 职责

实现车辆实时位姿估计。

### 主要内容

* FAST-LIO2
* RTK融合
* 位姿管理

### 功能

融合激光雷达、IMU和RTK数据，计算车辆在地图中的位置与姿态。

### 输入

* 点云数据
* IMU数据
* RTK数据

### 输出

* Vehicle Pose
* Odometry
* TF坐标关系

---

## 4.3 Mapping（地图层）

### 职责

负责环境地图构建与管理。

### 主要内容

* 在线建图
* 离线建图
* 地图保存
* 地图加载

### 功能

利用定位结果和点云数据生成环境地图。

### 输入

* 点云数据
* Vehicle Pose

### 输出

* PointCloud Map

---

## 4.4 Perception（感知层）

### 职责

负责环境目标检测与障碍物感知。

### 主要内容

* 地面分割
* 点云聚类
* 障碍物检测
* 目标跟踪
* 多传感器融合

### 功能

从点云和图像中提取环境目标信息，为规划模块提供环境语义信息。

### 输入

* 点云数据
* 图像数据
* Vehicle Pose

### 输出

* Obstacle List
* Object List
* Tracking Result

---

## 4.5 Planning（规划层）

### 职责

根据地图、定位和障碍物信息生成可执行轨迹。

### 主要内容

* 全局路径规划
* 局部路径规划
* 行为决策

### 功能

计算车辆从当前位置到目标位置的可行驶路径。

### 输入

* Vehicle Pose
* Map
* Obstacle List
* Goal Point

### 输出

* Path
* Trajectory

---

## 4.6 Control（控制层）

### 职责

负责车辆运动控制。

### 主要内容

* 轨迹跟踪
* 横向控制
* 纵向控制

### 功能

根据规划生成的轨迹控制车辆行驶。

### 输入

* Trajectory
* Vehicle State

### 输出

* Steering Command
* Velocity Command
* Brake Command

---

## 4.7 Common（公共模块）

### 职责

提供公共基础能力。

### 主要内容

* 工具函数
* 数学计算
* 几何计算
* 配置管理
* 日志管理

---

## 4.8 Msgs（消息定义）

### 职责

统一系统消息格式。

### 主要内容

* Localization.msg
* VehicleState.msg
* Obstacle.msg
* ObstacleArray.msg
* Trajectory.msg
* Mission.msg

---

## 4.9 Bringup（启动管理）

### 职责

统一系统启动与运行管理。

### 主要内容

* 传感器启动
* 定位启动
* 建图启动
* 感知启动
* 规划启动
* 控制启动

### 功能

实现系统一键启动。

---

# 5. 模块关系

## 5.1 工程组织关系

```text
src
├── common
├── msgs
├── drivers
├── localization
├── mapping
├── perception
├── planning
├── control
└── bringup
```

说明：

* Localization、Mapping、Perception、Planning、Control 均为平级模块。
* 不存在模块包含关系。
* 各模块通过 ROS 接口通信。

---

## 5.2 运行时依赖关系

```text
Drivers
│
├──────────────► Localization
│                    │
│                    ▼
│                Vehicle Pose
│
├──────────────► Mapping
│                    ▲
│                    │
│              Vehicle Pose
│
└──────────────► Perception
                     │
                     ▼
                 Obstacles

Localization
      │
      ├─────────────► Mapping
      │
      └─────────────► Planning

Mapping
      │
      └─────────────► Planning

Perception
      │
      └─────────────► Planning

Planning
      │
      ▼

Control
      │
      ▼

Vehicle
```

说明：

* Mapping依赖Localization提供位姿信息完成建图。
* Perception依赖传感器数据完成环境感知。
* Planning同时依赖Localization、Mapping和Perception。
* Control负责执行Planning生成的轨迹。
* 各模块在代码层面保持独立，在运行时通过消息进行协作。

---

# 6. TF设计

系统采用标准ROS坐标树：

```text
map
│
odom
│
base_link
├── livox_link
├── innovusion_link
├── imu_link
├── gps_link
└── camera_link
```

## 静态TF

负责模块：

```text
robot_description
```

内容：

* base_link → livox_link
* base_link → innovusion_link
* base_link → imu_link
* base_link → gps_link
* base_link → camera_link

## 动态TF

负责模块：

```text
localization
```

内容：

* map → odom
* odom → base_link

---

# 7. 开发路线

## 第一阶段

```text
Drivers
↓
Localization
↓
Mapping
```

目标：

* 激光雷达接入
* FAST-LIO2运行
* 点云建图

---

## 第二阶段

```text
Perception
```

目标：

* 地面分割
* 点云聚类
* 障碍物检测
* 目标跟踪

---

## 第三阶段

```text
Planning
↓
Control
```

目标：

* 路径规划
* 轨迹生成
* 轨迹跟踪

---

## 第四阶段

```text
Localization
+
Perception
+
Planning
+
Control
```

目标：

完成自动驾驶全链路闭环验证。

---

# 8. 设计原则

* 按职责划分模块
* 模块高内聚、低耦合
* 统一消息接口
* 支持算法替换
* 支持多传感器扩展
* 支持自主导航与自动驾驶功能扩展
* 适合单人开发并兼顾后续团队协作

本架构作为项目基础版本，后续根据业务需求逐步扩展高级感知、决策与自动驾驶能力。

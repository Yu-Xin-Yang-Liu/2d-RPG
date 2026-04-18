# 状态机系统 (State Machine)

## 概述

状态机是一种用于管理实体状态转换的设计模式。本系统实现了基于节点的状态机，支持状态的进入、退出逻辑以及状态间的平滑转换。

## 核心组件

### 1. 状态机管理器 (StateMachine)

**文件**: `state_machine/state_machine.gd`

负责管理所有状态的注册和切换。

| 属性/方法 | 说明 |
|---------|------|
| `signal state_changed(from, to)` | 状态变化信号 |
| `@export initial_state` | 初始状态 |
| `current_state` | 当前状态 |
| `states` | 状态字典 |
| `transition_to(state_name)` | 切换到指定状态 |
| `get_current_state_name()` | 获取当前状态名 |

### 2. 状态基类 (StateBase)

**文件**: `state_machine/state_base.gd`

所有具体状态的基类。

| 方法 | 说明 |
|------|------|
| `enter()` | 进入状态时调用 |
| `exit()` | 退出状态时调用 |
| `update(delta)` | 每帧更新逻辑 |
| `physics_update(delta)` | 每帧更新物理逻辑 |

## 具体状态

### 1. 待机状态 (IdleState)

**文件**: `states/idle_state.gd`

生物停止移动，等待时机。

| 转换条件 | 目标状态 |
|---------|---------|
| 饱食度 < 20% | SeekFood |
| 能量 < 30% | Rest |
| 随机触发 (2%) | Wander |

### 2. 漫游状态 (WanderState)

**文件**: `states/wander_state.gd`

生物在区域内随机移动。

| 转换条件 | 目标状态 |
|---------|---------|
| 到达目标位置 | Idle |
| 饱食度 < 20% | SeekFood |
| 生命值 <= 0 | Dead |

### 3. 觅食状态 (SeekFoodState)

**文件**: `states/seek_food_state.gd`

寻找并吃掉食物。

| 转换条件 | 目标状态 |
|---------|---------|
| 吃到食物 | Idle |
| 饱食度 >= 60% | Idle |
| 生命值 <= 0 | Dead |

### 4. 逃跑状态 (FleeState)

**文件**: `states/flee_state.gd`

逃离威胁（捕食者）。

| 转换条件 | 目标状态 |
|---------|---------|
| 威胁消失或超出范围 | Idle |
| 生命值 <= 0 | Dead |

### 5. 休息状态 (RestState)

**文件**: `states/rest_state.gd`

停止移动，恢复能量。

| 转换条件 | 目标状态 |
|---------|---------|
| 能量 >= 60% | Idle |
| 饱食度 < 20% | SeekFood |
| 生命值 <= 0 | Dead |

### 6. 死亡状态 (DeadState)

**文件**: `states/dead_state.gd`

生物死亡，3秒后移除节点。

| 行为 |
|------|
| 停止移动 |
| 变暗显示 |
| 添加到 "dead" 组 |
| 3秒后自动移除 |

## 状态转换图

```
                    ┌─────────────────────────────────────┐
                    │                                     │
                    ▼                                     │
              ┌─────────┐     死亡 <= 0               ┌──────┐
    ┌────────▶│  Dead   │◀───────────────────────────│      │
    │         └─────────┘                            │      │
    │                                               │      │
    │                                               ▼      │
    │              ┌────────┐    饱食度 < 20%    ┌────────┐
    │         ┌───▶│  Idle  │─────────────────▶│SeekFood│
    │         │    └────────┘                   └────────┘
    │         │         ▲                           │
    │         │         │ 能量 < 30%                │
    │         │         │                           │
    │         │         └───────────────────────────┤
    │         │                                    │
    │         │         随机 (2%)                    │
    │         │    ┌────────┐                      │
    │         └───▶│ Wander │──────────────────────┘
    │              └────────┘
    │
    │              ┌────────┐
    └─────────────│  Rest  │◀─── 能量 < 30%
                   └────────┘

    逃跑状态 (FleeState) 独立转换:
    - 威胁消失 → Idle
    - 威胁超出范围 → Idle
```

## 使用方式

### 1. 在场景中配置

在 Creature 场景中添加 StateMachine 节点：

```
Creature (CharacterBody2D)
├── StateMachine
│   ├── IdleState
│   ├── WanderState
│   ├── SeekFoodState
│   ├── FleeState
│   ├── RestState
│   └── DeadState
└── ...
```

### 2. 代码切换状态

```gdscript
# 获取状态机
var state_machine = $StateMachine

# 切换到指定状态
state_machine.transition_to("Wander")

# 获取当前状态名
var current = state_machine.get_current_state_name()
```

### 3. 监听状态变化

```gdscript
# 连接信号
$StateMachine.state_changed.connect(_on_state_changed)

func _on_state_changed(from: String, to: String) -> void:
    print("状态变化: ", from, " -> ", to)
```

## 状态机 vs 行为树

| 特性 | 状态机 | 行为树 |
|------|--------|--------|
| 复杂度 | 较低 | 较高 |
| 状态转换 | 显式定义 | 通过条件隐式判断 |
| 适用场景 | 状态明确、数量少 | 行为复杂、层次多 |
| 调试 | 直观 | 需要理解树结构 |

## 组合使用建议

- **纯状态机**: 适用于状态数量少、转换逻辑简单的生物
- **状态机 + 行为树**: 状态机管理主要状态，行为树管理复杂的行为决策

# 行为树系统 (Behavior Tree)

## 概述

行为树是一种用于控制 AI 决策的层次化数据结构。本系统实现了经典的行为树架构，包含以下节点类型：

## 节点类型

### 1. 行为节点基类 (BehaviorNode)

**文件**: `behavior_nodes/behavior_node.gd`

所有行为节点的基类，提供基本的状态定义和通用方法。

| 属性/方法 | 说明 |
|---------|------|
| `Status enum` | SUCCESS(成功), FAILURE(失败), RUNNING(运行中) |
| `_status` | 当前执行状态 |
| `execute(delta)` | 执行行为，返回状态 |
| `_get_creature()` | 获取关联的生物节点 |

### 2. 组合节点基类 (CompositeNode)

**文件**: `behavior_nodes/composite_node.gd`

包含子节点的容器，继承自 BehaviorNode。

| 方法 | 说明 |
|------|------|
| `add_child_node(child)` | 添加子节点 |
| `get_child_nodes()` | 获取所有子节点 |

### 3. 选择器节点 (Selector)

**文件**: `behavior_nodes/selector.gd`

从左到右依次尝试子节点，返回第一个成功的结果（类似"或"操作）。

```
Selector
├── 子节点1 (SUCCESS) → 返回 SUCCESS
├── 子节点2 (FAILURE) → 继续下一个
├── 子节点3 (RUNNING) → 返回 RUNNING
└── 全部FAILURE → 返回 FAILURE
```

### 4. 序列节点 (Sequence)

**文件**: `behavior_nodes/sequence.gd`

从左到右依次执行所有子节点，所有子节点都成功才返回成功（类似"与"操作）。

```
Sequence
├── 子节点1 (FAILURE) → 返回 FAILURE
├── 子节点2 (SUCCESS) → 继续下一个
├── 子节点3 (RUNNING) → 返回 RUNNING
└── 全部SUCCESS → 返回 SUCCESS
```

### 5. 条件节点 (Conditions)

#### 检查饥饿 (CheckHungry)

**文件**: `behavior_nodes/conditions/check_hungry.gd`

检查生物饱食度是否低于阈值（30%）。

| 返回值 | 条件 |
|--------|------|
| SUCCESS | 饱食度 < 30% |
| FAILURE | 饱食度 >= 30% |

#### 检查威胁 (CheckThreat)

**文件**: `behavior_nodes/conditions/check_threat.gd`

检查感知范围内是否存在捕食者。

| 返回值 | 条件 |
|--------|------|
| SUCCESS | 捕食者在感知范围50%内 |
| FAILURE | 未发现威胁 |

### 6. 动作节点 (Actions)

#### 待机动作 (IdleAction)

**文件**: `behavior_nodes/actions/idle_action.gd`

使生物停止移动。

#### 漫游动作 (WanderAction)

**文件**: `behavior_nodes/actions/wander_action.gd`

使生物在区域内随机移动。

#### 觅食动作 (SeekFoodAction)

**文件**: `behavior_nodes/actions/seek_food_action.gd`

寻找并吃掉食物。

#### 逃跑动作 (FleeAction)

**文件**: `behavior_nodes/actions/flee_action.gd`

远离威胁（捕食者）。

## 行为树结构

```
BehaviorTree (根节点)
└── Selector (选择器)
    ├── Sequence: 逃跑优先级最高
    │   ├── CheckThreat (条件)
    │   └── FleeAction (动作)
    │
    ├── Sequence: 觅食
    │   ├── CheckHungry (条件)
    │   └── SeekFoodAction (动作)
    │
    ├── Sequence: 漫游
    │   └── WanderAction (动作)
    │
    └── IdleAction (待机)
```

## 使用方式

```gdscript
# 在 Creature 节点中添加 BehaviorTree
var behavior_tree: BehaviorTree = BehaviorTree.new()
add_child(behavior_tree)

# 行为树会在每帧自动执行
```

## 执行流程

1. `_physics_process` 每帧调用 `root.execute(delta)`
2. Selector 从左到右依次检查子节点
3. 子节点执行并返回状态
4. 根据状态决定是否继续执行后续节点

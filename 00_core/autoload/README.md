# 信号总线系统

## 概述

信号总线（SignalBus）是一个全局单例，用于管理游戏中的所有信号，实现不同系统之间的通信。

## 功能

- **生物相关信号**：出生、死亡、繁殖、进食、受伤
- **生态系统相关信号**：平衡变化、种群数量变化、资源变化
- **游戏状态相关信号**：开始、暂停、继续、结束
- **UI相关信号**：更新、通知消息
- **环境相关信号**：环境变化、天气变化

## 使用方法

### 1. 发送信号

```gdscript
# 触发生物出生信号
SignalBus.emit_creature_born(creature)

# 触发生物死亡信号
SignalBus.emit_creature_died(creature)

# 触发UI更新信号
SignalBus.emit_ui_updated("health_bar", {"value": 50, "max": 100})

# 触发通知消息
SignalBus.emit_notification_shown("生物已经死亡", 3.0)
```

### 2. 接收信号

```gdscript
# 在_ready()函数中连接信号
func _ready() -> void:
	# 连接生物死亡信号
	SignalBus.creature_died.connect(_on_creature_died)
	
	# 连接生态系统平衡变化信号
	SignalBus.ecosystem_balance_changed.connect(_on_balance_changed)

# 处理生物死亡信号
func _on_creature_died(creature: Node) -> void:
	print("生物死亡: " + creature.name)
	# 处理死亡逻辑

# 处理生态系统平衡变化信号
func _on_balance_changed(balance_value: float) -> void:
	print("生态平衡值: " + str(balance_value))
	# 处理平衡变化逻辑
```

## 信号列表

### 生物相关
- `creature_born(creature)` - 生物出生
- `creature_died(creature)` - 生物死亡
- `creature_reproduced(parent1, parent2)` - 生物繁殖
- `creature_ate(creature, food_amount)` - 生物进食
- `creature_hurt(creature, damage_amount)` - 生物受伤

### 生态系统相关
- `ecosystem_balance_changed(balance_value)` - 生态系统平衡变化
- `population_changed(species_name, count)` - 种群数量变化
- `resource_changed(resource_type, amount)` - 资源变化

### 游戏状态相关
- `game_started()` - 游戏开始
- `game_paused()` - 游戏暂停
- `game_resumed()` - 游戏继续
- `game_ended()` - 游戏结束

### UI相关
- `ui_updated(ui_element, data)` - UI更新
- `notification_shown(message, duration)` - 通知消息

### 环境相关
- `environment_changed(environment_type, value)` - 环境变化
- `weather_changed(weather_type)` - 天气变化

## 优势

1. **集中管理**：所有信号都集中在一个地方，便于管理和维护
2. **解耦**：不同系统之间通过信号通信，减少直接依赖
3. **可扩展性**：可以轻松添加新的信号类型
4. **全局访问**：作为自动加载单例，可以在任何脚本中直接访问

## 扩展建议

1. 根据游戏需求添加更多信号类型
2. 在关键系统中使用信号进行通信
3. 为信号添加适当的参数，确保信息传递完整

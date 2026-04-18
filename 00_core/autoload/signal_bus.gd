class_name SignalBus
extends Node

# 信号总线：管理全局信号的单例

# ============ 生物相关信号 ============

# 生物出生信号
# 参数: creature - 出生的生物节点
signal creature_born

# 生物死亡信号
# 参数: creature - 死亡的生物节点
signal creature_died

# 生物繁殖信号
# 参数: parent1, parent2 - 父母生物节点
signal creature_reproduced

# 生物进食信号
# 参数: creature - 进食的生物节点, food_amount - 食物量
signal creature_ate

# 生物受到伤害信号
# 参数: creature - 受伤的生物节点, damage_amount - 伤害量
signal creature_hurt

# ============ 生态系统相关信号 ============

# 生态系统平衡变化信号
# 参数: balance_value - 平衡值
signal ecosystem_balance_changed

# 种群数量变化信号
# 参数: species_name - 物种名称, count - 数量
signal population_changed

# 资源变化信号
# 参数: resource_type - 资源类型, amount - 数量
signal resource_changed

# ============ 游戏状态相关信号 ============

# 游戏开始信号
signal game_started

# 游戏暂停信号
signal game_paused

# 游戏继续信号
signal game_resumed

# 游戏结束信号
signal game_ended

# ============ UI相关信号 ============

# UI更新信号
# 参数: ui_element - UI元素名称, data - 更新数据
signal ui_updated

# 通知消息信号
# 参数: message - 通知消息, duration - 显示时长
signal notification_shown

# ============ 环境相关信号 ============

# 环境变化信号
# 参数: environment_type - 环境类型, value - 变化值
signal environment_changed

# 天气变化信号
# 参数: weather_type - 天气类型
signal weather_changed

# ============ 工具方法 ============

# 触发生物出生信号
func emit_creature_born(creature: Node) -> void:
	self.creature_born.emit(creature)

# 触发生物死亡信号
func emit_creature_died(creature: Node) -> void:
	self.creature_died.emit(creature)

# 触发生物繁殖信号
func emit_creature_reproduced(parent1: Node, parent2: Node) -> void:
	self.creature_reproduced.emit(parent1, parent2)

# 触发生物进食信号
func emit_creature_ate(creature: Node, food_amount: float) -> void:
	self.creature_ate.emit(creature, food_amount)

# 触发生物受伤信号
func emit_creature_hurt(creature: Node, damage_amount: float) -> void:
	self.creature_hurt.emit(creature, damage_amount)

# 触发生态系统平衡变化信号
func emit_ecosystem_balance_changed(balance_value: float) -> void:
	self.ecosystem_balance_changed.emit(balance_value)

# 触发种群数量变化信号
func emit_population_changed(species_name: String, count: int) -> void:
	self.population_changed.emit(species_name, count)

# 触发资源变化信号
func emit_resource_changed(resource_type: String, amount: float) -> void:
	self.resource_changed.emit(resource_type, amount)

# 触发游戏开始信号
func emit_game_started() -> void:
	self.game_started.emit()

# 触发游戏暂停信号
func emit_game_paused() -> void:
	self.game_paused.emit()

# 触发游戏继续信号
func emit_game_resumed() -> void:
	self.game_resumed.emit()

# 触发游戏结束信号
func emit_game_ended() -> void:
	self.game_ended.emit()

# 触发UI更新信号
func emit_ui_updated(ui_element: String, data: Variant) -> void:
	self.ui_updated.emit(ui_element, data)

# 触发通知消息信号
func emit_notification_shown(message: String, duration: float = 2.0) -> void:
	self.notification_shown.emit(message, duration)

# 触发环境变化信号
func emit_environment_changed(environment_type: String, value: float) -> void:
	self.environment_changed.emit(environment_type, value)

# 触发天气变化信号
func emit_weather_changed(weather_type: String) -> void:
	self.weather_changed.emit(weather_type)

class_name SpiritualComponent
extends Node

# 精神能力组件：处理生物的精神相关逻辑

#region 精神相关属性

# 灵力值
@export var spiritual_energy: float = 100.0

# 最大灵力值
@export var max_spiritual_energy: float = 100.0

# 精神强度
@export var spiritual_strength: float = 50.0

# 附身能力
@export var possession_ability: float = 0.0

# 无形状态
@export var can_become_intangible: bool = true

# 无形状态
var is_intangible: bool = false

# 附身目标
var possessed_target: Node = null

# 精神感知范围
@export var spiritual_perception_range: float = 200.0

# 灵力恢复速率
@export var spiritual_energy_regen_rate: float = 1.0

# 精神技能
var spiritual_skills: Array = []

# 拥有者
var controller: BioBase

#endregion

#region 生命周期

# 初始化
func _ready() -> void:
	# 获取拥有者
	controller = get_parent() as BioBase

# 物理进程
func _physics_process(delta: float) -> void:
	# 恢复灵力
	_regen_spiritual_energy(delta)
	
	# 维持附身状态
	_maintain_possession(delta)

#endregion

#region 灵力方法

# 恢复灵力
func _regen_spiritual_energy(delta: float) -> void:
	spiritual_energy = min(spiritual_energy + spiritual_energy_regen_rate * delta, max_spiritual_energy)

# 消耗灵力
# amount: 消耗值
func consume_spiritual_energy(amount: float) -> bool:
	if spiritual_energy >= amount:
		spiritual_energy -= amount
		return true
	return false

# 恢复灵力
# amount: 恢复值
func restore_spiritual_energy(amount: float) -> void:
	spiritual_energy = min(spiritual_energy + amount, max_spiritual_energy)

# 获取灵力百分比
func get_spiritual_energy_percent() -> float:
	if max_spiritual_energy <= 0:
		return 0.0
	return spiritual_energy / max_spiritual_energy

#endregion

#region 附身方法

# 尝试附身
# target: 目标生物
func possess(target: BioBase) -> bool:
	if not can_possess(target):
		return false
	
	# 消耗灵力
	if not consume_spiritual_energy(50.0):
		return false
	
	possessed_target = target
	_on_possession_started(target)
	return true

# 释放附身
func release_possession() -> void:
	_release_possession()

# 维持附身状态
func _maintain_possession(delta: float) -> void:
	if not possessed_target:
		return
	
	# 持续消耗灵力
	if not consume_spiritual_energy(5.0 * delta):
		_release_possession()

# 释放附身（内部方法）
func _release_possession() -> void:
	if possessed_target:
		_on_possession_ended(possessed_target)
		possessed_target = null

# 检查是否可以附身
# target: 目标生物
func can_possess(target: BioBase) -> bool:
	if not target or not target.is_alive():
		return false
	if possession_ability <= 0:
		return false
	if possessed_target:
		return false
	
	# 检查目标的精神抗性
	var target_spiritual_resistance = 0.0
	if target.has("spiritual_resistance"):
		target_spiritual_resistance = target.spiritual_resistance
	return spiritual_strength > target_spiritual_resistance

# 附身开始回调
func _on_possession_started(target: BioBase) -> void:
	# 子类可以重写此方法
	if controller and controller.has_method("_on_possession_started"):
		controller._on_possession_started(target)

# 附身结束回调
func _on_possession_ended(target: BioBase) -> void:
	# 子类可以重写此方法
	if controller and controller.has_method("_on_possession_ended"):
		controller._on_possession_ended(target)

#endregion

#region 无形状态方法

# 切换无形状态
func toggle_intangible() -> bool:
	if not can_become_intangible:
		return false
	
	is_intangible = not is_intangible
	if is_intangible:
		# 消耗灵力
		if not consume_spiritual_energy(20.0):
			is_intangible = false
			return false
		_on_became_intangible()
	else:
		_on_became_tangible()
	
	return true

# 变为无形回调
func _on_became_intangible() -> void:
	# 子类可以重写此方法
	if controller and controller.has_method("_on_became_intangible"):
		controller._on_became_intangible()

# 变为有形回调
func _on_became_tangible() -> void:
	# 子类可以重写此方法
	if controller and controller.has_method("_on_became_tangible"):
		controller._on_became_tangible()

#endregion

#region 精神技能方法

# 学习精神技能
# skill: 技能名称
func learn_spiritual_skill(skill: String) -> void:
	if skill not in spiritual_skills:
		spiritual_skills.append(skill)

# 使用精神技能
# skill: 技能名称
# target: 目标
func use_spiritual_skill(skill: String, target: Node = null) -> bool:
	if skill not in spiritual_skills:
		return false
	
	# 子类可以重写此方法
	return false

#endregion

#region 状态检查方法

# 是否正在附身
func is_possessing() -> bool:
	return possessed_target != null

# 是否处于无形状态
func is_in_intangible_state() -> bool:
	return is_intangible

# 是否灵力不足
func is_low_spiritual_energy() -> bool:
	return get_spiritual_energy_percent() < 0.3

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	return {
		"spiritual_energy": spiritual_energy,
		"max_spiritual_energy": max_spiritual_energy,
		"spiritual_strength": spiritual_strength,
		"possession_ability": possession_ability,
		"can_become_intangible": can_become_intangible,
		"is_intangible": is_intangible,
		"spiritual_perception_range": spiritual_perception_range,
		"spiritual_energy_regen_rate": spiritual_energy_regen_rate,
		"spiritual_skills": spiritual_skills
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	spiritual_energy = data.get("spiritual_energy", 100.0)
	max_spiritual_energy = data.get("max_spiritual_energy", 100.0)
	spiritual_strength = data.get("spiritual_strength", 50.0)
	possession_ability = data.get("possession_ability", 0.0)
	can_become_intangible = data.get("can_become_intangible", true)
	is_intangible = data.get("is_intangible", false)
	spiritual_perception_range = data.get("spiritual_perception_range", 200.0)
	spiritual_energy_regen_rate = data.get("spiritual_energy_regen_rate", 1.0)
	spiritual_skills = data.get("spiritual_skills", [])

#endregion

#region 调试方法

# 打印精神能力信息
func print_info() -> void:
	print("SpiritualComponent Info:")
	print("  Spiritual Energy: " + str(spiritual_energy) + "/" + str(max_spiritual_energy))
	print("  Spiritual Strength: " + str(spiritual_strength))
	print("  Possession Ability: " + str(possession_ability))
	print("  Is Intangible: " + str(is_intangible))
	print("  Is Possessing: " + str(is_possessing()))
	print("  Spiritual Skills: " + str(spiritual_skills))

#endregion

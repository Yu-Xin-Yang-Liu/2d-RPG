class_name SpiritEntity
extends BioBase

# 精神实体基类：所有精神类生物的父类
# 继承自 BioBase，扩展精神相关功能

#region 精神实体特有属性

# 是否自动挂载精神组件
@export var auto_mount_spiritual: bool = true

# 精神强度
@export var spiritual_strength: float = 50.0

# 附身能力
@export var possession_ability: float = 0.0

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "SpiritEntity"
	
	# 设置AI等级
	ai_level = 2 # 精神实体具有智慧
	
	# 添加精神实体相关特质
	add_trait("spiritual_form", "gift", {"description": "精神形态"})
	add_trait("can_become_intangible", "gift", {"description": "可以变为无形"})
	add_trait("spiritual_perception", "gift", {"description": "精神感知"})
	
	# 自动挂载精神组件
	if auto_mount_spiritual:
		_mount_spiritual_component()

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 精神实体死亡处理逻辑
	_release_possession()

#endregion

#region 精神组件管理

# 挂载精神组件
func _mount_spiritual_component() -> void:
	# 检查是否已经挂载
	if has_component("spiritual"):
		return
	
	# 使用组件管理器加载并创建精神组件
	var component_manager = ComponentManager.get_instance()
	var spiritual_component = component_manager.create_component("spiritual")
	if spiritual_component:
		mount_component("spiritual", spiritual_component)
		# 设置精神属性
		spiritual_component.spiritual_strength = spiritual_strength
		spiritual_component.possession_ability = possession_ability

# 获取精神组件
func _get_spiritual_component() -> SpiritualComponent:
	return get_component("spiritual") as SpiritualComponent

#endregion

#region 灵力方法

# 消耗灵力
# amount: 消耗值
func consume_spiritual_energy(amount: float) -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.consume_spiritual_energy(amount)
	return false

# 恢复灵力
# amount: 恢复值
func restore_spiritual_energy(amount: float) -> void:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		spiritual_component.restore_spiritual_energy(amount)

# 获取灵力百分比
func get_spiritual_energy_percent() -> float:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.get_spiritual_energy_percent()
	return 0.0

#endregion

#region 附身方法

# 尝试附身
# target: 目标生物
func possess(target: BioBase) -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.possess(target)
	return false

# 释放附身
func release_possession() -> void:
	_release_possession()

# 内部释放附身方法
func _release_possession() -> void:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		spiritual_component.release_possession()

# 检查是否可以附身
# target: 目标生物
func can_possess(target: BioBase) -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.can_possess(target)
	return false

# 附身开始回调
func _on_possession_started(target: BioBase) -> void:
	# 子类可以重写此方法
	pass

# 附身结束回调
func _on_possession_ended(target: BioBase) -> void:
	# 子类可以重写此方法
	pass

#endregion

#region 无形状态方法

# 切换无形状态
func toggle_intangible() -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.toggle_intangible()
	return false

# 变为无形回调
func _on_became_intangible() -> void:
	# 子类可以重写此方法
	pass

# 变为有形回调
func _on_became_tangible() -> void:
	# 子类可以重写此方法
	pass

#endregion

#region 精神感知方法

# 精神感知
func spiritually_perceive() -> Array[BioBase]:
	# 子类可以重写此方法
	return []

# 检测附近的生物
func detect_nearby_bios() -> Array[BioBase]:
	return spiritually_perceive()

#endregion

#region 精神技能方法

# 学习精神技能
# skill: 技能名称
func learn_spiritual_skill(skill: String) -> void:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		spiritual_component.learn_spiritual_skill(skill)

# 使用精神技能
# skill: 技能名称
# target: 目标
func use_spiritual_skill(skill: String, target: Node = null) -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.use_spiritual_skill(skill, target)
	return false

#endregion

#region 状态检查方法

# 是否正在附身
func is_possessing() -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.is_possessing()
	return false

# 是否处于无形状态
func is_in_intangible_state() -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.is_in_intangible_state()
	return false

# 是否灵力不足
func is_low_spiritual_energy() -> bool:
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		return spiritual_component.is_low_spiritual_energy()
	return true

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["auto_mount_spiritual"] = auto_mount_spiritual
	data["spiritual_strength"] = spiritual_strength
	data["possession_ability"] = possession_ability
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	auto_mount_spiritual = data.get("auto_mount_spiritual", true)
	spiritual_strength = data.get("spiritual_strength", 50.0)
	possession_ability = data.get("possession_ability", 0.0)

#endregion

#region 调试方法

# 打印精神实体信息
func print_info() -> void:
	super.print_info()
	print("  Spiritual Strength: " + str(spiritual_strength))
	print("  Possession Ability: " + str(possession_ability))
	print("  Is Intangible: " + str(is_in_intangible_state()))
	print("  Is Possessing: " + str(is_possessing()))
	
	# 打印精神组件信息
	var spiritual_component = _get_spiritual_component()
	if spiritual_component:
		spiritual_component.print_info()

#endregion
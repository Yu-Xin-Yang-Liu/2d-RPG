class_name BioBase
extends Node

# 生物基础接口：所有生物的最小接口基类
# 适用于：细菌、植物、哺乳动物、鸟类、微生物等

#region 通用属性
# 生物唯一标识符
var id: String = str(randi())
# 生物类型
@export var bio_type: String = "Unknown"

# 生命值
@export var health: float = 100.0

# 最大生命值
@export var max_health: float = 100.0

# 年龄（秒）
var age: float = 0.0

# 生命周期状态
var life_state: String = "alive" # alive, dying, dead

# 能量值（用于活动）
var energy: float = 100.0

# 最大能量值
var max_energy: float = 100.0

# 位置信息
var position: Vector2 = Vector2.ZERO

# 大小
var size: Vector2 = Vector2(1.0, 1.0)

# AI 等级
@export var ai_level: int = 0 # 0: 本能AI, 1: 灵性AI, 2: 智慧AI, 3: 超凡AI

# 特质系统
var trait_system: TraitSystem

# 组件字典：键为组件名称，值为组件节点
var components: Dictionary = {}
#endregion

# ============ 生命周期方法 ============
#region 生命周期方法
# 初始化
func _ready() -> void:
	# 初始化生物
	initialize()

# 初始化方法
func initialize() -> void:
	# 初始化特质系统
	trait_system = TraitSystem.new()
	add_child(trait_system)
	trait_system.initialize()
	
	# 初始化组件字典
	components.clear()
	
	# 子类可以重写此方法进行初始化
	pass

# 物理进程
func _physics_process(delta: float) -> void:
	# 更新年龄
	age += delta
	# 更新状态
	update_state(delta)
	# 检查生命周期
	check_lifecycle()

# 更新状态
func update_state(delta: float) -> void:
	# 子类可以重写此方法更新状态
	pass

# 检查生命周期
func check_lifecycle() -> void:
	# 检查生命值
	if health <= 0:
		life_state = "dead"
		on_death()

# 死亡处理
func on_death() -> void:
	# 子类可以重写此方法处理死亡逻辑
	pass
#endregion

# ============ 通用方法 ============
#region 通用方法
# 获取生物类型
func get_bio_type() -> String:
	return bio_type

# 获取当前生命值
func get_health() -> float:
	return health

# 获取生命值百分比
func get_health_percent() -> float:
	if max_health <= 0:
		return 0.0
	return health / max_health

# 获取年龄
func get_age() -> float:
	return age

# 获取生命周期状态
func get_life_state() -> String:
	return life_state

# 获取能量值
func get_energy() -> float:
	return energy

# 获取能量百分比
func get_energy_percent() -> float:
	if max_energy <= 0:
		return 0.0
	return energy / max_energy
#endregion

# ============ 交互方法 ============
#region 交互方法
# 受到伤害
# amount: 伤害值
func take_damage(amount: float) -> void:
	health = max(health - amount, 0.0)

# 恢复生命值
# amount: 恢复值
func heal(amount: float) -> void:
	health = min(health + amount, max_health)

# 消耗能量
# amount: 消耗值
func consume_energy(amount: float) -> bool:
	if energy >= amount:
		energy -= amount
		return true
	return false

# 恢复能量
# amount: 恢复值
func restore_energy(amount: float) -> void:
	energy = min(energy + amount, max_energy)
#endregion

# ============ 状态检查方法 ============
#region 状态检查方法
# 是否存活
func is_alive() -> bool:
	return life_state == "alive"

# 是否死亡
func is_dead() -> bool:
	return life_state == "dead"

# 是否受伤
func is_hurt() -> bool:
	return health < max_health

# 是否能量不足
func is_low_energy() -> bool:
	return get_energy_percent() < 0.3

# ============ 繁殖相关 ============

# 检查是否可以繁殖
func can_reproduce() -> bool:
	# 子类可以重写此方法
	return is_alive() and get_energy_percent() > 0.8

# 繁殖
func reproduce() -> BioBase:
	# 子类可以重写此方法
	return null
#endregion

# ============ 移动相关（如果适用） ============
#region 移动相关（如果适用）
# 移动到指定位置
# target_position: 目标位置
# speed: 移动速度
func move_to(target_position: Vector2, speed: float) -> void:
	# 子类可以重写此方法
	pass

# 获取当前位置
func get_position() -> Vector2:
	return position

# 设置位置
func set_position(new_position: Vector2) -> void:
	position = new_position

# ============ 感知相关（如果适用） ============

# 感知周围环境
func perceive_environment() -> void:
	# 子类可以重写此方法
	pass

# 检测附近的生物
func detect_nearby_bios() -> Array[BioBase]:
	# 子类可以重写此方法
	return []

# ============ 资源相关 ============

# 获取资源需求
func get_resource_requirements() -> Dictionary:
	# 子类可以重写此方法
	return {}

# 消耗资源
func consume_resources(resources: Dictionary) -> bool:
	# 子类可以重写此方法
	return false

# 产生资源
func produce_resources() -> Dictionary:
	# 子类可以重写此方法
	return {}
#endregion

# ============ 序列化方法 ============
#region 序列化方法
# 序列化方法
# 序列化为字典
func to_dict() -> Dictionary:
	return {
		"id": id,
		"bio_type": bio_type,
		"health": health,
		"max_health": max_health,
		"age": age,
		"life_state": life_state,
		"energy": energy,
		"max_energy": max_energy,
		"position": position,
		"size": size,
		"ai_level": ai_level,
		"traits": trait_system.to_dict() if trait_system else {}
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	id = data.get("id", str(randi()))
	bio_type = data.get("bio_type", "Unknown")
	health = data.get("health", 100.0)
	max_health = data.get("max_health", 100.0)
	age = data.get("age", 0.0)
	life_state = data.get("life_state", "alive")
	energy = data.get("energy", 100.0)
	max_energy = data.get("max_energy", 100.0)
	position = data.get("position", Vector2.ZERO)
	size = data.get("size", Vector2(1.0, 1.0))
	ai_level = data.get("ai_level", 0)
	
	if trait_system:
		var traits_data = data.get("traits", {})
		trait_system.from_dict(traits_data)
#endregion

# ============ 组件管理方法 ============
#region 组件管理方法
# 挂载组件
# component_name: 组件名称
# component: 组件节点
func mount_component(component_name: String, component: Node) -> bool:
	if component_name in components:
		return false
	
	add_child(component)
	components[component_name] = component
	return true

# 卸载组件
# component_name: 组件名称
func unmount_component(component_name: String) -> bool:
	if component_name not in components:
		return false
	
	var component = components[component_name]
	if component:
		component.queue_free()
	components.erase(component_name)
	return true

# 获取组件
# component_name: 组件名称
func get_component(component_name: String) -> Node:
	return components.get(component_name, null)

# 检查是否有组件
# component_name: 组件名称
func has_component(component_name: String) -> bool:
	return component_name in components

# 获取所有组件
func get_all_components() -> Array:
#endregion
	return components.values()

# ============ 特质管理方法 ============
#region 特质管理方法
# 添加特质
# trait_name: 特质名称
# trait_type: 特质类型
# data: 特质数据
func add_trait(trait_name: String, trait_type: String, data: Dictionary = {}) -> void:
	if trait_system:
		trait_system.add_trait(trait_name, trait_type, data)

# 移除特质
# trait_name: 特质名称
func remove_trait(trait_name: String) -> bool:
	if trait_system:
		return trait_system.remove_trait(trait_name)
	return false

# 检查是否有特质
# trait_name: 特质名称
func has_trait(trait_name: String) -> bool:
	if trait_system:
		return trait_system.has_trait(trait_name)
	return false

# 获取特质
# trait_name: 特质名称
func get_trait(trait_name: String) -> Dictionary:
	if trait_system:
		return trait_system.get_trait(trait_name)
	return {}
#endregion

# ============ 状态检查方法扩展 ============

#region 状态检查方法扩展
# 是否可以移动
func can_move() -> bool:
	return not has_trait("cannot_move")

# 是否可以感知
func can_perceive() -> bool:
	return not has_trait("no_senses")

# 是否可以说话
func can_speak() -> bool:
	return not has_trait("cannot_speak") and ai_level >= 2

# 是否有自主意识
func has_consciousness() -> bool:
	return not has_trait("no_consciousness") and ai_level >= 1

# 是否有情绪
func has_emotions() -> bool:
	return not has_trait("no_emotions") and ai_level >= 1
#endregion

# ============ 调试方法 ============

# 打印生物信息
func print_info() -> void:
	print("BioBase Info:")
	print("  ID: " + id)
	print("  Type: " + bio_type)
	print("  Health: " + str(health) + "/" + str(max_health))
	print("  Age: " + str(age) + "s")
	print("  Life State: " + life_state)
	print("  Energy: " + str(energy) + "/" + str(max_energy))
	print("  Position: " + str(position))
	print("  Size: " + str(size))
	print("  AI Level: " + str(ai_level))
	
	# 打印特质信息
	if trait_system:
		trait_system.print_traits()
	
	# 打印组件信息
	print("  Components: " + str(components.keys()))

# ============ 静态方法 ============

# 创建生物实例
static func create_bio(bio_type: String) -> BioBase:
	# 子类可以扩展此方法创建特定类型的生物
	var bio = BioBase.new()
	bio.bio_type = bio_type
	return bio

# 比较两个生物的优先级
static func compare_priority(bio1: BioBase, bio2: BioBase) -> int:
	# 子类可以重写此方法
	return 0

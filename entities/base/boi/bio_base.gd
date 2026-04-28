class_name BioBase
extends Node2D

# 生物基础接口：所有生物的最小接口基类
# 适用于：细菌、植物、哺乳动物、鸟类、微生物等

#region 通用属性
# 生物唯一标识符
var id: String = str(randi())
# 生物类型
@export var bio_type: String = "Unknown"

# 生命值
@export var current_health: float = 100.0

# 最大生命值
@export var max_health: float = 100.0

# 年龄（秒）
var age: float = 0.0

# 生命周期状态
var life_state: String = "alive" # alive, dying, dead

# 能量值（用于活动）
var current_energy: float = 100.0

# 最大能量值
var max_energy: float = 100.0

# 大小
var size: Vector2 = Vector2(1.0, 1.0)

@export var max_satiety = 90.0
@export var current_satiety = 90.0

# AI 等级
@export var ai_level: int = 0 # 0: 本能AI, 1: 灵性AI, 2: 智慧AI, 3: 超凡AI
#endregion
# 核心系统（改为节点式获取，非手动new）
# 特质系统
var trait_system: TraitSystem
# 组件字典：键为组件名称，值为组件节点
var components: Dictionary = {}
# 行为树和状态机引用
var behavior_tree: BehaviorTree
var state_machine: StateMachine


# ============ 生命周期方法 ============
#region 生命周期方法
# 初始化
func _ready() -> void:
	_fetch_core_components()
	# 初始化生物
	_auto_register_components()
	# 初始化生物逻辑
	initialize()

# 初始化方法
func initialize() -> void:
	pass
	

# 自动注册子节点组件（无需手动mount）
func _auto_register_components() -> void:
	components.clear()
	for child in get_children():
		if child:
			components[child.name] = child

# 统一获取核心组件
func _fetch_core_components() -> void:
	state_machine = get_node_or_null("StateMachine")
	trait_system = get_node_or_null("TraitSystem")
	# 绑定行为树宿主为生物节点
	behavior_tree = get_node_or_null("BehaviorTree")
	if behavior_tree:
		behavior_tree.bio_base = self
	
# 物理进程
func _physics_process(delta: float) -> void:
	if is_dead():
		return
	# 更新年龄
	age += delta
	# 更新状态
	update_state(delta)
	# 检查生命周期
	check_lifecycle()
	
	if is_instance_valid(state_machine):
		state_machine._physics_process(delta)
	elif is_instance_valid(behavior_tree):
		behavior_tree.execute(delta)

	# # 执行状态机（状态机会管理行为树的执行）
	# if state_machine:
	# 	state_machine._physics_process(delta)
	# else:
	# 	# 如果没有状态机，直接执行行为树
	# 	if behavior_tree:
	# 		behavior_tree.execute(delta)

# 更新状态
func update_state(_delta: float) -> void:
	# 子类可以重写此方法更新状态
	pass

# 检查生命周期
func check_lifecycle() -> void:
	# 检查生命值
	if current_health <= 0:
		life_state = "dead"
		on_death()

# 死亡处理
func on_death() -> void:
	# 子类可以重写此方法处理死亡逻辑
	#stop_all_actions()
	pass
#endregion

#region 安全获取组件（核心：解决满屏if判空）
func get_component_safe(component_name: String) -> Node:
	return components.get(component_name) or get_node_or_null(component_name)

func has_component_safe(component_name: String) -> bool:
	return is_instance_valid(get_component_safe(component_name))
	
func get_all_components() -> Array:
	return components.values()
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

#endregion
	
# ============ 行为树和状态机管理 ============

#region 行为树和状态机管理
# 获取行为树
func get_behavior_tree() -> BehaviorTree:
	return behavior_tree

# 获取状态机
func get_state_machine() -> StateMachine:
	return state_machine

# 设置行为树
func set_behavior_tree(new_behavior_tree: BehaviorTree) -> void:
	behavior_tree = new_behavior_tree
	if behavior_tree:
		behavior_tree.bio_base = self

# 设置状态机
func set_state_machine(new_state_machine: StateMachine) -> void:
	state_machine = new_state_machine

# 创建行为树节点
# node_name: 节点名称
# 返回: 节点实例，如果创建失败返回null
func create_behavior_node(node_name: String) -> Node:
	var component_manager = ComponentManager.get_instance()
	return component_manager.create_behavior_node(node_name)
#endregion


# ============ 通用方法 ============
#region 通用方法
# 获取生物类型
func get_bio_type() -> String:
	return bio_type

# 获取当前生命值
func get_current_health() -> float:
	return current_health

# 获取生命值百分比
func get_current_health_percent() -> float:
	if max_health <= 0:
		return 0.0
	return current_health / max_health

# 获取年龄
func get_age() -> float:
	return age

# 获取生命周期状态
func get_life_state() -> String:
	return life_state

# 获取能量值
func get_current_energy() -> float:
	return current_energy

# 获取能量百分比
func get_energy_percent() -> float:
	if max_energy <= 0:
		return 0.0
	return current_energy / max_energy
#endregion

# ============ 交互方法 ============
#region 交互方法
# 受到伤害
# amount: 伤害值
func take_damage(amount: float) -> void:
	current_health = max(current_health - amount, 0.0)

# 恢复生命值
# amount: 恢复值
func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)

# 消耗能量
# amount: 消耗值
func consume_energy(amount: float) -> bool:
	if current_energy >= amount:
		current_energy -= amount
		return true
	return false

# 恢复能量
# amount: 恢复值
func restore_energy(amount: float) -> void:
	current_energy = min(current_energy + amount, max_energy)
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
	return current_health < max_health

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

# ============ 位置相关 ============
#region 位置相关
# 获取当前位置
#func get_position() -> Vector2:
	#return self.position

# 设置位置
#func set_position(new_position: Vector2) -> void:
	#self.position = new_position

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
func consume_resources(_resources: Dictionary) -> bool:
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
		"current_health": current_health,
		"max_health": max_health,
		"age": age,
		"life_state": life_state,
		"current_energy": current_energy,
		"max_energy": max_energy,
		"size": size,
		"ai_level": ai_level,
		"traits": trait_system.to_dict() if trait_system else {}
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	id = data.get("id", str(randi()))
	bio_type = data.get("bio_type", "Unknown")
	current_health = data.get("current_health", 100.0)
	max_health = data.get("max_health", 100.0)
	age = data.get("age", 0.0)
	life_state = data.get("life_state", "alive")
	current_energy = data.get("current_energy", 100.0)
	max_energy = data.get("max_energy", 100.0)
	size = data.get("size", Vector2(1.0, 1.0))
	ai_level = data.get("ai_level", 0)
	
	if trait_system:
		var traits_data = data.get("traits", {})
		trait_system.from_dict(traits_data)
#endregion


# ============ 特质管理方法 ============
#region 特质管理方法
# 添加特质
# trait_name: 特质名称
# trait_type: 特质类型
# data: 特质数据
func add_trait(trait_name: String, trait_type: String, data: Dictionary = {}) -> void:
	if is_instance_valid(trait_system):
		trait_system.add_trait(trait_name, trait_type, data)

func remove_trait(trait_name: String) -> bool:
	return is_instance_valid(trait_system) && trait_system.remove_trait(trait_name)

func has_trait(trait_name: String) -> bool:
	return is_instance_valid(trait_system) && trait_system.has_trait(trait_name)

# 获取特质
# trait_name: 特质名称
func get_trait(trait_name: String) -> Dictionary:
	if is_instance_valid(trait_system):
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
	print("  current_health: " + str(current_health) + "/" + str(max_health))
	print("  Age: " + str(age) + "s")
	print("  Life State: " + life_state)
	print("  Energy: " + str(current_energy) + "/" + str(max_energy))
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
static func compare_priority(_bio1: BioBase, _bio2: BioBase) -> int:
	# 子类可以重写此方法
	return 0

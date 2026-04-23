class_name StaticLife
extends BioBase

# 静态生物基类：所有静止的生物的父类
# 继承自 BioBase，扩展静态生物相关功能

#region 静态生物特有属性

# 是否自动挂载生长组件
@export var auto_mount_growth: bool = true

# 基础资源产出速率
@export var resource_production_rate: float = 0.1

# 资源存储
var resource_storage: Dictionary = {}

# 环境需求
var environmental_requirements: Dictionary = {
	"light": 50,
	"water": 50,
	"nutrients": 50
}

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "StaticLife"
	
	# 添加静态生物相关特质
	add_trait("cannot_move", "shackle", {"description": "无法移动"})
	add_trait("resource_production", "gift", {"description": "资源生产"})
	
	# 自动挂载生长组件
	if auto_mount_growth:
		_mount_growth_component()

# 更新状态
func update_state(delta: float) -> void:
	super.update_state(delta)
	
	# 生产资源
	_produce_resources(delta)

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 静态生物死亡处理逻辑
	resource_storage.clear()

#endregion

#region 生长组件管理

# 挂载生长组件
func _mount_growth_component() -> void:
	# 检查是否已经挂载
	if has_component("growth"):
		return
	
	# 加载并创建生长组件
	var growth_script = load("res://systems/ai/components/growth_component.gd")
	if growth_script:
		var growth_component = growth_script.new()
		mount_component("growth", growth_component)

# 获取生长组件
func _get_growth_component() -> GrowthComponent:
	return get_component("growth") as GrowthComponent

#endregion

#region 生长方法

# 推进生长阶段
func advance_growth_stage() -> void:
	var growth_component = _get_growth_component()
	if growth_component:
		growth_component.advance_growth_stage()

# 生长阶段推进回调
func _on_growth_stage_advanced() -> void:
	# 子类可以重写此方法
	pass

#endregion

#region 资源方法

# 生产资源
func _produce_resources(delta: float) -> void:
	if not is_alive():
		return
	
	# 获取生长阶段和环境适应度
	var growth_stage = 0
	var environmental_fitness = 1.0
	var growth_component = _get_growth_component()
	if growth_component:
		growth_stage = growth_component.get_growth_stage()
		environmental_fitness = growth_component.get_environmental_fitness()
	
	# 根据生长阶段和环境适应度调整生产速率
	var production_multiplier = (growth_stage + 1) * environmental_fitness
	var production_amount = resource_production_rate * production_multiplier * delta
	
	# 子类可以重写此方法实现具体资源生产
	_produce_specific_resources(production_amount)

# 生产特定资源
func _produce_specific_resources(amount: float) -> void:
	# 子类可以重写此方法
	pass

# 存储资源
# resource_type: 资源类型
# amount: 资源数量
func store_resource(resource_type: String, amount: float) -> void:
	if resource_type not in resource_storage:
		resource_storage[resource_type] = 0.0
	resource_storage[resource_type] += amount

# 消耗资源
# resource_type: 资源类型
# amount: 资源数量
func consume_resource(resource_type: String, amount: float) -> bool:
	if resource_type in resource_storage and resource_storage[resource_type] >= amount:
		resource_storage[resource_type] -= amount
		return true
	return false

# 获取资源存储
func get_resource_storage() -> Dictionary:
	return resource_storage

#endregion

#region 环境方法

# 设置环境需求
# requirements: 环境需求字典
func set_environmental_requirements(requirements: Dictionary) -> void:
	environmental_requirements = requirements

# 设置环境适应度
# fitness: 环境适应度值
func set_environmental_fitness(fitness: float) -> void:
	var growth_component = _get_growth_component()
	if growth_component:
		growth_component.set_environmental_fitness(fitness)

# 获取环境适应度
func get_environmental_fitness() -> float:
	var growth_component = _get_growth_component()
	if growth_component:
		return growth_component.get_environmental_fitness()
	return 1.0

#endregion

#region 状态检查方法

# 是否成熟
func is_mature() -> bool:
	var growth_component = _get_growth_component()
	if growth_component:
		return growth_component.is_mature()
	return false

# 是否衰老
func is_old() -> bool:
	var growth_component = _get_growth_component()
	if growth_component:
		return growth_component.is_old()
	return false

# 获取生长阶段
func get_growth_stage() -> int:
	var growth_component = _get_growth_component()
	if growth_component:
		return growth_component.get_growth_stage()
	return 0

# 获取生长百分比
func get_growth_percent() -> float:
	var growth_component = _get_growth_component()
	if growth_component:
		return growth_component.get_growth_percent()
	return 0.0

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["auto_mount_growth"] = auto_mount_growth
	data["resource_production_rate"] = resource_production_rate
	data["resource_storage"] = resource_storage
	data["environmental_requirements"] = environmental_requirements
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	auto_mount_growth = data.get("auto_mount_growth", true)
	resource_production_rate = data.get("resource_production_rate", 0.1)
	resource_storage = data.get("resource_storage", {})
	environmental_requirements = data.get("environmental_requirements", {"light": 50, "water": 50, "nutrients": 50})

#endregion

#region 调试方法

# 打印静态生物信息
func print_info() -> void:
	super.print_info()
	print("  Growth Stage: " + str(get_growth_stage()) + "/3")
	print("  Growth Percent: " + str(get_growth_percent() * 100) + "%")
	print("  Environmental Fitness: " + str(get_environmental_fitness()))
	print("  Resource Storage: " + str(resource_storage))
	
	# 打印生长组件信息
	var growth_component = _get_growth_component()
	if growth_component:
		growth_component.print_info()

#endregion

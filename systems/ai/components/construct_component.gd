class_name ConstructComponent
extends Node

# 构造体管理组件：处理构造体的耐久度、能量和模块管理

#region 构造体相关属性

# 构造材料
@export var construction_material: String = "Unknown"

# 耐久度
@export var durability: float = 100.0

# 最大耐久度
@export var max_durability: float = 100.0

# 能量源类型
@export var energy_source: String = "None"

# 能量存储
var energy_storage: float = 0.0

# 最大能量存储
@export var max_energy_storage: float = 100.0

# 能量消耗速率
@export var energy_consumption_rate: float = 1.0

# 维护需求
var maintenance_requirements: Dictionary = {}

# 功能模块
var functional_modules: Dictionary = {}

# 控制模式
@export var control_mode: String = "autonomous" # autonomous, remote, manual

# 拥有者
var controller: Node = null

# 组件拥有者
var component_controller: BioBase

#endregion

#region 生命周期

# 初始化
func _ready() -> void:
	# 获取组件拥有者
	component_controller = get_parent() as BioBase

# 物理进程
func _physics_process(delta: float) -> void:
	# 消耗能量
	_consume_energy(delta)
	
	# 维护耐久度
	_maintain_durability(delta)

#endregion

#region 能量方法

# 消耗能量
func _consume_energy(delta: float) -> void:
	if energy_storage <= 0:
		# 能量耗尽，开始损失耐久度
		durability = max(durability - 5.0 * delta, 0.0)
		if durability <= 0:
			if component_controller and component_controller.has_method("on_death"):
				component_controller.on_death()
		return
	
	energy_storage = max(energy_storage - energy_consumption_rate * delta, 0.0)

# 补充能量
# amount: 补充量
func recharge_energy(amount: float) -> void:
	energy_storage = min(energy_storage + amount, max_energy_storage)

# 获取能量存储百分比
func get_energy_storage_percent() -> float:
	if max_energy_storage <= 0:
		return 0.0
	return energy_storage / max_energy_storage

#endregion

#region 耐久度方法

# 维护耐久度
func _maintain_durability(delta: float) -> void:
	# 子类可以重写此方法
	pass

# 受到损伤
# amount: 损伤值
func take_damage(amount: float) -> void:
	durability = max(durability - amount, 0.0)
	if durability <= 0:
		if component_controller and component_controller.has_method("on_death"):
			component_controller.on_death()

# 修复
# amount: 修复量
func repair(amount: float) -> void:
	durability = min(durability + amount, max_durability)

# 获取耐久度百分比
func get_durability_percent() -> float:
	if max_durability <= 0:
		return 0.0
	return durability / max_durability

#endregion

#region 功能模块方法

# 安装功能模块
# module_name: 模块名称
# module: 模块节点
func install_module(module_name: String, module: Node) -> bool:
	if module_name in functional_modules:
		return false
	
	component_controller.add_child(module)
	functional_modules[module_name] = module
	_on_module_installed(module_name, module)
	return true

# 卸载功能模块
# module_name: 模块名称
func uninstall_module(module_name: String) -> bool:
	if module_name not in functional_modules:
		return false
	
	var module = functional_modules[module_name]
	if module:
		module.queue_free()
	functional_modules.erase(module_name)
	_on_module_uninstalled(module_name)
	return true

# 获取功能模块
# module_name: 模块名称
func get_module(module_name: String) -> Node:
	return functional_modules.get(module_name, null)

# 检查是否有功能模块
# module_name: 模块名称
func has_module(module_name: String) -> bool:
	return module_name in functional_modules

# 模块安装回调
func _on_module_installed(module_name: String, module: Node) -> void:
	# 子类可以重写此方法
	if component_controller and component_controller.has_method("_on_module_installed"):
		component_controller._on_module_installed(module_name, module)

# 模块卸载回调
func _on_module_uninstalled(module_name: String) -> void:
	# 子类可以重写此方法
	if component_controller and component_controller.has_method("_on_module_uninstalled"):
		component_controller._on_module_uninstalled(module_name)

#endregion

#region 控制方法

# 设置控制模式
# mode: 控制模式
func set_control_mode(mode: String) -> void:
	control_mode = mode
	_on_control_mode_changed(mode)

# 控制模式变更回调
func _on_control_mode_changed(mode: String) -> void:
	# 子类可以重写此方法
	if component_controller and component_controller.has_method("_on_control_mode_changed"):
		component_controller._on_control_mode_changed(mode)

# 设置所有者
# new_controller: 新所有者
func set_controller(new_controller: Node) -> void:
	controller = new_controller

# 获取所有者
func get_controller() -> Node:
	return controller

#endregion

#region 维护方法

# 执行维护
# resources: 维护资源
func perform_maintenance(resources: Dictionary) -> bool:
	# 子类可以重写此方法
	return false

# 获取维护需求
func get_maintenance_requirements() -> Dictionary:
	return maintenance_requirements

#endregion

#region 状态检查方法

# 是否能量不足
func is_low_energy() -> bool:
	return get_energy_storage_percent() < 0.2

# 是否需要维护
func needs_maintenance() -> bool:
	return get_durability_percent() < 0.3

# 是否功能正常
func is_functional() -> bool:
	return durability > 0 and energy_storage > 0

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	return {
		"construction_material": construction_material,
		"durability": durability,
		"max_durability": max_durability,
		"energy_source": energy_source,
		"energy_storage": energy_storage,
		"max_energy_storage": max_energy_storage,
		"energy_consumption_rate": energy_consumption_rate,
		"maintenance_requirements": maintenance_requirements,
		"control_mode": control_mode
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	construction_material = data.get("construction_material", "Unknown")
	durability = data.get("durability", 100.0)
	max_durability = data.get("max_durability", 100.0)
	energy_source = data.get("energy_source", "None")
	energy_storage = data.get("energy_storage", 0.0)
	max_energy_storage = data.get("max_energy_storage", 100.0)
	energy_consumption_rate = data.get("energy_consumption_rate", 1.0)
	maintenance_requirements = data.get("maintenance_requirements", {})
	control_mode = data.get("control_mode", "autonomous")

#endregion

#region 调试方法

# 打印构造体信息
func print_info() -> void:
	print("ConstructComponent Info:")
	print("  Construction Material: " + construction_material)
	print("  Durability: " + str(durability) + "/" + str(max_durability))
	print("  Energy Storage: " + str(energy_storage) + "/" + str(max_energy_storage))
	print("  Energy Source: " + energy_source)
	print("  Control Mode: " + control_mode)
	print("  Functional Modules: " + str(functional_modules.keys()))

#endregion

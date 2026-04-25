class_name ConstructEntity
extends BioBase

# 构造体实体基类：所有人工构造的实体的父类
# 继承自 BioBase，扩展构造体相关功能

#region 构造体特有属性

# 是否自动挂载构造体组件
@export var auto_mount_construct: bool = true

# 构造材料
@export var construction_material: String = "Unknown"

# 能量源类型
@export var energy_source: String = "None"

# 控制模式
@export var control_mode: String = "autonomous" # autonomous, remote, manual

# 所有者
var controller: Node = null

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "ConstructEntity"
	
	# 设置AI等级
	ai_level = 1 # 构造体具有基础AI
	
	# 添加构造体相关特质
	add_trait("constructed", "shackle", {"description": "人工构造"})
	add_trait("energy_dependent", "shackle", {"description": "依赖能量"})
	add_trait("durability_system", "gift", {"description": "耐久度系统"})
	
	# 自动挂载构造体组件
	if auto_mount_construct:
		_mount_construct_component()

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 构造体死亡处理逻辑
	controller = null

#endregion

#region 构造体组件管理

# 挂载构造体组件
func _mount_construct_component() -> void:
	# 检查是否已经挂载
	if has_component("construct"):
		return
	
	# 使用组件管理器加载并创建构造体组件
	var component_manager = ComponentManager.get_instance()
	var construct_component = component_manager.create_component("construct")
	if construct_component:
		mount_component("construct", construct_component)
		# 设置构造体属性
		construct_component.construction_material = construction_material
		construct_component.energy_source = energy_source
		construct_component.control_mode = control_mode

# 获取构造体组件
func _get_construct_component() -> ConstructComponent:
	return get_component("construct") as ConstructComponent

#endregion

#region 能量方法

# 补充能量
# amount: 补充量
func recharge_energy(amount: float) -> void:
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.recharge_energy(amount)

# 获取能量存储百分比
func get_energy_storage_percent() -> float:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.get_energy_storage_percent()
	return 0.0

#endregion

#region 耐久度方法

# 受到损伤
# amount: 损伤值
func take_damage(amount: float) -> void:
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.take_damage(amount)

# 修复
# amount: 修复量
func repair(amount: float) -> void:
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.repair(amount)

# 获取耐久度百分比
func get_durability_percent() -> float:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.get_durability_percent()
	return 0.0

#endregion

#region 功能模块方法

# 安装功能模块
# module_name: 模块名称
# module: 模块节点
func install_module(module_name: String, module: Node) -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.install_module(module_name, module)
	return false

# 卸载功能模块
# module_name: 模块名称
func uninstall_module(module_name: String) -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.uninstall_module(module_name)
	return false

# 获取功能模块
# module_name: 模块名称
func get_module(module_name: String) -> Node:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.get_module(module_name)
	return null

# 检查是否有功能模块
# module_name: 模块名称
func has_module(module_name: String) -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.has_module(module_name)
	return false

# 模块安装回调
func _on_module_installed(module_name: String, module: Node) -> void:
	# 子类可以重写此方法
	pass

# 模块卸载回调
func _on_module_uninstalled(module_name: String) -> void:
	# 子类可以重写此方法
	pass

#endregion

#region 控制方法

# 设置控制模式
# mode: 控制模式
func set_control_mode(mode: String) -> void:
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.set_control_mode(mode)

# 控制模式变更回调
func _on_control_mode_changed(mode: String) -> void:
	# 子类可以重写此方法
	pass

# 设置所有者
# new_controller: 新所有者
func set_controller(new_controller: Node) -> void:
	controller = new_controller
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.set_controller(new_controller)

# 获取所有者
func get_controller() -> Node:
	return controller

#endregion

#region 维护方法

# 执行维护
# resources: 维护资源
func perform_maintenance(resources: Dictionary) -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.perform_maintenance(resources)
	return false

# 获取维护需求
func get_maintenance_requirements() -> Dictionary:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.get_maintenance_requirements()
	return {}

#endregion

#region 状态检查方法

# 是否能量不足
func is_low_energy() -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.is_low_energy()
	return true

# 是否需要维护
func needs_maintenance() -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.needs_maintenance()
	return true

# 是否功能正常
func is_functional() -> bool:
	var construct_component = _get_construct_component()
	if construct_component:
		return construct_component.is_functional()
	return false

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["auto_mount_construct"] = auto_mount_construct
	data["construction_material"] = construction_material
	data["energy_source"] = energy_source
	data["control_mode"] = control_mode
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	auto_mount_construct = data.get("auto_mount_construct", true)
	construction_material = data.get("construction_material", "Unknown")
	energy_source = data.get("energy_source", "None")
	control_mode = data.get("control_mode", "autonomous")

#endregion

#region 调试方法

# 打印构造体信息
func print_info() -> void:
	super.print_info()
	print("  Construction Material: " + construction_material)
	print("  Energy Source: " + energy_source)
	print("  Control Mode: " + control_mode)
	
	# 打印构造体组件信息
	var construct_component = _get_construct_component()
	if construct_component:
		construct_component.print_info()

#endregion

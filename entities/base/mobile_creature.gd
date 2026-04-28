class_name MobileCreature
extends BioBase

# 移动生物基类：所有可以移动的生物的父类
# 继承自 BioBase
# 是否自动挂载移动组件
@export var auto_mount_movement: bool = true
# 缓存移动组件，避免重复查找
var _movement_component: MovementComponent = null

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "MobileCreature"
	
	# 添加移动相关特质
	add_trait("can_move", "gift", {"description": "可以移动"})
	
	# 延迟一帧挂载组件，避免生命周期错乱
	await get_tree().process_frame
	if auto_mount_movement:
		_mount_movement_component()
	# 缓存移动组件
	#_update_movement_cache()

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 移动生物死亡处理逻辑
	_stop_moving()

#endregion

#region 移动组件管理

# 挂载移动组件
func _mount_movement_component() -> void:
	# 检查是否已经挂载
	if has_component("movement"):
		return
	
	# 单例空值防护
	var component_manager = ComponentManager.get_instance()
	if not component_manager:
		push_warning("ComponentManager 未初始化")
		return
	var movement_component = component_manager.create_component("movement")
	if movement_component:
		mount_component("movement", movement_component)
		# 缓存组件
		_movement_component = movement_component

# 获取移动组件
func _get_movement_component() -> MovementComponent:
	if not is_instance_valid(_movement_component):
		_movement_component = get_component("movement") as MovementComponent
	return _movement_component

#endregion

#region 移动方法

# 设置移动方向
# direction: 移动方向向量
func set_move_direction(direction: Vector2) -> void:
	if not _get_movement_component():
		return
	_get_movement_component().set_move_direction(direction)

# 移动到目标位置
# target_position: 目标位置
# speed: 移动速度（可选）
func move_to(target_position: Vector2, speed: float = -1.0) -> void:
	if not _get_movement_component():
		return
	_get_movement_component().move_to(target_position, speed)

# 停止移动
func stop_moving() -> void:
	_stop_moving()

# 内部停止移动方法
func _stop_moving() -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.stop_moving()

# 向前移动
func move_forward(speed: float = -1.0) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_forward(speed)

# 向后移动
func move_backward(speed: float = -1.0) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_backward(speed)

# 向左移动
func move_left(speed: float = -1.0) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_left(speed)

# 向右移动
func move_right(speed: float = -1.0) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_right(speed)

#endregion

#region 状态检查方法

# 是否正在移动
func is_moving() -> bool:
	var movement_component = _get_movement_component()
	if movement_component:
		return movement_component.is_moving()
	return false

# 是否静止
func is_stationary() -> bool:
	var movement_component = _get_movement_component()
	if movement_component:
		return movement_component.is_stationary()
	return true

# 获取移动速度
func get_move_speed() -> float:
	var movement_component = _get_movement_component()
	if movement_component:
		return movement_component.get_move_speed()
	print("return 0.0")
	return 0.0

# 获取移动方向
func get_move_direction() -> Vector2:
	var movement_component = _get_movement_component()
	if movement_component:
		return movement_component.get_move_direction()
	return Vector2.ZERO

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["auto_mount_movement"] = auto_mount_movement
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	auto_mount_movement = data.get("auto_mount_movement", true)

#endregion

#region 调试方法

# 打印移动生物信息
func print_info() -> void:
	super.print_info()
	print("  Move Speed: " + str(get_move_speed()))
	print("  Is Moving: " + str(is_moving()))
	
	# 打印移动组件信息
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.print_info()

#endregion

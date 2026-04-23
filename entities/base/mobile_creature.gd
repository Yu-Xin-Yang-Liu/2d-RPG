class_name MobileCreature
extends BioBase

# 移动生物基类：所有可以移动的生物的父类
# 继承自 BioBase，提供移动能力

#region 移动相关属性

# 是否自动挂载移动组件
@export var auto_mount_movement: bool = true

# 移动速度
@export var move_speed: float = 100.0

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "MobileCreature"
	
	# 添加移动相关特质
	add_trait("can_move", "gift", {"description": "可以移动"})
	
	# 自动挂载移动组件
	if auto_mount_movement:
		_mount_movement_component()

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
	
	# 加载并创建移动组件
	var movement_script = load("res://systems/ai/components/movement_component.gd")
	if movement_script:
		var movement_component = movement_script.new()
		mount_component("movement", movement_component)
		# 设置移动速度
		if movement_component:
			movement_component.move_speed = move_speed

# 获取移动组件
func _get_movement_component() -> MovementComponent:
	return get_component("movement") as MovementComponent

#endregion

#region 移动方法

# 设置移动方向
# direction: 移动方向向量
func set_move_direction(direction: Vector2) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.set_move_direction(direction)

# 移动到目标位置
# target_position: 目标位置
# speed: 移动速度（可选）
func move_to(target_position: Vector2, speed: float = -1.0) -> void:
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_to(target_position, speed)

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
	data["move_speed"] = move_speed
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	auto_mount_movement = data.get("auto_mount_movement", true)
	move_speed = data.get("move_speed", 100.0)

#endregion

#region 调试方法

# 打印移动生物信息
func print_info() -> void:
	super.print_info()
	print("  Move Speed: " + str(move_speed))
	print("  Is Moving: " + str(is_moving()))
	
	# 打印移动组件信息
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.print_info()

#endregion

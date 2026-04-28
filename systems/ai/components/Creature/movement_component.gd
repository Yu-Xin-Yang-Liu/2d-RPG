class_name MovementComponent
extends Node

# 移动组件：处理生物的移动逻辑

#region 移动相关属性

# 移动速度
@export var move_speed: float = 100.0

# 最大移动速度
@export var max_move_speed: float = 150.0

# 加速度
@export var acceleration: float = 500.0

# 减速度
@export var deceleration: float = 300.0

# 转向速度（弧度/秒）
@export var turn_speed: float = 3.0

# 当前速度
var current_speed: float = 0.0

# 当前移动方向
var move_direction: Vector2 = Vector2.ZERO

# 目标移动方向
var target_direction: Vector2 = Vector2.ZERO

# 拥有者
#var controller
var character_body: CharacterBody2D
#endregion

#region 生命周期

# 初始化
func _ready() -> void:
	# 获取拥有者
	#controller = get_parent() as BioBase
	character_body = get_parent() as CharacterBody2D

# 物理进程
func _physics_process(delta: float) -> void:
	# 更新移动
	if not character_body or not character_body.has_method("move_and_slide"):
		return
	var bio = character_body
	if not bio or not bio.can_move() or bio.has_trait("frozen") or bio.has_trait("stunned"):
		current_speed = 0.0
		character_body.velocity = Vector2.ZERO
		return
	var target_speed = target_direction.length() * move_speed
	if current_speed < target_speed:
		current_speed = min(current_speed + acceleration * delta, target_speed)
	else:
		current_speed = max(current_speed - deceleration * delta, target_speed)
	if target_direction.length() > 0:
		move_direction = move_direction.lerp(target_direction.normalized(), turn_speed * delta)
	else:
		move_direction = Vector2.ZERO
	if current_speed > 0:
		character_body.velocity = move_direction * current_speed
	else:
		character_body.velocity = Vector2.ZERO
	character_body.move_and_slide()
	#_update_movement(delta)

#endregion

#region 移动方法

# 更新移动
#func _update_movement(delta: float) -> void:
	#if not controller or not controller.can_move():
		#current_speed = 0.0
		#return
	#
	## 计算目标速度
	#var target_speed = target_direction.length() * move_speed
	#
	## 加速或减速
	#if current_speed < target_speed:
		#current_speed = min(current_speed + acceleration * delta, target_speed)
	#else:
		#current_speed = max(current_speed - deceleration * delta, target_speed)
	#
	## 更新移动方向
	#if target_direction.length() > 0:
		#move_direction = move_direction.lerp(target_direction.normalized(), turn_speed * delta)
	#else:
		#move_direction = Vector2.ZERO
	#
	## 应用移动
	#if current_speed > 0:
		## 确保 controller 是 CharacterBody2D 或其子节点
		#var character_body = null
		#
		## 检查 controller 是否是 CharacterBody2D
		#if controller is CharacterBody2D:
			#character_body = controller
		## 检查 controller 的父节点是否是 CharacterBody2D
		#elif controller.get_parent() and controller.get_parent() is CharacterBody2D:
			#character_body = controller.get_parent()
		## 检查 controller 是否有移动方法
		#elif controller.has_method("set_velocity") and controller.has_method("move_and_slide"):
			#character_body = controller
#
		## 使用 CharacterBody2D 的移动方法
		#if character_body:
			#character_body.velocity = move_direction * current_speed
			#character_body.move_and_slide()


# 设置移动方向
# direction: 移动方向向量
func set_move_direction(direction: Vector2) -> void:
	target_direction = direction

# 移动到目标位置
# target_position: 目标位置
# speed: 移动速度（可选）
func move_to(target_position: Vector2, speed: float = -1.0) -> void:
	#var direction = (target_position - controller.position).normalized()
	var direction = (target_position - character_body.global_position).normalized()
	if speed > 0:
		move_speed = speed
	set_move_direction(direction)

# 停止移动
func stop_moving() -> void:
	target_direction = Vector2.ZERO
	current_speed = 0.0

# 向前移动
func move_forward(speed: float = -1.0) -> void:
	set_move_direction(Vector2.RIGHT)

# 向后移动
func move_backward(speed: float = -1.0) -> void:
	set_move_direction(Vector2.DOWN)

# 向左移动
func move_left(speed: float = -1.0) -> void:
	set_move_direction(Vector2.LEFT)

# 向右移动
func move_right(speed: float = -1.0) -> void:
	set_move_direction(Vector2.RIGHT)

#endregion

#region 状态检查方法

# 是否正在移动
func is_moving() -> bool:
	return current_speed > 0.1

# 是否静止
func is_stationary() -> bool:
	return current_speed <= 0.1

# 获取移动速度
func get_move_speed() -> float:
	return current_speed

# 获取移动方向
func get_move_direction() -> Vector2:
	return move_direction

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	return {
		"move_speed": move_speed,
		"max_move_speed": max_move_speed,
		"acceleration": acceleration,
		"deceleration": deceleration,
		"turn_speed": turn_speed,
		"current_speed": current_speed,
		"move_direction": move_direction,
		"target_direction": target_direction
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	move_speed = data.get("move_speed", 100.0)
	max_move_speed = data.get("max_move_speed", 150.0)
	acceleration = data.get("acceleration", 500.0)
	deceleration = data.get("deceleration", 300.0)
	turn_speed = data.get("turn_speed", 3.0)
	current_speed = data.get("current_speed", 0.0)
	move_direction = data.get("move_direction", Vector2.ZERO)
	target_direction = data.get("target_direction", Vector2.ZERO)

#endregion

#region 调试方法

# 打印移动信息
func print_info() -> void:
	print("MovementComponent Info:")
	print("  Move Speed: " + str(move_speed))
	print("  Current Speed: " + str(current_speed))
	print("  Move Direction: " + str(move_direction))
	print("  Is Moving: " + str(is_moving()))

#endregion

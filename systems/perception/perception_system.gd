class_name PerceptionSystem
extends Node2D

# 感知系统：管理生物的视觉、听觉和嗅觉检测

# ============ 导出属性 ============

# 视觉范围：生物能看到的最大距离
@export var vision_range: float = 150.0
# 视觉角度：视野的扇形角度（度数）
@export var vision_angle: float = 90.0

# 听觉范围：能听到声音的最大距离
@export var hearing_range: float = 100.0

# 嗅觉范围：能闻到气味的最大距离
@export var smell_range: float = 80.0

# 感知层遮罩：用于检测不同类型的对象
# 生物层：用于检测其他生物
@export var creature_layer: int = 1
# 食物层：用于检测食物
@export var food_layer: int = 2
# 危险层：用于检测危险对象
@export var danger_layer: int = 3

# ============ 节点引用 ============

# 视觉区域
var _vision_area: Area2D
# 听觉区域
var _hearing_area: Area2D
# 嗅觉区域
var _smell_area: Area2D

# ============ 感知列表 ============

# 感知到的附近生物
var nearby_creatures: Array[Creature] = []
# 感知到的附近食物
var nearby_food: Array[Node2D] = []
# 感知到的附近危险
var nearby_danger: Array[Node2D] = []

# ============ 生命周期 ============

func _ready() -> void:
	# 设置感知区域
	_setup_perception_areas()
	# 连接信号
	_connect_signals()

# 进程回调：每帧更新视觉旋转
func _process(delta: float) -> void:
	# 更新扇形视觉的旋转，使其跟随生物朝向
	_update_vision_rotation()

# 更新视觉旋转
func _update_vision_rotation() -> void:
	if _vision_area and _vision_area.get_child_count() > 0:
		var creature = get_parent() as Node2D
		if creature:
			_vision_area.rotation = creature.rotation

# ============ 私有方法：设置感知区域 ============

# 设置所有感知区域
func _setup_perception_areas() -> void:
	# 获取或创建视觉区域
	_vision_area = _get_or_create_area("Vision")
	_setup_vision_shape()
	
	# 获取或创建听觉区域
	_hearing_area = _get_or_create_area("Hearing")
	_setup_hearing_shape()
	
	# 获取或创建嗅觉区域
	_smell_area = _get_or_create_area("Smell")
	_setup_smell_shape()

# 获取或创建区域节点
# area_name: 区域名称
# 返回: Area2D节点
func _get_or_create_area(area_name: String) -> Area2D:
	var area = get_node_or_null(area_name) as Area2D
	if not area:
		area = Area2D.new()
		area.name = area_name
		add_child(area)
	return area

# 设置视觉区域形状（扇形）
func _setup_vision_shape() -> void:
	# 扇形视觉需要使用 CollisionPolygon2D
	var vision_collision = _vision_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if vision_collision:
		vision_collision.queue_free()
	
	# 创建扇形多边形
	var polygon = CollisionPolygon2D.new()
	polygon.name = "VisionPolygon"
	_vision_area.add_child(polygon)
	
	# 创建扇形多边形点
	var points = _create_sector_points(vision_range, deg_to_rad(vision_angle / 2.0))
	polygon.polygon = points
	
	# 设置检测层
	_vision_area.collision_mask = creature_layer | food_layer | danger_layer

# 设置听觉区域形状（圆形）
func _setup_hearing_shape() -> void:
	var hearing_collision = _hearing_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not hearing_collision:
		hearing_collision = CollisionShape2D.new()
		hearing_collision.name = "CollisionShape2D"
		_hearing_area.add_child(hearing_collision)
	
	# 圆形听觉
	var circle = CircleShape2D.new()
	circle.radius = hearing_range
	hearing_collision.shape = circle
	
	# 设置检测层
	_hearing_area.collision_mask = creature_layer | danger_layer

# 设置嗅觉区域形状（圆形）
func _setup_smell_shape() -> void:
	var smell_collision = _smell_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if not smell_collision:
		smell_collision = CollisionShape2D.new()
		smell_collision.name = "CollisionShape2D"
		_smell_area.add_child(smell_collision)
	
	# 圆形嗅觉
	var circle = CircleShape2D.new()
	circle.radius = smell_range
	smell_collision.shape = circle
	
	# 设置检测层
	_smell_area.collision_mask = food_layer

# 创建扇形多边形点
# radius: 扇形半径
# half_angle: 半角弧度
# 返回: 扇形多边形点数组
func _create_sector_points(radius: float, half_angle: float) -> PackedVector2Array:
	var points = PackedVector2Array()
	var center = Vector2.ZERO
	points.append(center)
	
	var num_segments = 32
	for i in range(num_segments + 1):
		var angle = -half_angle + (2.0 * half_angle * i / num_segments)
		var point = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)
	
	return points

# ============ 信号连接 ============

# 连接所有信号
func _connect_signals() -> void:
	# 视觉信号
	if _vision_area.body_entered:
		_vision_area.body_entered.connect(_on_vision_body_entered)
	if _vision_area.body_exited:
		_vision_area.body_exited.connect(_on_vision_body_exited)
	
	# 听觉信号
	if _hearing_area.body_entered:
		_hearing_area.body_entered.connect(_on_hearing_body_entered)
	if _hearing_area.body_exited:
		_hearing_area.body_exited.connect(_on_hearing_body_exited)
	
	# 嗅觉信号
	if _smell_area.body_entered:
		_smell_area.body_entered.connect(_on_smell_body_entered)
	if _smell_area.body_exited:
		_smell_area.body_exited.connect(_on_smell_body_exited)

# ============ 回调方法 ============

# 视觉区域进入回调
func _on_vision_body_entered(body: Node2D) -> void:
	_add_to_category(body, nearby_creatures, nearby_food, nearby_danger)

# 视觉区域离开回调
func _on_vision_body_exited(body: Node2D) -> void:
	_remove_from_category(body, nearby_creatures, nearby_food, nearby_danger)

# 听觉区域进入回调
func _on_hearing_body_entered(body: Node2D) -> void:
	if body is Creature:
		if not body in nearby_creatures:
			nearby_creatures.append(body)
	elif _is_danger(body):
		if not body in nearby_danger:
			nearby_danger.append(body)

# 听觉区域离开回调
func _on_hearing_body_exited(body: Node2D) -> void:
	_remove_from_category(body, nearby_creatures, [], nearby_danger)

# 嗅觉区域进入回调
func _on_smell_body_entered(body: Node2D) -> void:
	if _is_food(body):
		if not body in nearby_food:
			nearby_food.append(body)

# 嗅觉区域离开回调
func _on_smell_body_exited(body: Node2D) -> void:
	_remove_from_category(body, [], nearby_food, [])

# ============ 辅助方法 ============

# 添加对象到对应类别
func _add_to_category(body: Node2D, creatures: Array, food: Array, danger: Array) -> void:
	if body is Creature and body != get_parent():
		if not body in creatures:
			creatures.append(body)
	elif _is_food(body):
		if not body in food:
			food.append(body)
	elif _is_danger(body):
		if not body in danger:
			danger.append(body)

# 从对应类别移除对象
func _remove_from_category(body: Node2D, creatures: Array, food: Array, danger: Array) -> void:
	if body in creatures:
		creatures.erase(body)
	if body in food:
		food.erase(body)
	if body in danger:
		danger.erase(body)

# 判断是否为食物
# body: 待判断的节点
# 返回: 是否为食物
func _is_food(body: Node2D) -> bool:
	return body.is_in_group("food") or body.has_method("get_food_value")

# 判断是否为危险
# body: 待判断的节点
# 返回: 是否为危险
func _is_danger(body: Node2D) -> bool:
	return body.is_in_group("danger") or (body is Creature and body != get_parent())

# ============ 公共接口 ============

# 检查目标是否在视野范围内（考虑角度）
# target: 目标节点
# 返回: 是否在视野中
func is_in_vision(target: Node2D) -> bool:
	var creature = get_parent() as Node2D
	if not creature:
		return false
	
	var to_target = target.global_position - creature.global_position
	var distance = to_target.length()
	
	# 检查距离
	if distance > vision_range:
		return false
	
	# 检查角度
	var creature_direction = Vector2.RIGHT.rotated(creature.rotation)
	var angle = creature_direction.angle_to(to_target)
	return abs(angle) <= deg_to_rad(vision_angle / 2.0)

# 获取最近的食物
# 返回: 最近的的食物节点，如果没有则返回null
func get_nearest_food() -> Node2D:
	var nearest: Node2D = null
	var min_dist = INF
	
	for food in nearby_food:
		var dist = food.global_position.distance_to(get_parent().global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = food
	
	return nearest

# 获取最近的威胁
# 返回: 最近的威胁节点，如果没有则返回null
func get_nearest_threat() -> Node2D:
	var nearest: Node2D = null
	var min_dist = INF
	
	for threat in nearby_danger:
		var dist = threat.global_position.distance_to(get_parent().global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = threat
	
	return nearest

# 获取最近的生物
# 返回: 最近的生物节点，如果没有则返回null
func get_nearest_creature() -> Creature:
	var nearest: Creature = null
	var min_dist = INF
	
	for creature in nearby_creatures:
		var dist = creature.global_position.distance_to(get_parent().global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = creature
	
	return nearest

# 更新感知范围参数
# new_vision_range: 新的视觉范围
# new_vision_angle: 新的视觉角度
# new_hearing_range: 新的听觉范围
# new_smell_range: 新的嗅觉范围
func update_perception_ranges(new_vision_range: float, new_vision_angle: float, 
							   new_hearing_range: float, new_smell_range: float) -> void:
	vision_range = new_vision_range
	vision_angle = new_vision_angle
	hearing_range = new_hearing_range
	smell_range = new_smell_range
	
	# 重新设置形状
	_setup_vision_shape()
	_setup_hearing_shape()
	_setup_smell_shape()

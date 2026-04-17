class_name EcosystemManager
extends Node2D

# 生态系统管理器：管理整个生态系统中生物的生成、繁殖和状态

# ============ 导出属性 ============

# 初始生物数量：场景启动时生成的数量
@export var initial_creature_count: int = 20
# 生物场景：用于实例化生物的预制场景
@export var creature_scene: PackedScene = preload("res://creatures/creature_base.tscn")

# ============ 变量 ============

# 存储当前所有生物的数组
var creatures: Array[Node] = []
# 生态系统环境引用
var ecosystem_environment: EcosystemEnvironment

# 生物容器节点：用于存放所有生成的生物
@onready var creature_container: Node2D = $CreatureContainer

# ============ 生命周期 ============

func _ready() -> void:
	# 等待第一帧处理完成，确保场景完全加载
	await get_tree().process_frame
	# 获取环境节点
	ecosystem_environment = get_parent().get_node("Environment")
	# 生成初始生物
	_spawn_initial_creatures()

# 进程回调：每帧调用
func _process(delta: float) -> void:
	# 更新生物列表
	_update_creature_list()
	# 检查繁殖
	_check_reproduction()

# ============ 私有方法 ============

# 生成初始生物
func _spawn_initial_creatures() -> void:
	if creature_scene == null:
		return
	
	for i in range(initial_creature_count):
		_spawn_creature()

# 生成单个生物
func _spawn_creature() -> void:
	# 实例化生物
	var creature: Node = creature_scene.instantiate()
	# 获取随机生成位置
	var spawn_pos: Vector2 = _get_random_spawn_position()
	# 设置位置
	creature.position = spawn_pos
	# 添加到容器
	creature_container.add_child(creature)

# 获取随机生成位置
# 返回: 屏幕内的随机坐标
func _get_random_spawn_position() -> Vector2:
	# 获取视口大小
	var screen_size: Vector2 = get_viewport_rect().size
	# 在屏幕范围内随机生成，保留100像素的边距
	var x: float = randf_range(100, screen_size.x - 100)
	var y: float = randf_range(100, screen_size.y - 100)
	return Vector2(x, y)

# 更新生物列表：获取容器中所有生物
func _update_creature_list() -> void:
	creatures = creature_container.get_children()

# 检查是否可以繁殖
func _check_reproduction() -> void:
	for creature in creatures:
		# 检查生物是否可以繁殖
		if creature.has_method("can_reproduce") and creature.can_reproduce():
			# 随机概率判断是否繁殖
			if randf() < 0.001:
				_reproduce_creature(creature)

# 繁殖生物
# parent: 父体生物节点
func _reproduce_creature(parent: Node) -> void:
	# 实例化子代
	var offspring: Node = creature_scene.instantiate()
	# 设置位置在父体附近
	offspring.position = parent.position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	# 添加到容器
	creature_container.add_child(offspring)

# ============ 公共方法 ============

# 获取当前生物数量
# 返回: 生物总数
func get_creature_count() -> int:
	return creatures.size()

# 获取指定状态的所有生物
# state: 要查询的状态名称
# 返回: 满足条件的生物数组
func get_creatures_by_state(state: String) -> Array:
	var result: Array = []
	for creature in creatures:
		if creature.get_state_name() == state:
			result.append(creature)
	return result

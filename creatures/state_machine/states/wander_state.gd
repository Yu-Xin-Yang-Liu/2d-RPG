# 游荡状态：生物随机移动
class_name WanderState
extends StateBase

# 漫游目标位置
var target_position: Vector2
# 漫游半径
var wander_radius: float = 100.0
# 到达阈值
var reached_threshold: float = 10.0
# 上次选择目标的时间
var _last_pick_time: float = 0.0

func enter() -> void:
	# 选择新目标
	_pick_new_target()
	print("进入游荡状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	# 执行行为树处理行为（行为树会设置velocity）
	super._physics_process(delta)
	
	# 检查是否到达目标
	var creature = get_creature() as Creature
	if creature and creature.global_position.distance_to(target_position) < reached_threshold:
		_pick_new_target()
	
	# 检查状态转换
	_check_state_transitions()

# 选择新目标位置
func _pick_new_target() -> void:
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 在漫游半径内随机选择位置
	var random_offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	target_position = creature.global_position + random_offset

# 检查状态转换条件
func _check_state_transitions() -> void:
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 根据属性判断状态转换
	if creature.current_energy < 30:
		transition_to("RestState")
	elif creature.current_satiety < 40:
		transition_to("SeekFoodState")

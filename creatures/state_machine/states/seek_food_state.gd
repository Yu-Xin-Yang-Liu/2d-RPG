# 寻食状态：生物寻找食物
class_name SeekFoodState
extends StateBase

func enter() -> void:
	print("进入寻食状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	# 执行行为树处理行为（行为树会设置velocity）
	super._physics_process(delta)
	
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 检查是否有食物
	if creature.perception_system:
		var target_food = creature.perception_system.get_nearest_food()
		if not target_food:
			# 没有食物，转换到漫游状态
			transition_to("WanderState")
	
	# 检查状态转换
	_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 根据属性判断状态转换
	if creature.current_energy < 20:
		transition_to("RestState")
	elif creature.current_satiety >= 70:
		transition_to("WanderState")

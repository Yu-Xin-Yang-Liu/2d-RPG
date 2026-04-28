# 游荡状态：生物随机移动
class_name WanderState
extends StateBase

# 漫游半径
var wander_radius: float = 100.0
# 到达阈值
var reached_threshold: float = 10.0

func enter() -> void:
	print("进入游荡状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	# 执行行为树处理行为（行为树会设置velocity）
	super._physics_process(delta)
	
	# 检查状态转换
	_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var bio_base = get_creature()
	if not bio_base:
		return
	
	# 根据属性判断状态转换
	if bio_base.current_energy < 30:
		transition_to("RestState")
	elif bio_base.current_satiety < 40:
		transition_to("SeekFoodState")

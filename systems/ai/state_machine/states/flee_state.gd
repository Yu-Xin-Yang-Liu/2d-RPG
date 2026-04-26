# 逃跑状态：生物逃离威胁
class_name FleeState
extends StateBase

# 逃跑持续时间
var flee_duration: float = 0.0
# 最大逃跑时间
var max_flee_duration: float = 3.0

func enter() -> void:
	# 重置逃跑时间
	flee_duration = max_flee_duration
	print("进入逃跑状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	# 执行行为树处理行为（行为树会设置velocity）
	super._physics_process(delta)
	
	var bio_base = get_creature() as BioBase
	if not bio_base:
		return
	
	# 逃跑时间倒计时
	flee_duration -= delta
	
	# 逃跑时间结束，转换到漫游状态
	if flee_duration <= 0:
		transition_to("WanderState")
	
	# 检查状态转换
	_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var bio_base = get_creature() as BioBase
	if not bio_base:
		return
	
	# 根据属性判断状态转换
	if bio_base.current_energy < 20:
		transition_to("RestState")
	elif bio_base.health <= 0:
		transition_to("DeadState")

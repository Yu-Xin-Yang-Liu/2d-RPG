# 空闲状态：生物静止等待
class_name IdleState
extends StateBase

# 等待时间计时器
var wait_time: float = 0.0
# 最大等待时间
var max_wait_time: float = 2.0

func enter() -> void:
	# 随机设置等待时间
	wait_time = randf_range(0.5, max_wait_time)
	print("进入空闲状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	# 执行行为树处理行为
	super._physics_process(delta)
	
	# 倒计时
	wait_time -= delta
	
	# 等待结束后检查状态转换
	if wait_time <= 0:
		_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var bio_base = get_creature() as BioBase
	if not bio_base:
		return
	
	# 根据属性判断状态转换
	if bio_base.current_energy < 30:
		transition_to("RestState")
	elif bio_base.current_satiety < 40:
		transition_to("SeekFoodState")
	else:
		transition_to("WanderState")

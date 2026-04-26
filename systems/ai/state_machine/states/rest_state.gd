# 休息状态：生物恢复能量
class_name RestState
extends StateBase

# 休息持续时间
var rest_duration: float = 0.0
# 最大休息时间
var max_rest_duration: float = 5.0
# 能量恢复速度
var energy_recovery_rate: float = 10.0

func _ready() -> void:
	# 休息状态不需要行为树
	enable_behavior_tree = false

func enter() -> void:
	# 重置休息时间
	rest_duration = max_rest_duration
	print("进入休息状态")

# 物理进程：每帧调用
func _physics_process(delta: float) -> void:
	var bio_base = get_creature()
	if not bio_base:
		return
	
	# 休息时不移动，速度为零
	if bio_base.has_method("stop_moving"):
		bio_base.stop_moving()
	
	# 恢复能量
	bio_base.current_energy = min(bio_base.current_energy + energy_recovery_rate * delta, bio_base.max_energy)
	rest_duration -= delta
	
	# 休息结束条件
	if rest_duration <= 0 or bio_base.current_energy >= bio_base.max_energy * 0.8:
		transition_to("WanderState")
	
	# 检查状态转换
	_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var bio_base = get_creature()
	if not bio_base:
		return
	
	# 根据属性判断状态转换
	if bio_base.current_health <= 0:
		transition_to("DeadState")
	elif bio_base.current_satiety <= 0:
		transition_to("SeekFoodState")

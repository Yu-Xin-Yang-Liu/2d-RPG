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
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 休息时不移动，速度为零
	creature.velocity = Vector2.ZERO
	
	# 恢复能量
	creature.current_energy = min(creature.current_energy + energy_recovery_rate * delta, creature.max_energy)
	rest_duration -= delta
	
	# 休息结束条件
	if rest_duration <= 0 or creature.current_energy >= creature.max_energy * 0.8:
		transition_to("WanderState")
	
	# 检查状态转换
	_check_state_transitions()

# 检查状态转换条件
func _check_state_transitions() -> void:
	var creature = get_creature() as Creature
	if not creature:
		return
	
	# 根据属性判断状态转换
	if creature.current_health <= 0:
		transition_to("DeadState")
	elif creature.current_satiety <= 0:
		transition_to("SeekFoodState")

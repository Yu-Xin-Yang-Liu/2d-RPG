class_name StateMachine
extends Node

# 状态机管理器：管理生物的状态转换

# 初始状态：场景启动时的第一个状态
@export var initial_state: StateBase

# 当前正在执行的状态
var current_state: StateBase
# 存储所有状态的字典，键为状态名称，值为状态节点
var states: Dictionary = {}

func _ready() -> void:
	# 注册所有子节点状态
	for child in get_children():
		if child is StateBase:
			states[child.name] = child
			# 将状态机引用传递给每个状态
			child.state_machine = self
	
	# 设置初始状态
	if initial_state:
		current_state = initial_state
		current_state.enter()

# 物理进程回调：每帧调用，处理状态机的物理更新
func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_process(delta)

# 进程回调：每帧调用，处理状态机的普通更新
func _process(delta: float) -> void:
	if current_state:
		current_state._process(delta)

# 处理输入回调：将未处理的输入事件传递给当前状态
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state._unhandled_input(event)

# 转换到指定状态
# state_name: 要转换到的目标状态名称
func transition_to(state_name: String) -> void:
	# 检查目标状态是否存在
	if not states.has(state_name):
		push_warning("State not found: " + state_name)
		return
	
	# 获取目标状态
	var new_state = states[state_name]
	
	# 如果目标状态就是当前状态，则不进行转换
	if new_state == current_state:
		return
	
	# 记录旧状态名称
	var old_state_name = ""
	if current_state:
		old_state_name = current_state.name
		# 退出当前状态
		current_state.exit()
	
	# 设置新状态并进入
	current_state = new_state
	current_state.enter()

# 获取当前状态的名称
# 返回: 当前状态的名称字符串
func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""

# 检查指定状态是否存在
# state_name: 要检查的状态名称
# 返回: 状态是否存在
func has_state(state_name: String) -> bool:
	return states.has(state_name)

# 获取指定状态节点
# state_name: 要获取的状态名称
# 返回: StateBase类型的状态节点，如果不存在则返回null
func get_state(state_name: String) -> StateBase:
	return states.get(state_name)

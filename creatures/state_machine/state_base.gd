class_name StateBase
extends Node

# 状态基类：所有具体状态的父类

signal state_changed(from_state: String, to_state: String)

# 状态机引用
var state_machine: StateMachine
# 行为树引用
var behavior_tree: BehaviorTree

# 是否启用行为树（某些状态如Rest不需要行为树）
var enable_behavior_tree: bool = true

func _ready() -> void:
	pass

# 进入状态时的回调
func enter() -> void:
	# 获取行为树引用
	if state_machine:
		var creature = state_machine.get_parent()
		if creature:
			behavior_tree = creature.get_node_or_null("BehaviorTree")

# 退出状态时的回调
func exit() -> void:
	pass

# 物理进程回调
func _physics_process(delta: float) -> void:
	# 执行行为树（如果启用）
	if enable_behavior_tree and behavior_tree:
		behavior_tree.execute(delta)

# 进程回调
func _process(delta: float) -> void:
	pass

# 处理输入回调
func _unhandled_input(event: InputEvent) -> void:
	pass

# 转换到指定状态
func transition_to(state_name: String) -> void:
	if state_machine:
		state_machine.transition_to(state_name)

# 获取关联的生物节点
func get_creature():
	if state_machine:
		return state_machine.get_parent()
	return null

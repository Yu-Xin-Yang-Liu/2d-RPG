class_name ComponentManager
extends Node

# 组件管理器：管理所有AI组件的加载和实例化

# 组件路径映射
var component_paths = {
	"movement": "res://systems/ai/components/Creature/movement_component.gd",
	"growth": "res://systems/ai/components/Creature/growth_component.gd",
	"spiritual": "res://systems/ai/components/Creature/spiritual_component.gd",
	"construct": "res://systems/ai/components/Creature/construct_component.gd"
}

var ai_system_paths = {
	"BehaviorTree": "res://systems/ai/behavior_tree/behavior_tree.gd",
	"StateMachine": "res://systems/ai/state_machine/state_machine.gd"
}

func create_ai_system(system_name: String) -> Node:
	var path = ai_system_paths.get(system_name)
	var script = load(path) if path else null
	return script.new() if script else null

# 状态路径映射
var state_paths = {
	"StateBase": "res://systems/ai/state_machine/state_base.gd",
	"WanderState": "res://systems/ai/state_machine/states/wander_state.gd",
	"IdleState": "res://systems/ai/state_machine/states/idle_state.gd",
	"SeekFoodState": "res://systems/ai/state_machine/states/seek_food_state.gd",
	"DeadState": "res://systems/ai/state_machine/states/dead_state.gd",
	"FleeState":"res://systems/ai/state_machine/states/flee_state.gd",
	"RestState":"res://systems/ai/state_machine/states/rest_state.gd"
	# 其他状态...
}

# 行为树节点路径映射
var behavior_node_paths = {
	"Selector": "res://systems/ai/behavior_tree/behavior_nodes/selector.gd",
	"Sequence": "res://systems/ai/behavior_tree/behavior_nodes/sequence.gd",
	"CheckThreat": "res://systems/ai/behavior_tree/behavior_nodes/conditions/check_threat.gd",
	"CheckHungry": "res://systems/ai/behavior_tree/behavior_nodes/conditions/check_hungry.gd",
	"FleeAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/flee_action.gd",
	"SeekFoodAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/seek_food_action.gd",
	"WanderAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/wander_action.gd",
	"IdleAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/idle_action.gd",
	"EatGrassAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/eat_grass_action.gd",
	"BleatAction": "res://systems/ai/behavior_tree/behavior_nodes/actions/bleat_action.gd"
}

# 单例实例
static var instance: ComponentManager = null

# ============ 初始化 ============

# 初始化
func _ready() -> void:
	if instance == null:
		instance = self
		set_process(false)

# ============ 静态方法 ============

#region 静态方法
# 获取单例实例
static func get_instance() -> ComponentManager:
	if instance == null:
		var manager = ComponentManager.new()
		manager._ready()
	return instance
#endregion
	
#region 状态机管理
	# 加载状态
func load_state(state_name: String) -> Script:
	var path = state_paths.get(state_name)
	return load(path) if path else null

# 创建状态实例
func create_state(state_name: String) -> StateBase:
	var script = load_state(state_name)
	return script.new() if script else null

# 注册自定义状态
func register_state(state_name: String, path: String) -> void:
	state_paths[state_name] = path
#endregion

# ============ 组件管理 ============

#region 组件管理
# 加载组件
# component_name: 组件名称
# 返回: 组件脚本，如果加载失败返回null
func load_component(component_name: String) -> Script:
	var path = component_paths.get(component_name)
	return load(path) if path else null
	
# 创建组件实例
# component_name: 组件名称
# 返回: 组件实例，如果创建失败返回null
func create_component(component_name: String) -> Node:
	var script = load_component(component_name)
	return script.new() if script else null

# 注册自定义组件
# component_name: 组件名称
# path: 组件脚本路径
func register_component(component_name: String, path: String) -> void:
	component_paths[component_name] = path

# 获取组件路径
# component_name: 组件名称
# 返回: 组件路径，如果不存在返回空字符串
func get_component_path(component_name: String) -> String:
	return component_paths.get(component_name, "")

# 获取所有组件名称
func get_all_component_names() -> Array:
	return component_paths.keys()
#endregion

# ============ 行为树节点管理 ============

#region 行为树节点管理
# 加载行为树节点
# node_name: 节点名称
# 返回: 节点脚本，如果加载失败返回null
func load_behavior_node(node_name: String) -> Script:
	var path = behavior_node_paths.get(node_name)
	return load(path) if path else null

# 创建行为树节点实例
# node_name: 节点名称
# 返回: 节点实例，如果创建失败返回null
func create_behavior_node(node_name: String) -> Node:
	var script = load_behavior_node(node_name)
	return script.new() if script else null

# 注册自定义行为树节点
# node_name: 节点名称
# path: 节点脚本路径
func register_behavior_node(node_name: String, path: String) -> void:
	behavior_node_paths[node_name] = path

# 获取行为树节点路径
# node_name: 节点名称
# 返回: 节点路径，如果不存在返回空字符串
func get_behavior_node_path(node_name: String) -> String:
	return behavior_node_paths.get(node_name, "")

# 获取所有行为树节点名称
func get_all_behavior_node_names() -> Array:
	return behavior_node_paths.keys()
#endregion

# ============ 调试方法 ============

# 打印组件信息
func print_component_info() -> void:
	print("Component Manager Info:")
	print("  Components:")
	for component_name in component_paths.keys():
		print("    " + component_name + ": " + component_paths[component_name])
	
	print("  Behavior Nodes:")
	for node_name in behavior_node_paths.keys():
		print("    " + node_name + ": " + behavior_node_paths[node_name])

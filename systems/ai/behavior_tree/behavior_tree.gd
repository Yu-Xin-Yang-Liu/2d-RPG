# 行为树根节点，管理整个行为树的执行
class_name BehaviorTree
extends Node

# 行为树根节点脚本
var root: BehaviorNode = null

# 关联的生物节点
var bio_base: BioBase = null
# 是否已设置
var _initialized: bool = false

func _ready() -> void:
	# 获取生物节点引用
	bio_base = get_parent() as BioBase
	
	if not _initialized:
		_setup_tree()

# 物理进程：每帧执行行为树
func _physics_process(delta: float) -> void:
	if root:
		root.execute(delta)

# 执行行为树（外部调用）
func execute(delta: float) -> void:
	if root:
		root.execute(delta)

# 构建行为树结构（可被重写）
func _setup_tree() -> void:
	root = _build_default_tree()
	# 为所有节点设置 bio_base 引用
	if root:
		_init_node_creature(root)
	_initialized = true
	print("BehaviorTree setup complete, root:", root)

# 递归初始化节点的 bio_base 引用
func _init_node_creature(node: BehaviorNode) -> void:
	if node:
		node.bio_base = bio_base
		
		# 如果是组合节点，递归处理子节点
		if node is CompositeNode:
			for child in node.get_child_nodes():
				_init_node_creature(child)

# 创建默认行为树
func _build_default_tree() -> BehaviorNode:
	# 创建选择器（优先级最高的选择执行）
	var selector = Selector.new()
	
	# 逃跑序列: 检测威胁 -> 执行逃跑
	var flee_sequence = Sequence.new()
	flee_sequence.add_child_node(CheckThreat.new())
	flee_sequence.add_child_node(FleeAction.new())
	selector.add_child_node(flee_sequence)
	
	# 觅食序列: 检测饥饿 -> 寻找食物
	var seek_food_sequence = Sequence.new()
	seek_food_sequence.add_child_node(CheckHungry.new())
	seek_food_sequence.add_child_node(SeekFoodAction.new())
	selector.add_child_node(seek_food_sequence)
	
	# 漫游序列: 随机漫游
	var wander_sequence = Sequence.new()
	wander_sequence.add_child_node(WanderAction.new())
	selector.add_child_node(wander_sequence)
	
	# 待机动作
	var idle_action = IdleAction.new()
	selector.add_child_node(idle_action)
	
	return selector

# 设置自定义行为树（外部调用）
func set_tree(new_root: BehaviorNode) -> void:
	root = new_root
	_init_node_creature(root)
	_initialized = true

# 获取关联的生物节点
func get_creature() -> Node:
	return get_parent()

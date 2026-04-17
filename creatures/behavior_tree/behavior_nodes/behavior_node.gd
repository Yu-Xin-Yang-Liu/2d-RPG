# 行为节点基类，所有具体节点的父类
class_name BehaviorNode
extends Node

# 行为节点执行状态
enum Status {
	SUCCESS,   # 成功
	FAILURE,   # 失败
	RUNNING    # 运行中
}

# 当前执行状态
var _status: int = Status.FAILURE

# 关联的生物节点（由行为树设置）
var creature: Creature = null

# 执行行为节点，返回执行状态
func execute(delta: float) -> int:
	return _status

# 获取关联的生物节点
func _get_creature() -> Creature:
	# 优先使用存储的引用
	if creature:
		return creature
	
	# 备用方案：向上查找
	var parent_node = get_parent()
	while parent_node:
		if parent_node is Creature:
			return parent_node as Creature
		if parent_node is BehaviorTree:
			return parent_node.get_parent() as Creature
		parent_node = parent_node.get_parent()
	
	return null

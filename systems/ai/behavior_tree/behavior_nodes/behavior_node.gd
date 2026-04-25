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
var bio_base: BioBase = null

# 执行行为节点，返回执行状态
func execute(delta: float) -> int:
	return _status

# 获取关联的生物节点
func _get_bio_base() -> BioBase:
	# 优先使用存储的引用
	if bio_base:
		return bio_base
	
	# 备用方案：向上查找
	var parent_node = get_parent()
	while parent_node:
		if parent_node is BioBase:
			return parent_node as BioBase
		if parent_node is BehaviorTree:
			return parent_node.get_parent() as BioBase
		parent_node = parent_node.get_parent()
	
	return null

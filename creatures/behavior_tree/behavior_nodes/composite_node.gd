# 组合节点基类，包含子节点的容器
class_name CompositeNode
extends BehaviorNode

# 添加子节点到组合节点中
func add_child_node(child: BehaviorNode) -> void:
	super.add_child(child)

# 获取所有BehaviorNode类型的子节点
func get_child_nodes() -> Array[BehaviorNode]:
	var result: Array[BehaviorNode] = []
	for child in get_children():
		if child is BehaviorNode:
			result.append(child)
	return result

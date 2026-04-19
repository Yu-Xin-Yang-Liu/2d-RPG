# 选择器节点：从左到右依次尝试子节点，返回第一个成功的结果
# 类似逻辑"或"操作，只要有一个子节点成功就返回成功
class_name Selector
extends CompositeNode

# 执行选择器逻辑
func execute(delta: float) -> int:
	# 遍历所有子节点
	for child in get_child_nodes():
		var result = child.execute(delta)
		# 如果子节点执行成功，返回成功
		if result == BehaviorNode.Status.SUCCESS:
			return BehaviorNode.Status.SUCCESS
		# 如果子节点正在运行，返回运行中
		elif result == BehaviorNode.Status.RUNNING:
			return BehaviorNode.Status.RUNNING
	# 所有子节点都失败，返回失败
	return BehaviorNode.Status.FAILURE

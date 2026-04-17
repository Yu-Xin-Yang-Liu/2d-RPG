# 序列节点：从左到右依次执行所有子节点
# 类似逻辑"与"操作，所有子节点都成功才返回成功
class_name Sequence
extends CompositeNode

# 执行序列逻辑
func execute(delta: float) -> int:
	var all_success = true
	
	# 遍历所有子节点
	for child in get_child_nodes():
		var result = child.execute(delta)
		# 如果子节点失败，整个序列失败
		if result == BehaviorNode.Status.FAILURE:
			return BehaviorNode.Status.FAILURE
		# 如果子节点正在运行，返回运行中
		elif result == BehaviorNode.Status.RUNNING:
			all_success = false
			return BehaviorNode.Status.RUNNING
	
	# 所有子节点都成功
	if all_success:
		return BehaviorNode.Status.SUCCESS
	return BehaviorNode.Status.FAILURE

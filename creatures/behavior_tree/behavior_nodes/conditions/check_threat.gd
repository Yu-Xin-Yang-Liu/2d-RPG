# 条件节点：检查是否存在威胁（捕食者）
class_name CheckThreat
extends BehaviorNode

# 检查感知范围内是否有捕食者
func execute(delta: float) -> int:
	# 获取关联的生物节点
	if not creature:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取威胁
	if creature.perception_system:
		var threat = creature.perception_system.get_nearest_threat()
		if threat:
			return BehaviorNode.Status.SUCCESS

	# 没有发现威胁
	return BehaviorNode.Status.FAILURE

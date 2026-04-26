# 条件节点：检查是否存在威胁（捕食者）
class_name CheckThreat
extends BehaviorNode

# 检查感知范围内是否有捕食者
func execute(_delta: float) -> int:
	# 获取关联的生物节点
	bio_base = _get_bio_base()
	#var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取威胁
	var perception_system = bio_base.get_node_or_null("PerceptionSystem")
	if perception_system:
		var threat = perception_system.get_nearest_threat()
		if threat:
			return BehaviorNode.Status.SUCCESS

	# 没有发现威胁
	return BehaviorNode.Status.FAILURE

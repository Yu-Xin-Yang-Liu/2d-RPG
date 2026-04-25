# 条件节点：检查生物是否饥饿
class_name CheckHungry
extends BehaviorNode

# 检查饱食度是否低于阈值
func execute(delta: float) -> int:
	# 获取关联的生物节点
	var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE
	
	# 如果饱食度低于30%，返回成功（需要觅食）
	if bio_base.current_satiety < 30.0:
		return BehaviorNode.Status.SUCCESS
	return BehaviorNode.Status.FAILURE

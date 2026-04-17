# 动作节点：待机动作，使生物停止移动
class_name IdleAction
extends BehaviorNode

# 执行待机动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	if not creature:
		return BehaviorNode.Status.FAILURE
	
	# 设置速度为零，停止移动
	creature.velocity = Vector2.ZERO
	return BehaviorNode.Status.SUCCESS

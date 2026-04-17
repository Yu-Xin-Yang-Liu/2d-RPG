# 动作节点：逃跑动作，使生物远离威胁（捕食者）
class_name FleeAction
extends BehaviorNode

# 执行逃跑动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	if not creature:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取威胁
	if not creature.perception_system:
		return BehaviorNode.Status.FAILURE
	
	var threat = creature.perception_system.get_nearest_threat()
	if not threat:
		return BehaviorNode.Status.FAILURE

	# 计算逃跑方向（远离威胁）
	var flee_direction = creature.position.direction_to(threat.position) * -1
	creature.velocity = flee_direction * (creature.move_speed * 1.5)

	# 正在逃跑中
	return BehaviorNode.Status.RUNNING

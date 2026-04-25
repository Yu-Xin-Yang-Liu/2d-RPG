# 动作节点：逃跑动作，使生物远离威胁（捕食者）
class_name FleeAction
extends BehaviorNode

# 执行逃跑动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取威胁
	var perception_system = bio_base.get_node_or_null("PerceptionSystem")
	if not perception_system:
		return BehaviorNode.Status.FAILURE
	
	var threat = perception_system.get_nearest_threat()
	if not threat:
		return BehaviorNode.Status.FAILURE

	# 计算逃跑方向（远离威胁）
	var flee_direction = bio_base.position.direction_to(threat.position) * -1
	var flee_position = bio_base.position + flee_direction * 100.0
	
	# 使用移动组件进行移动
	if bio_base.has_method("move_to"):
		# 优先使用移动组件的速度（逃跑时速度增加50%）
		var move_speed = 150.0
		if bio_base.has_method("get_move_speed"):
			var base_speed = bio_base.get_move_speed()
			if base_speed > 0:
				move_speed = base_speed * 1.5
		bio_base.move_to(flee_position, move_speed)
	else:
		# 兼容旧代码
		var move_speed = 150.0
		if bio_base.has_method("get_move_speed"):
			var base_speed = bio_base.get_move_speed()
			if base_speed > 0:
				move_speed = base_speed * 1.5
		if bio_base.has_method("set_velocity"):
			bio_base.set_velocity(flee_direction * move_speed)

	# 正在逃跑中
	return BehaviorNode.Status.RUNNING

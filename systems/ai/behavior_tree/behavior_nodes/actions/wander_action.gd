# 动作节点：漫游动作，使生物在区域内随机移动
class_name WanderAction
extends BehaviorNode

# 漫游目标位置
var wander_target: Vector2 = Vector2.ZERO

# 执行漫游动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE
	
	# 如果没有目标或已到达目标，重新生成随机目标
	if wander_target == Vector2.ZERO or bio_base.position.distance_to(wander_target) < 20.0:
		wander_target = bio_base.position + Vector2(
			randf_range(-100, 100),
			randf_range(-100, 100)
		)
	
	# 使用移动组件进行移动
	if bio_base.has_method("move_to"):
		# 优先使用移动组件的速度
		var move_speed = 100.0
		if bio_base.has_method("get_move_speed"):
			move_speed = bio_base.get_move_speed() or 100.0
		bio_base.move_to(wander_target, move_speed)
	else:
		# 兼容旧代码
		var direction = bio_base.position.direction_to(wander_target)
		var move_speed = 100.0
		if bio_base.has_method("get_move_speed"):
			move_speed = bio_base.get_move_speed() or 100.0
		if bio_base.has_method("set_velocity"):
			bio_base.set_velocity(direction * move_speed)
	
	return BehaviorNode.Status.SUCCESS

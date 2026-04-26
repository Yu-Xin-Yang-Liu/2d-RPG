# 动作节点：觅食动作，使生物寻找并吃掉食物
class_name SeekFoodAction
extends BehaviorNode

# 执行觅食动作
func execute(_delta: float) -> int:
	# 获取关联的生物节点
	bio_base = _get_bio_base()
	#var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取食物
	var perception_system = bio_base.get_node_or_null("PerceptionSystem")
	if not perception_system:
		return BehaviorNode.Status.FAILURE
	
	var target_food = perception_system.get_nearest_food()
	if not target_food:
		return BehaviorNode.Status.FAILURE

	# 向食物移动（速度稍快）
	if bio_base.has_method("move_to"):
		# 优先使用移动组件的速度（觅食时速度增加20%）
		var move_speed = 120.0
		if bio_base.has_method("get_move_speed"):
			var base_speed = bio_base.get_move_speed()
			if base_speed > 0:
				move_speed = base_speed * 1.2
		bio_base.move_to(target_food.position, move_speed)
	else:
		# 兼容旧代码
		var direction = bio_base.position.direction_to(target_food.position)
		var move_speed = 120.0
		if bio_base.has_method("get_move_speed"):
			var base_speed = bio_base.get_move_speed()
			if base_speed > 0:
				move_speed = base_speed * 1.2
		if bio_base.has_method("set_velocity"):
			bio_base.set_velocity(direction * move_speed)

	# 到达食物位置
	if bio_base.position.distance_to(target_food.position) < 20.0:
		if bio_base.has_method("eat"):
			bio_base.eat(30.0)
		target_food.queue_free()
		return BehaviorNode.Status.SUCCESS

	# 正在移动中
	return BehaviorNode.Status.RUNNING

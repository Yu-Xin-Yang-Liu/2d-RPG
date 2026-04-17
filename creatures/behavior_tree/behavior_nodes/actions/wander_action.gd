# 动作节点：漫游动作，使生物在区域内随机移动
class_name WanderAction
extends BehaviorNode

# 漫游目标位置
var wander_target: Vector2 = Vector2.ZERO

# 执行漫游动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	if not creature:
		return BehaviorNode.Status.FAILURE
	
	# 如果没有目标或已到达目标，重新生成随机目标
	if wander_target == Vector2.ZERO or creature.position.distance_to(wander_target) < 20.0:
		wander_target = creature.position + Vector2(
			randf_range(-creature.wander_radius, creature.wander_radius),
			randf_range(-creature.wander_radius, creature.wander_radius)
		)
	
	# 计算方向并设置速度
	var direction = creature.position.direction_to(wander_target)
	creature.velocity = direction * creature.move_speed
	
	return BehaviorNode.Status.SUCCESS

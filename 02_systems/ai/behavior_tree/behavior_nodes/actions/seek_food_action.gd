# 动作节点：觅食动作，使生物寻找并吃掉食物
class_name SeekFoodAction
extends BehaviorNode

# 执行觅食动作
func execute(delta: float) -> int:
	# 获取关联的生物节点
	if not creature:
		return BehaviorNode.Status.FAILURE

	# 通过感知系统获取食物
	if not creature.perception_system:
		return BehaviorNode.Status.FAILURE
	
	var target_food = creature.perception_system.get_nearest_food()
	if not target_food:
		return BehaviorNode.Status.FAILURE

	# 向食物移动（速度稍快）
	var direction = creature.position.direction_to(target_food.position)
	creature.velocity = direction * creature.move_speed * 1.2

	# 到达食物位置
	if creature.position.distance_to(target_food.position) < 20.0:
		creature.eat(30.0)
		target_food.queue_free()
		return BehaviorNode.Status.SUCCESS

	# 正在移动中
	return BehaviorNode.Status.RUNNING

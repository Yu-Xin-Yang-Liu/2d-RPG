# 动作节点：待机动作，使生物停止移动
class_name IdleAction
extends BehaviorNode

# 执行待机动作
func execute(_delta: float) -> int:
	# 获取关联的生物节点
	bio_base = _get_bio_base()
	#var bio_base = _get_bio_base()
	if not bio_base:
		return BehaviorNode.Status.FAILURE
	
	# 使用移动组件停止移动
	if bio_base.has_method("stop_moving"):
		bio_base.stop_moving()
	else:
		# 兼容旧代码
		if bio_base.has_method("set_velocity"):
			bio_base.set_velocity(Vector2.ZERO)
	return BehaviorNode.Status.SUCCESS

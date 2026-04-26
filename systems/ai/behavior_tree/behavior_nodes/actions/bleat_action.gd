# 咩叫行为节点
class_name BleatAction
extends BehaviorNode

# 执行行为
func execute(_delta: float) -> int:
	# 获取关联的生物节点
	bio_base = _get_bio_base()
	if not bio_base:
		return Status.FAILURE
	
	# 检查是否是羊
	if bio_base.get_bio_type() != "Sheep":
		return Status.FAILURE
	
	# 执行咩叫行为
	var sheep = bio_base as Sheep
	sheep.bleat()
	
	return Status.SUCCESS

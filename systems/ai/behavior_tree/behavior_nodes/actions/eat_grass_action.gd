# 吃草行为节点
class_name EatGrassAction
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
	
	# 检查是否有足够的饱和度
	if bio_base.current_satiety >= bio_base.max_satiety:
		return Status.FAILURE
	
	# 执行吃草行为
	var sheep = bio_base as Sheep
	sheep.eat_grass(20.0)
	
	return Status.SUCCESS

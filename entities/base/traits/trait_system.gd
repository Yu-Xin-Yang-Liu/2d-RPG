class_name TraitSystem
extends Node

# 特质系统：管理生物的枷锁、天赋和变异特质

# 特质类型常量
const TRAIT_TYPE_SHACKLE = "shackle"      # 枷锁特质（先天限制）
const TRAIT_TYPE_GIFT = "gift"            # 种族天赋（先天增益）
const TRAIT_TYPE_MUTATION = "mutation"    # 变异/修行特质（后天破格）

# 特质字典：键为特质名称，值为特质数据
var traits: Dictionary = {}

# ============ 初始化 ============

# 初始化特质系统
func initialize() -> void:
	# 清空特质
	traits.clear()

# ============ 特质管理 ============

# 添加特质
# trait_name: 特质名称
# trait_type: 特质类型（shackle, gift, mutation）
# data: 特质附加数据
func add_trait(trait_name: String, trait_type: String, data: Dictionary = {}) -> void:
	traits[trait_name] = {
		"type": trait_type,
		"data": data,
		"added_time": Time.get_time_dict_from_system()
	}

# 移除特质
# trait_name: 特质名称
func remove_trait(trait_name: String) -> bool:
	if trait_name in traits:
		traits.erase(trait_name)
		return true
	return false

# 检查是否拥有特质
# trait_name: 特质名称
func has_trait(trait_name: String) -> bool:
	return trait_name in traits

# 获取特质信息
# trait_name: 特质名称
func get_trait(trait_name: String) -> Dictionary:
	return traits.get(trait_name, {})

# 获取特定类型的特质
# trait_type: 特质类型
func get_traits_by_type(trait_type: String) -> Array:
	var result = []
	for trait_name in traits.keys():
		if traits[trait_name].type == trait_type:
			result.append(trait_name)
	return result

# 获取所有枷锁特质
func get_shackle_traits() -> Array:
	return get_traits_by_type(TRAIT_TYPE_SHACKLE)

# 获取所有天赋特质
func get_gift_traits() -> Array:
	return get_traits_by_type(TRAIT_TYPE_GIFT)

# 获取所有变异特质
func get_mutation_traits() -> Array:
	return get_traits_by_type(TRAIT_TYPE_MUTATION)

# ============ 特质检查 ============

# 检查是否有移动限制
func has_movement_restriction() -> bool:
	return has_trait("cannot_move")

# 检查是否有感知限制
func has_perception_restriction() -> bool:
	return has_trait("no_senses")

# 检查是否有语言限制
func has_speech_restriction() -> bool:
	return has_trait("cannot_speak")

# 检查是否有意识限制
func has_consciousness_restriction() -> bool:
	return has_trait("no_consciousness")

# 检查是否有情绪限制
func has_emotion_restriction() -> bool:
	return has_trait("no_emotions")

# ============ 特质效果 ============

# 获取特质效果
# 特质效果
# trait_name: 特质名称
func get_trait_effect(trait_name: String) -> Dictionary:
	var _trait = get_trait(trait_name)
	return _trait.get("data", {})

# 应用特质效果
# trait_name: 特质名称
# target: 目标生物
func apply_trait_effect(trait_name: String, target: BioBase) -> void:
	var effect = get_trait_effect(trait_name)
	# 子类可以重写此方法实现具体效果
	pass

# ============ 行为权限判断 ============

# 检查是否可以执行特定行为
# action: 行为名称
# bio: 生物实例
func can_perform_action(action: String, bio: BioBase) -> bool:
	match action:
		"move":
			return not has_movement_restriction()
		"perceive":
			return not has_perception_restriction()
		"speak":
			return not has_speech_restriction() and bio.ai_level >= 2
		"think":
			return not has_consciousness_restriction() and bio.ai_level >= 1
		"feel":
			return not has_emotion_restriction() and bio.ai_level >= 1
		"cultivate":
			return not has_trait("cannot_cultivate")
		"reproduce":
			return bio.is_alive() and bio.get_energy_percent() > 0.8
		_:
			return true

# 检查是否有特定类型的限制
# restriction_type: 限制类型
func has_restriction(restriction_type: String) -> bool:
	match restriction_type:
		"movement":
			return has_movement_restriction()
		"perception":
			return has_perception_restriction()
		"speech":
			return has_speech_restriction()
		"consciousness":
			return has_consciousness_restriction()
		"emotion":
			return has_emotion_restriction()
		"cultivation":
			return has_trait("cannot_cultivate")
		_:
			return false

# ============ 序列化 ============

# 序列化为字典
func to_dict() -> Dictionary:
	return traits

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	traits = data

# ============ 调试方法 ============

# 打印特质信息
func print_traits() -> void:
	print("Trait System Info:")
	print("  Shackle Traits: " + str(get_shackle_traits()))
	print("  Gift Traits: " + str(get_gift_traits()))
	print("  Mutation Traits: " + str(get_mutation_traits()))

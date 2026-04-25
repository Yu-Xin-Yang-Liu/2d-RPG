class_name Sheep
extends MobileCreature

# 羊：一种移动生物

#region 羊的特定属性

# 羊毛数量
@export var wool_amount: float = 100.0

# 羊毛质量
@export var wool_quality: float = 1.0

# 产奶量
@export var milk_production: float = 50.0

# 性格类型
@export var personality: String = "calm"

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "Sheep"
	
	# 设置羊的基本属性
	max_health = 100.0
	max_energy = 80.0
	move_speed = 80.0
	
	# 添加羊的特定特质
	add_trait("wool_production", "gift", {"description": "可以生产羊毛"})
	add_trait("milk_production", "gift", {"description": "可以产奶"})
	add_trait("herbivore", "gift", {"description": "食草动物"})

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 羊死亡处理逻辑
	print("Sheep died")

#endregion

#region 羊的特定方法

# 剪羊毛
# amount: 剪羊毛的数量
# 返回: 实际剪羊毛的数量
func shear_wool(amount: float = 50.0) -> float:
	var actual_amount = min(amount, wool_amount)
	wool_amount -= actual_amount
	print("Sheep sheared: " + str(actual_amount) + " wool")
	return actual_amount

# 挤奶
# amount: 挤奶的数量
# 返回: 实际挤奶的数量
func milk() -> float:
	var actual_amount = milk_production
	print("Sheep milked: " + str(actual_amount) + " milk")
	return actual_amount

# 吃草
# amount: 吃草的数量
func eat_grass(amount: float = 20.0) -> void:
	if current_satiety < max_satiety:
		var actual_amount = min(amount, max_satiety - current_satiety)
		current_satiety += actual_amount
		print("Sheep ate " + str(actual_amount) + " grass")

# 咩叫
func bleat() -> void:
	print("Sheep bleats: Baaa!")

# 跟随其他羊
# target_sheep: 目标羊
func follow_sheep(target_sheep: Sheep) -> void:
	if target_sheep:
		move_to(target_sheep.position)
		print("Sheep following another sheep")

#endregion

#region 行为方法

# 执行羊的行为
func perform_behavior() -> void:
	# 基于当前状态执行不同的行为
	if current_satiety < 30:
		# 寻找食物
		seek_food()
	elif current_energy < 20:
		# 休息
		rest()
	else:
		# 随机行为
		_random_behavior()

# 寻找食物
func seek_food() -> void:
	print("Sheep seeking food")
	# 这里可以实现寻找草的逻辑
	# 暂时使用随机移动模拟
	var random_position = position + Vector2(
		randf_range(-100, 100),
		randf_range(-100, 100)
	)
	move_to(random_position)

# 休息
func rest() -> void:
	print("Sheep resting")
	stop_moving()
	# 恢复能量
	current_energy = min(current_energy + 5.0, max_energy)

# 随机行为
func _random_behavior() -> void:
	var random_action = randf()
	
	if random_action < 0.3:
		# 随机移动
		var random_position = position + Vector2(
			randf_range(-50, 50),
			randf_range(-50, 50)
		)
		move_to(random_position)
	elif random_action < 0.6:
		# 休息
		stop_moving()
	elif random_action < 0.9:
		# 咩叫
		bleat()
	else:
		# 吃草
		eat_grass()

#endregion

#region 状态检查方法

# 是否可以剪羊毛
func can_shear() -> bool:
	return wool_amount > 20.0

# 是否可以挤奶
func can_milk() -> bool:
	return current_energy > 30.0

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["wool_amount"] = wool_amount
	data["wool_quality"] = wool_quality
	data["milk_production"] = milk_production
	data["personality"] = personality
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	wool_amount = data.get("wool_amount", 100.0)
	wool_quality = data.get("wool_quality", 1.0)
	milk_production = data.get("milk_production", 50.0)
	personality = data.get("personality", "calm")

#endregion

#region 调试方法

# 打印羊的信息
func print_info() -> void:
	super.print_info()
	print("  Wool Amount: " + str(wool_amount))
	print("  Wool Quality: " + str(wool_quality))
	print("  Milk Production: " + str(milk_production))
	print("  Personality: " + personality)
	print("  Can Shear: " + str(can_shear()))
	print("  Can Milk: " + str(can_milk()))

#endregion

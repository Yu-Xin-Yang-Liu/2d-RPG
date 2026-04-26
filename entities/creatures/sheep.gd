class_name Sheep
extends MobileCreature

# 组件管理器
var component_manager: ComponentManager

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
	
	# 获取组件管理器
	component_manager = ComponentManager.get_instance()
	
	# 设置羊的基本属性
	max_health = 100.0
	max_energy = 80.0
	
	# 设置移动速度
	var movement_component = _get_movement_component()
	if movement_component:
		movement_component.move_speed = 80.0
		print("Sheep movement component initialized with speed: " + str(movement_component.move_speed))
	else:
		print("Warning: Movement component not found!")
	
	# 添加羊的特定特质
	add_trait("wool_production", "gift", {"description": "可以生产羊毛"})
	add_trait("milk_production", "gift", {"description": "可以产奶"})
	add_trait("herbivore", "gift", {"description": "食草动物"})
	
	# 设置羊的自定义行为树
	_setup_sheep_behavior_tree()
	
	# 设置羊的状态机
	_setup_sheep_state_machine()
	
	# 打印初始化信息
	print("Sheep initialized: ")
	print("  Behavior Tree: " + str(behavior_tree))
	print("  State Machine: " + str(state_machine))
	print("  Components: " + str(components.keys()))

# 设置羊的自定义行为树
func _setup_sheep_behavior_tree() -> void:
	if behavior_tree:
		# 创建选择器（优先级最高的选择执行）
		var selector = create_behavior_node("Selector")
		
		# 逃跑序列: 检测威胁 -> 执行逃跑
		var flee_sequence = create_behavior_node("Sequence")
		flee_sequence.add_child_node(create_behavior_node("CheckThreat"))
		flee_sequence.add_child_node(create_behavior_node("FleeAction"))
		selector.add_child_node(flee_sequence)
		
		# 觅食序列: 检测饥饿 -> 寻找食物
		var seek_food_sequence = create_behavior_node("Sequence")
		seek_food_sequence.add_child_node(create_behavior_node("CheckHungry"))
		seek_food_sequence.add_child_node(create_behavior_node("SeekFoodAction"))
		selector.add_child_node(seek_food_sequence)
		
		# 吃草序列: 检测饱和度 -> 吃草
		var eat_grass_sequence = create_behavior_node("Sequence")
		eat_grass_sequence.add_child_node(create_behavior_node("CheckHungry"))
		eat_grass_sequence.add_child_node(create_behavior_node("EatGrassAction"))
		selector.add_child_node(eat_grass_sequence)
		
		# 漫游序列: 随机漫游
		var wander_sequence = create_behavior_node("Sequence")
		wander_sequence.add_child_node(create_behavior_node("WanderAction"))
		selector.add_child_node(wander_sequence)
		
		# 咩叫序列: 随机咩叫
		var bleat_sequence = create_behavior_node("Sequence")
		# 这里可以添加条件，比如随机概率
		bleat_sequence.add_child_node(create_behavior_node("BleatAction"))
		selector.add_child_node(bleat_sequence)
		
		# 待机动作
		var idle_action = create_behavior_node("IdleAction")
		selector.add_child_node(idle_action)
		
		# 设置行为树
		behavior_tree.set_tree(selector)

# 设置羊的状态机
func _setup_sheep_state_machine() -> void:
	if state_machine:
		# 设置初始状态为漫游状态
		# 假设状态机中已经有WanderState节点
		if state_machine.has_state("WanderState"):
			state_machine.transition_to("WanderState")
			print("Sheep state machine initialized with WanderState")
		else:
			print("Warning: WanderState not found in state machine")

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

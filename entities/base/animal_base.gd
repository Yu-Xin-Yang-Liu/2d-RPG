class_name AnimalBase
extends BioBase

# 动物基类：所有动物的父类
# 继承自 BioBase，扩展动物特有的属性和方法

#region 动物特有属性

# 动物名称
@export var animal_name: String = "Animal"

# 移动速度
@export var move_speed: float = 100.0

# 饱食度
var satiety: float = 100.0

# 最大饱食度
var max_satiety: float = 100.0

# 游荡半径
@export var wander_radius: float = 200.0

# 繁殖阈值
@export var reproduction_threshold: float = 80.0

# 消耗速率
var energy_consumption_rate: float = 2.0
var satiety_consumption_rate: float = 3.0
var starvation_energy_penalty: float = 5.0
var energy_depletion_health_penalty: float = 2.0

# 能量繁殖阈值
var energy_reproduction_threshold: float = 70.0

#endregion

#region 引用

# 状态机引用
var state_machine: StateMachine

# 行为树引用
var behavior_tree: BehaviorTree

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "Animal"
	health = max_health
	energy = max_energy
	satiety = max_satiety
	
	# 设置AI等级
	ai_level = 1 # 动物具有基础灵性AI
	
	# 添加动物的先天枷锁特质
	add_trait("low_intelligence", "shackle", {"description": "低智本能"})
	add_trait("cannot_cultivate", "shackle", {"description": "无法修行"})
	
	# 添加动物的种族天赋
	add_trait("basic_perception", "gift", {"description": "基础感知"})
	add_trait("instinct_behavior", "gift", {"description": "本能行为"})
	
	# 挂载感知系统组件（动物默认具有感知能力）
	_mount_perception_system()

# 更新状态
func update_state(delta: float) -> void:
	super.update_state(delta)
	
	# 能量自然消耗
	energy -= delta * energy_consumption_rate
	# 饱食度自然消耗
	satiety -= delta * satiety_consumption_rate
	
	# 如果饱食度为0，能量快速消耗
	if satiety <= 0:
		energy -= delta * starvation_energy_penalty
	
	# 如果能量为0，生命值开始减少
	if energy <= 0:
		health -= delta * energy_depletion_health_penalty

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 动物死亡处理逻辑
	print(animal_name + " died")

#endregion

#region 动物特有方法

# 进食
# food_amount: 食物提供的饱食度
func eat(food_amount: float) -> void:
	satiety = min(satiety + food_amount, max_satiety)

# 移动
# direction: 移动方向
# speed: 移动速度
func move(direction: Vector2, speed: float) -> void:
	# 检查是否可以移动
	if not can_move():
		return
	
	# 子类可以重写此方法
	var movement = direction.normalized() * speed
	position += movement

# 攻击
# target: 攻击目标
# damage: 伤害值
func attack(target: BioBase, damage: float) -> void:
	if target and target.is_alive():
		target.take_damage(damage)

# 逃跑
# danger: 危险源
func flee(danger: BioBase) -> void:
	if danger:
		var direction = (position - danger.position).normalized()
		move(direction, move_speed * 1.5)

#endregion

#region 状态检查方法

# 是否饥饿
func is_hungry() -> bool:
	return satiety < max_satiety * 0.3

# 是否可以繁殖
func can_reproduce() -> bool:
	return is_alive() and satiety >= reproduction_threshold and energy >= energy_reproduction_threshold

#endregion

#region 繁殖方法

# 繁殖
func reproduce() -> AnimalBase:
	if can_reproduce():
		var offspring = AnimalBase.new()
		offspring.position = position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		offspring.animal_name = animal_name + " Offspring"
		offspring.max_health = max_health * 0.8
		offspring.health = offspring.max_health
		offspring.max_energy = max_energy * 0.8
		offspring.energy = offspring.max_energy
		offspring.max_satiety = max_satiety * 0.8
		offspring.satiety = offspring.max_satiety
		return offspring
	return null

#endregion

# 感知方法

# 挂载感知系统
func _mount_perception_system() -> void:
	# 检查是否已经挂载
	if has_component("perception"):
		return
	
	# 尝试加载感知系统
	var perception_script = load("res://systems/perception/perception_system.gd")
	if perception_script:
		var perception_system = perception_script.new()
		mount_component("perception", perception_system)
		# 配置感知系统参数
		if perception_system:
			perception_system.vision_range = 150.0
			perception_system.vision_angle = 90.0
			perception_system.hearing_range = 100.0
			perception_system.smell_range = 80.0

# 获取感知系统
func _get_perception_system() -> PerceptionSystem:
	return get_component("perception") as PerceptionSystem

# 感知周围环境
func perceive_environment() -> void:
	# 检查是否可以感知
	if not can_perceive():
		return
	
	# 子类可以重写此方法
	var perception_system = _get_perception_system()
	if perception_system:
		perception_system.perceive_environment()

# 检测附近的食物
func detect_food() -> Array[BioBase]:
	# 检查是否可以感知
	if not can_perceive():
		return []
	
	# 子类可以重写此方法
	var perception_system = _get_perception_system()
	if perception_system and perception_system.has_method("get_nearest_food"):
		var food = perception_system.get_nearest_food()
		if food:
			return [food]
	return []

# 检测附近的威胁
func detect_threats() -> Array[BioBase]:
	# 检查是否可以感知
	if not can_perceive():
		return []
	
	# 子类可以重写此方法
	var perception_system = _get_perception_system()
	if perception_system and perception_system.has_method("get_nearest_threat"):
		var threat = perception_system.get_nearest_threat()
		if threat:
			return [threat]
	return []

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["animal_name"] = animal_name
	data["move_speed"] = move_speed
	data["satiety"] = satiety
	data["max_satiety"] = max_satiety
	data["wander_radius"] = wander_radius
	# data["perception_range"] = perception_range
	# data["reproduction_threshold"] = reproduction_threshold
	# data["vision_range"] = vision_range
	# data["vision_angle"] = vision_angle
	# data["hearing_range"] = hearing_range
	# data["smell_range"] = smell_range
	data["energy_consumption_rate"] = energy_consumption_rate
	data["satiety_consumption_rate"] = satiety_consumption_rate
	data["starvation_energy_penalty"] = starvation_energy_penalty
	data["energy_depletion_health_penalty"] = energy_depletion_health_penalty
	data["energy_reproduction_threshold"] = energy_reproduction_threshold
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	animal_name = data.get("animal_name", "Animal")
	move_speed = data.get("move_speed", 100.0)
	satiety = data.get("satiety", 100.0)
	max_satiety = data.get("max_satiety", 100.0)
	wander_radius = data.get("wander_radius", 200.0)
	# perception_range = data.get("perception_range", 150.0)
	reproduction_threshold = data.get("reproduction_threshold", 80.0)
	# vision_range = data.get("vision_range", 150.0)
	# vision_angle = data.get("vision_angle", 90.0)
	# hearing_range = data.get("hearing_range", 100.0)
	# smell_range = data.get("smell_range", 80.0)
	energy_consumption_rate = data.get("energy_consumption_rate", 2.0)
	satiety_consumption_rate = data.get("satiety_consumption_rate", 3.0)
	starvation_energy_penalty = data.get("starvation_energy_penalty", 5.0)
	energy_depletion_health_penalty = data.get("energy_depletion_health_penalty", 2.0)
	energy_reproduction_threshold = data.get("energy_reproduction_threshold", 70.0)

#endregion

#region 调试方法

# 打印动物信息
func print_info() -> void:
	super.print_info()
	print("  Animal Name: " + animal_name)
	print("  Move Speed: " + str(move_speed))
	print("  Satiety: " + str(satiety) + "/" + str(max_satiety))
	print("  Wander Radius: " + str(wander_radius))
	#print("  Perception Range: " + str(perception_range))

#endregion

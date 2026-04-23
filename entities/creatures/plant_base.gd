class_name PlantBase
extends BioBase

# 植物基类：所有植物的父类
# 继承自 BioBase，扩展植物特有的属性和方法

#region 植物特有属性

# 植物名称
@export var plant_name: String = "Plant"

# 生长阶段
var growth_stage: int = 0

# 最大生长阶段
@export var max_growth_stage: int = 5

# 生长速率
@export var growth_rate: float = 0.1

# 光合作用效率
@export var photosynthesis_efficiency: float = 0.5

# 水分含量
var water_content: float = 100.0

# 最大水分含量
var max_water_content: float = 100.0

# 养分含量
var nutrient_content: float = 100.0

# 最大养分含量
var max_nutrient_content: float = 100.0

# 光照需求
@export var light_requirement: float = 50.0

# 水分需求
@export var water_requirement: float = 30.0

# 养分需求
@export var nutrient_requirement: float = 20.0

# 繁殖方式
@export var reproduction_method: String = "seeds" # seeds, spores, vegetative

# 花期
var flowering: bool = false

# 结果期
var fruiting: bool = false

#endregion

#region 生命周期

# 初始化
func initialize() -> void:
	super.initialize()
	bio_type = "Plant"
	health = max_health
	energy = max_energy
	water_content = max_water_content
	nutrient_content = max_nutrient_content
	
	# 添加植物的先天枷锁特质
	add_trait("cannot_move", "shackle", {"description": "无法移动"})
	add_trait("no_senses", "shackle", {"description": "无五感"})
	add_trait("no_consciousness", "shackle", {"description": "无自主意识"})
	add_trait("cannot_speak", "shackle", {"description": "无法言语"})
	add_trait("no_emotions", "shackle", {"description": "无情绪"})
	
	# 添加植物的种族天赋
	add_trait("photosynthesis", "gift", {"description": "光合作用"})
	add_trait("root_absorption", "gift", {"description": "根系吸收"})

# 更新状态
func update_state(delta: float) -> void:
	super.update_state(delta)
	
	# 生长逻辑
	_update_growth(delta)
	
	# 水分和养分消耗
	_update_resources(delta)
	
	# 检查资源状态
	_check_resource_status()

# 更新生长
func _update_growth(delta: float) -> void:
	if is_alive():
		# 根据资源状态计算生长速率
		var growth_factor = min(water_content / max_water_content, nutrient_content / max_nutrient_content)
		growth_stage = min(growth_stage + growth_rate * growth_factor * delta, max_growth_stage)
		
		# 检查生长阶段触发的事件
		_check_growth_events()

# 更新资源
func _update_resources(delta: float) -> void:
	# 水分自然蒸发
	water_content = max(water_content - delta * 0.5, 0.0)
	# 养分消耗
	nutrient_content = max(nutrient_content - delta * 0.3, 0.0)
	
	# 光合作用产生能量
	var energy_produced = photosynthesis_efficiency * delta * 10.0
	restore_energy(energy_produced)

# 检查资源状态
func _check_resource_status():
	# 如果水分或养分过低，影响健康
	if water_content < max_water_content * 0.2:
		health = max(health - 0.1, 0.0)
	if nutrient_content < max_nutrient_content * 0.2:
		health = max(health - 0.05, 0.0)

# 检查生长事件
func _check_growth_events():
	# 达到一定生长阶段开始开花
	if growth_stage >= max_growth_stage * 0.6 and not flowering:
		flowering = true
		_on_flower()
	
	# 开花后开始结果
	if flowering and growth_stage >= max_growth_stage * 0.8 and not fruiting:
		fruiting = true
		_on_fruit()

# 开花事件
func _on_flower():
	# 子类可以重写此方法
	print(plant_name + " is flowering")

# 结果事件
func _on_fruit():
	# 子类可以重写此方法
	print(plant_name + " is fruiting")

# 死亡处理
func on_death() -> void:
	super.on_death()
	# 植物死亡处理逻辑
	print(plant_name + " died")

#endregion

#region 植物特有方法

# 吸收水分
# amount: 吸收的水分量
func absorb_water(amount: float) -> void:
	water_content = min(water_content + amount, max_water_content)

# 吸收养分
# amount: 吸收的养分量
func absorb_nutrients(amount: float) -> void:
	nutrient_content = min(nutrient_content + amount, max_nutrient_content)

# 进行光合作用
# light_intensity: 光照强度
func photosynthesize(light_intensity: float) -> void:
	var energy_produced = photosynthesis_efficiency * light_intensity * 0.1
	restore_energy(energy_produced)

# 繁殖
func reproduce() -> PlantBase:
	if can_reproduce():
		var offspring = PlantBase.new()
		offspring.position = position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
		offspring.plant_name = plant_name + " Seedling"
		offspring.max_health = max_health * 0.3
		offspring.health = offspring.max_health
		offspring.max_energy = max_energy * 0.3
		offspring.energy = offspring.max_energy
		offspring.growth_stage = 0
		return offspring
	return null

#endregion

#region 状态检查方法

# 是否可以繁殖
func can_reproduce() -> bool:
	return is_alive() and growth_stage >= max_growth_stage * 0.9

# 是否缺水
func is_water_stressed() -> bool:
	return water_content < max_water_content * 0.3

# 是否缺养分
func is_nutrient_stressed() -> bool:
	return nutrient_content < max_nutrient_content * 0.3

# 是否成熟
func is_mature() -> bool:
	return growth_stage >= max_growth_stage * 0.8

#endregion

#region 资源方法

# 获取资源需求
func get_resource_requirements() -> Dictionary:
	return {
		"water": water_requirement,
		"nutrients": nutrient_requirement,
		"light": light_requirement
	}

# 消耗资源
func consume_resources(resources: Dictionary) -> bool:
	var water = resources.get("water", 0.0)
	var nutrients = resources.get("nutrients", 0.0)
	
	absorb_water(water)
	absorb_nutrients(nutrients)
	return true

# 产生资源
func produce_resources() -> Dictionary:
	# 植物可以产生氧气和食物
	return {
		"oxygen": 0.1,
		"food": is_mature() if 1.0 else 0.0
	}

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	var data = super.to_dict()
	data["plant_name"] = plant_name
	data["growth_stage"] = growth_stage
	data["max_growth_stage"] = max_growth_stage
	data["growth_rate"] = growth_rate
	data["photosynthesis_efficiency"] = photosynthesis_efficiency
	data["water_content"] = water_content
	data["max_water_content"] = max_water_content
	data["nutrient_content"] = nutrient_content
	data["max_nutrient_content"] = max_nutrient_content
	data["light_requirement"] = light_requirement
	data["water_requirement"] = water_requirement
	data["nutrient_requirement"] = nutrient_requirement
	data["reproduction_method"] = reproduction_method
	data["flowering"] = flowering
	data["fruiting"] = fruiting
	return data

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	plant_name = data.get("plant_name", "Plant")
	growth_stage = data.get("growth_stage", 0)
	max_growth_stage = data.get("max_growth_stage", 5)
	growth_rate = data.get("growth_rate", 0.1)
	photosynthesis_efficiency = data.get("photosynthesis_efficiency", 0.5)
	water_content = data.get("water_content", 100.0)
	max_water_content = data.get("max_water_content", 100.0)
	nutrient_content = data.get("nutrient_content", 100.0)
	max_nutrient_content = data.get("max_nutrient_content", 100.0)
	light_requirement = data.get("light_requirement", 50.0)
	water_requirement = data.get("water_requirement", 30.0)
	nutrient_requirement = data.get("nutrient_requirement", 20.0)
	reproduction_method = data.get("reproduction_method", "seeds")
	flowering = data.get("flowering", false)
	fruiting = data.get("fruiting", false)

#endregion

#region 调试方法

# 打印植物信息
func print_info() -> void:
	super.print_info()
	print("  Plant Name: " + plant_name)
	print("  Growth Stage: " + str(growth_stage) + "/" + str(max_growth_stage))
	print("  Water Content: " + str(water_content) + "/" + str(max_water_content))
	print("  Nutrient Content: " + str(nutrient_content) + "/" + str(max_nutrient_content))
	print("  Flowering: " + str(flowering))
	print("  Fruiting: " + str(fruiting))

#endregion

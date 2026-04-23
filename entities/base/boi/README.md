# BioBase 生物基础接口

## 概述

`BioBase` 是一个通用的生物基础接口类，作为所有生物（细菌、植物、哺乳动物、鸟类、微生物等）的最小接口基类。它提供了一套通用的属性和方法，确保所有生物类型都有一致的基础结构。

## 设计意图

- **统一接口**：为所有生物类型提供一致的基础接口
- **最小化设计**：只包含最基本的属性和方法
- **扩展性**：通过继承和重写方法支持各种生物类型的特性
- **模块化**：将通用功能集中在基类中，减少代码重复

## 核心功能

### 1. 通用属性

- **基本信息**：id, bio_type, age, life_state
- **生命属性**：health, max_health, energy, max_energy
- **物理属性**：position, size

### 2. 生命周期方法

- `initialize()` - 初始化生物
- `update_state(delta)` - 更新生物状态
- `check_lifecycle()` - 检查生命周期
- `on_death()` - 处理死亡逻辑

### 3. 通用方法

- **状态获取**：get_health(), get_energy(), get_age(), etc.
- **状态检查**：is_alive(), is_dead(), is_hurt(), etc.
- **交互方法**：take_damage(), heal(), consume_energy(), etc.
- **繁殖方法**：can_reproduce(), reproduce()
- **移动方法**：move_to(), get_position(), set_position()
- **感知方法**：perceive_environment(), detect_nearby_bios()
- **资源方法**：get_resource_requirements(), consume_resources(), produce_resources()
- **序列化方法**：to_dict(), from_dict()

### 4. 静态方法

- `create_bio(bio_type)` - 创建生物实例
- `compare_priority(bio1, bio2)` - 比较生物优先级

## 使用方法

### 1. 继承 BioBase

```gdscript
class_name Animal
extends BioBase

func _ready() -> void:
	# 调用父类初始化
	super.initialize()
	# 设置动物特定属性
	bio_type = "Animal"

# 重写更新方法
func update_state(delta: float) -> void:
	# 调用父类更新
	super.update_state(delta)
	# 动物特定的状态更新
	# ...

# 重写繁殖方法
func reproduce() -> BioBase:
	if can_reproduce():
		var offspring = Animal.new()
		offspring.position = position
		return offspring
	return null
```

### 2. 实现特定生物类型

#### 细菌

```gdscript
class_name Bacteria
extends BioBase

func _ready() -> void:
	super.initialize()
	bio_type = "Bacteria"
	health = 10.0
	max_health = 10.0
	size = Vector2(0.1, 0.1)

func reproduce() -> BioBase:
	if can_reproduce():
		var offspring = Bacteria.new()
		offspring.position = position + Vector2(randf_range(-1, 1), randf_range(-1, 1))
		return offspring
	return null
```

#### 植物

```gdscript
class_name Plant
extends BioBase

@export var growth_stage: int = 0

func _ready() -> void:
	super.initialize()
	bio_type = "Plant"

func update_state(delta: float) -> void:
	super.update_state(delta)
	# 植物生长逻辑
	if is_alive():
		growth_stage = int(age / 10.0)
```

### 3. 使用生物实例

```gdscript
# 创建生物
var bacteria = Bacteria.new()
var plant = Plant.new()
var animal = Animal.new()

# 操作生物
bacteria.take_damage(2.0)
plant.heal(5.0)
animal.consume_energy(10.0)

# 检查状态
if bacteria.is_alive():
	print("Bacteria is alive")

if animal.can_reproduce():
	var offspring = animal.reproduce()
	if offspring:
		print("Animal reproduced")

# 获取信息
print("Plant age: " + str(plant.get_age()))
print("Animal health: " + str(animal.get_health_percent() * 100) + "%")
```

## 扩展建议

1. **添加特定生物类型**：创建继承自 BioBase 的具体生物类
2. **扩展属性**：根据生物类型添加特定属性
3. **实现特定方法**：重写基类方法以实现生物特定的行为
4. **添加生态系统交互**：实现生物之间的相互作用
5. **优化性能**：根据具体生物类型优化方法实现

## 注意事项

- **最小接口原则**：只包含所有生物都需要的属性和方法
- **继承链管理**：避免过深的继承层次
- **方法重写**：重写方法时确保调用父类方法
- **性能考虑**：对于大量生物实例，注意方法实现的效率

## 示例生物类型

- **微生物**：细菌、病毒、真菌
- **植物**：树木、草、花
- **动物**：哺乳动物、鸟类、爬行动物、鱼类
- **昆虫**：蚂蚁、蜜蜂、蝴蝶
- **水生生物**：藻类、珊瑚、水母

通过使用 BioBase 作为基础接口，可以构建一个统一、可扩展的生物系统，支持各种类型的生物在游戏中的交互和行为。

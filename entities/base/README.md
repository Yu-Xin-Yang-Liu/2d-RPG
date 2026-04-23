# 生物基类系统

## 概述

本目录包含了三种主要生物类型的基类，它们都继承自 `BioBase` 接口：

- **AnimalBase** - 动物基类
- **PlantBase** - 植物基类
- **MicrobeBase** - 微生物基类

这些基类提供了各自生物类型的通用属性和方法，为具体生物实现提供了基础框架。

## 基类层次结构

```
BioBase (最小接口基类)
├── AnimalBase (动物基类)
├── PlantBase (植物基类)
└── MicrobeBase (微生物基类)
```

## 1. AnimalBase 动物基类

### 核心功能

- **特有属性**：动物名称、移动速度、饱食度、感知能力等
- **行为方法**：移动、攻击、逃跑、进食等
- **状态管理**：饥饿、繁殖条件等
- **感知系统**：视觉、听觉、嗅觉

### 关键属性

- `animal_name`: 动物名称
- `move_speed`: 移动速度
- `satiety`: 饱食度
- `vision_range`: 视觉范围
- `hearing_range`: 听觉范围
- `smell_range`: 嗅觉范围

### 使用示例

```gdscript
class_name Herbivore
extends AnimalBase

func _ready() -> void:
	super.initialize()
	animal_name = "Herbivore"
	move_speed = 80.0
	vision_range = 120.0

func eat(food_amount: float) -> void:
	super.eat(food_amount)
	print(animal_name + " ate " + str(food_amount) + " food")
```

## 2. PlantBase 植物基类

### 核心功能

- **特有属性**：植物名称、生长阶段、水分含量、养分含量等
- **生长系统**：生长阶段、开花、结果
- **资源管理**：水分吸收、养分吸收、光合作用
- **繁殖方式**：种子、孢子、营养繁殖

### 关键属性

- `plant_name`: 植物名称
- `growth_stage`: 生长阶段
- `water_content`: 水分含量
- `nutrient_content`: 养分含量
- `photosynthesis_efficiency`: 光合作用效率

### 使用示例

```gdscript
class_name Tree
extends PlantBase

func _ready() -> void:
	super.initialize()
	plant_name = "Oak Tree"
	max_growth_stage = 10
	growth_rate = 0.05

func _on_fruit():
	super._on_fruit()
	print(plant_name + " produced acorns")
```

## 3. MicrobeBase 微生物基类

### 核心功能

- **特有属性**：微生物名称、繁殖速率、代谢速率、环境耐受性等
- **繁殖系统**：二分裂、出芽、孢子形成
- **代谢系统**：自养、异养、混合营养
- **交互能力**：致病性、共生能力、群体感应

### 关键属性

- `microbe_name`: 微生物名称
- `reproduction_rate`: 繁殖速率
- `metabolism_rate`: 代谢速率
- `pathogenicity`: 致病性
- `symbiotic_capability`: 共生能力

### 使用示例

```gdscript
class_name Bacteria
extends MicrobeBase

func _ready() -> void:
	super.initialize()
	microbe_name = "E. coli"
	reproduction_rate = 1.0
	metabolism_type = "heterotrophic"

func absorb_nutrients(amount: float) -> void:
	super.absorb_nutrients(amount)
	print(microbe_name + " absorbed " + str(amount) + " nutrients")
```

## 通用功能

所有生物基类都继承了 `BioBase` 的通用功能：

- **生命周期管理**：出生、成长、死亡
- **状态管理**：健康、能量、年龄
- **交互方法**：伤害、治疗、能量消耗
- **序列化**：保存和加载状态
- **调试方法**：打印生物信息

## 设计原则

1. **最小接口原则**：`BioBase` 只包含所有生物都需要的属性和方法
2. **层次化设计**：通过继承扩展特定生物类型的功能
3. **可扩展性**：每个基类都可以进一步继承和扩展
4. **一致性**：所有生物都遵循相同的基础接口
5. **模块化**：将特定生物类型的功能集中在各自的基类中

## 使用建议

1. **创建具体生物类型**：继承相应的基类，实现特定生物的行为
2. **扩展属性**：根据需要添加特定生物的属性
3. **重写方法**：根据生物特性重写基类方法
4. **组合使用**：在生态系统中组合使用不同类型的生物
5. **优化性能**：对于大量生物实例，注意方法实现的效率

## 示例生态系统

```
生态系统
├── 动物
│   ├── 哺乳动物 (继承 AnimalBase)
│   ├── 鸟类 (继承 AnimalBase)
│   └── 爬行动物 (继承 AnimalBase)
├── 植物
│   ├── 树木 (继承 PlantBase)
│   ├── 草 (继承 PlantBase)
│   └── 花 (继承 PlantBase)
└── 微生物
	├── 细菌 (继承 MicrobeBase)
	├── 真菌 (继承 MicrobeBase)
	└── 原生动物 (继承 MicrobeBase)
```

通过使用这些基类，可以构建一个完整、统一的生物系统，支持各种类型的生物在游戏中的交互和行为。

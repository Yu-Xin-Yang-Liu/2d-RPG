class_name GrowthComponent
extends Node

# 生长组件：处理生物的生长逻辑

#region 生长相关属性

# 生长阶段
@export var growth_stage: int = 0 # 0: 种子/幼苗, 1: 成长中, 2: 成熟, 3: 衰老

# 最大生长阶段
@export var max_growth_stage: int = 3

# 生长速率（阶段/秒）
@export var growth_rate: float = 0.0001

# 生长计时器
var growth_timer: float = 0.0

# 环境适应度
var environmental_fitness: float = 1.0

# 拥有者
var controller: BioBase

#endregion

#region 生命周期

# 初始化
func _ready() -> void:
	# 获取拥有者
	controller = get_parent() as BioBase

# 物理进程
func _physics_process(delta: float) -> void:
	# 更新生长
	_update_growth(delta)

#endregion

#region 生长方法

# 更新生长
func _update_growth(delta: float) -> void:
	if growth_stage >= max_growth_stage:
		return
	
	growth_timer += delta * growth_rate * environmental_fitness
	if growth_timer >= 1.0:
		growth_timer = 0.0
		advance_growth_stage()

# 推进生长阶段
func advance_growth_stage() -> void:
	if growth_stage < max_growth_stage:
		growth_stage += 1
		_on_growth_stage_advanced()

# 生长阶段推进回调
func _on_growth_stage_advanced() -> void:
	# 子类可以重写此方法
	if controller and controller.has_method("_on_growth_stage_advanced"):
		controller._on_growth_stage_advanced()

#endregion

#region 环境方法

# 更新环境适应度
# fitness: 环境适应度值
func set_environmental_fitness(fitness: float) -> void:
	environmental_fitness = fitness

# 获取环境适应度
func get_environmental_fitness() -> float:
	return environmental_fitness

#endregion

#region 状态检查方法

# 是否成熟
func is_mature() -> bool:
	return growth_stage >= 2

# 是否衰老
func is_old() -> bool:
	return growth_stage >= max_growth_stage

# 获取生长阶段
func get_growth_stage() -> int:
	return growth_stage

# 获取生长百分比
func get_growth_percent() -> float:
	if max_growth_stage <= 0:
		return 0.0
	return float(growth_stage) / float(max_growth_stage)

#endregion

#region 序列化方法

# 序列化为字典
func to_dict() -> Dictionary:
	return {
		"growth_stage": growth_stage,
		"max_growth_stage": max_growth_stage,
		"growth_rate": growth_rate,
		"growth_timer": growth_timer,
		"environmental_fitness": environmental_fitness
	}

# 从字典反序列化
func from_dict(data: Dictionary) -> void:
	growth_stage = data.get("growth_stage", 0)
	max_growth_stage = data.get("max_growth_stage", 3)
	growth_rate = data.get("growth_rate", 0.0001)
	growth_timer = data.get("growth_timer", 0.0)
	environmental_fitness = data.get("environmental_fitness", 1.0)

#endregion

#region 调试方法

# 打印生长信息
func print_info() -> void:
	print("GrowthComponent Info:")
	print("  Growth Stage: " + str(growth_stage) + "/" + str(max_growth_stage))
	print("  Growth Percent: " + str(get_growth_percent() * 100) + "%")
	print("  Environmental Fitness: " + str(environmental_fitness))

#endregion

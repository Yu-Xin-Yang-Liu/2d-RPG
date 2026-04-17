class_name Creature
extends CharacterBody2D

# 生物基类：所有生物的父类

#region 导出属性

# 生物名称
@export var creature_name: String = "Creature"
# 最大生命值
@export var max_health: float = 100.0
# 最大能量值
@export var max_energy: float = 100.0
# 最大饱食度
@export var max_satiety: float = 100.0
# 移动速度
@export var move_speed: float = 100.0
# 游荡半径
@export var wander_radius: float = 200.0
# 感知范围
@export var perception_range: float = 150.0
# 繁殖阈值：饱食度和能量达到此值时可以繁殖
@export var reproduction_threshold: float = 80.0

# 视觉范围：生物能看到的最大距离
@export var vision_range: float = 150.0
# 视觉角度：视野的扇形角度（度数）
@export var vision_angle: float = 90.0

# 听觉范围：能听到声音的最大距离
@export var hearing_range: float = 100.0

# 嗅觉范围：能闻到气味的最大距离
@export var smell_range: float = 80.0

#endregion

#region 当前属性

# 当前生命值
var current_health: float
# 当前能量值
var current_energy: float
# 当前饱食度
var current_satiety: float
# 生物的年龄（秒）
var age: float = 0.0

#endregion

#region 引用

# 状态机引用
var state_machine: StateMachine
# 感知系统引用
var perception_system: PerceptionSystem
# 行为树引用
var behavior_tree: BehaviorTree

#endregion

#region 生命周期

func _ready() -> void:
	# 初始化属性
	_init_stats()
	# 设置感知系统
	_setup_perception_system()
	# 设置状态机
	_setup_state_machine()
	# 设置行为树
	_setup_behavior_tree()

# 初始化属性值
func _init_stats() -> void:
	current_health = max_health
	current_energy = max_energy
	current_satiety = max_satiety

# 设置感知系统
func _setup_perception_system() -> void:
	perception_system = $PerceptionSystem
	if perception_system:
		# 将生物的参数传递给感知系统
		perception_system.vision_range = vision_range
		perception_system.vision_angle = vision_angle
		perception_system.hearing_range = hearing_range
		perception_system.smell_range = smell_range
		perception_system.update_perception_ranges(vision_range, vision_angle, hearing_range, smell_range)

# 设置状态机
func _setup_state_machine() -> void:
	state_machine = $StateMachine
	if state_machine and state_machine.initial_state:
		state_machine.current_state = state_machine.initial_state
		state_machine.current_state.enter()

# 设置行为树
func _setup_behavior_tree() -> void:
	behavior_tree = $BehaviorTree

#endregion

#region 物理进程

# 物理进程：每帧调用，处理物理运动
func _physics_process(delta: float) -> void:
	# 更新年龄
	age += delta
	# 更新属性
	_update_stats(delta)
	
	# 处理状态机（状态机会调用行为树）
	if state_machine:
		state_machine._physics_process(delta)
	
	# 执行移动
	move_and_slide()
	# 翻转精灵图
	_flip_sprite()

# 更新属性值（饥饿、能量消耗等）
func _update_stats(delta: float) -> void:
	# 能量自然消耗
	current_energy -= delta * 2.0
	# 饱食度自然消耗
	current_satiety -= delta * 3.0
	
	# 如果饱食度为0，能量快速消耗
	if current_satiety <= 0:
		current_energy -= delta * 5.0
	
	# 如果能量为0，生命值开始减少
	if current_energy <= 0:
		current_health -= delta * 2.0
	
	# 如果生命值耗尽，转换到死亡状态
	if current_health <= 0 and state_machine:
		state_machine.transition_to("Dead")

# 根据移动方向翻转精灵图
func _flip_sprite() -> void:
	if velocity.x != 0:
		scale.x = sign(velocity.x)

#endregion

#region 公共方法

# 受到伤害
# amount: 伤害值
func take_damage(amount: float) -> void:
	current_health -= amount

# 进食
# food_amount: 食物提供的饱食度
func eat(food_amount: float) -> void:
	current_satiety = min(current_satiety + food_amount, max_satiety)

# 获取当前状态名称
# 返回: 当前状态的名称字符串
func get_state_name() -> String:
	if state_machine:
		return state_machine.get_current_state_name()
	return "Unknown"

# 检查是否可以繁殖
# 返回: 是否满足繁殖条件
func can_reproduce() -> bool:
	return current_satiety >= reproduction_threshold and current_energy >= 70.0

#endregion

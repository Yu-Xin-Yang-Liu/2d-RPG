class_name CreatureConfig
extends Resource

# 生物配置资源类：用于管理生物的默认属性值

## 基本属性
@export var max_health: float = 100.0
@export var max_energy: float = 100.0
@export var max_satiety: float = 100.0
@export var move_speed: float = 100.0
@export var wander_radius: float = 200.0
@export var perception_range: float = 150.0
@export var reproduction_threshold: float = 80.0

## 感知属性
@export var vision_range: float = 150.0
@export var vision_angle: float = 90.0
@export var hearing_range: float = 100.0
@export var smell_range: float = 80.0

## 消耗速率
@export var energy_consumption_rate: float = 2.0
@export var satiety_consumption_rate: float = 3.0
@export var starvation_energy_penalty: float = 5.0
@export var energy_depletion_health_penalty: float = 2.0

## 繁殖阈值
@export var energy_reproduction_threshold: float = 70.0

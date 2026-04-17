class_name Player
extends Node2D

@onready var root: CharacterBody2D = get_node("root")
@onready var camera: Camera2D = get_node("Camera2D")
#@onready var state_machine: StateMachine = root.get_node("StateMachine")

func _ready() -> void:
	#camera.current = true
	
	# 确保摄像机跟随玩家
	camera.position = root.position

func _process(delta: float) -> void:
	# 摄像机平滑跟随
	var target_pos: Vector2 = root.position
	camera.position = camera.position.lerp(target_pos, 0.1)

#func _input(event: InputEvent) -> void:
	# 转发输入到状态机
	#if state_machine:
		#state_machine._input(event)

func get_player() -> CharacterBody2D:
	return root
#获取移动方向
func get_movement_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func is_running() -> bool:
	return Input.is_action_pressed("ui_accept")

class_name EcosystemUI
extends Control

@onready var creature_count_label: Label = $Panel/VBoxContainer/CreatureCount
@onready var time_label: Label = $Panel/VBoxContainer/TimeLabel

var ecosystem_manager: EcosystemManager
var elapsed_time: float = 0.0

func _ready() -> void:
	ecosystem_manager = get_parent().get_node("EcosystemManager")

func _process(delta: float) -> void:
	elapsed_time += delta
	_update_ui()

func _update_ui() -> void:
	if ecosystem_manager:
		creature_count_label.text = "生物数量: " + str(ecosystem_manager.get_creature_count())
	
	var minutes: int = int(elapsed_time) / 60
	var seconds: int = int(elapsed_time) % 60
	time_label.text = "时间: %02d:%02d" % [minutes, seconds]

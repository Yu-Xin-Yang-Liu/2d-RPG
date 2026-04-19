# 死亡状态：生物死亡
class_name DeadState
extends StateBase

func _ready() -> void:
	# 死亡状态不需要行为树
	enable_behavior_tree = false

func enter() -> void:
	print("生物死亡")
	# 禁用碰撞
	var creature = get_creature() as Node
	if creature:
		if creature is CharacterBody2D:
			creature.process_mode = Node.PROCESS_MODE_DISABLED
		# 延迟删除
		await get_tree().create_timer(2.0).timeout
		creature.queue_free()

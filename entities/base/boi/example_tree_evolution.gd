# 树精进化示例
# 展示如何使用特质系统和组件系统实现普通树到成精妖树的转变

class_name ExampleTreeEvolution
extends Node

# 创建普通树
func create_normal_tree() -> PlantBase:
	var tree = PlantBase.new()
	tree.plant_name = "Oak Tree"
	tree.initialize()
	print("=== 普通树初始状态 ===")
	tree.print_info()
	return tree

# 第一阶段：灵气侵蚀，觉醒灵根
func evolve_to_spirit_tree(tree: PlantBase) -> void:
	print("\n=== 第一阶段：灵气侵蚀，觉醒灵根 ===")
	
	# 添加变异特质
	tree.add_trait("spirit_root", "mutation", {"description": "灵根觉醒"})
	
	# 移除感知限制枷锁
	tree.remove_trait("no_senses")
	
	# 挂载感知系统组件
	var perception_system = load("res://systems/perception/perception_system.gd").new()
	tree.mount_component("perception", perception_system)
	
	print("进化结果：")
	tree.print_info()
	print("树现在可以感知周围环境了！")

# 第二阶段：开灵成精，获得意识
func evolve_to_awaken_tree(tree: PlantBase) -> void:
	print("\n=== 第二阶段：开灵成精，获得意识 ===")
	
	# 移除移动限制和意识限制枷锁
	tree.remove_trait("cannot_move")
	tree.remove_trait("no_consciousness")
	tree.remove_trait("no_emotions")
	
	# 升级AI等级
	tree.ai_level = 2
	
	# 挂载情绪组件
	var emotion_module = Node.new()
	emotion_module.name = "EmotionModule"
	tree.mount_component("emotion", emotion_module)
	
	print("进化结果：")
	tree.print_info()
	print("树现在可以移动和产生情绪了！")

# 第三阶段：修行悟道，习得神通
func evolve_to_immortal_tree(tree: PlantBase) -> void:
	print("\n=== 第三阶段：修行悟道，习得神通 ===")
	
	# 移除语言限制枷锁
	tree.remove_trait("cannot_speak")
	
	# 添加修行特质
	tree.add_trait("avatar_creation", "mutation", {"description": "本源分身"})
	tree.add_trait("immortality", "mutation", {"description": "不朽"})
	
	# 升级AI等级
	tree.ai_level = 3
	
	# 挂载社交模块
	var social_module = Node.new()
	social_module.name = "SocialModule"
	tree.mount_component("social", social_module)
	
	# 挂载分身模块
	var avatar_module = Node.new()
	avatar_module.name = "AvatarModule"
	tree.mount_component("avatar", avatar_module)
	
	print("进化结果：")
	tree.print_info()
	print("树现在可以说话、社交和创造分身了！")

# 运行完整进化过程
func run_evolution() -> void:
	# 创建普通树
	var tree = create_normal_tree()
	
	# 第一阶段进化
	evolve_to_spirit_tree(tree)
	
	# 第二阶段进化
	evolve_to_awaken_tree(tree)
	
	# 第三阶段进化
	evolve_to_immortal_tree(tree)
	
	print("\n=== 进化完成 ===")
	print("普通树已成功进化为妖树！")

# 测试状态检查方法
func test_state_checks(tree: PlantBase) -> void:
	print("\n=== 状态检查测试 ===")
	print("Can move: " + str(tree.can_move()))
	print("Can perceive: " + str(tree.can_perceive()))
	print("Can speak: " + str(tree.can_speak()))
	print("Has consciousness: " + str(tree.has_consciousness()))
	print("Has emotions: " + str(tree.has_emotions()))

#!/usr/bin/env gdscript

# 测试AI系统的脚本
# 用于验证状态机和行为树的交互

func test_ai_system():
	print("=== 测试AI系统 ===")
	
	# 测试状态机和行为树的关系
	print("1. 状态机与行为树的关系:")
	print("   - 状态机管理不同状态（WanderState, RestState等）")
	print("   - 每个状态在_physics_process中调用行为树.execute()")
	print("   - 行为树包含多个行为节点（WanderAction, FleeAction等）")
	
	# 测试执行流程
	print("\n2. 执行流程:")
	print("   - BioBase._physics_process() 调用 behavior_tree.execute()")
	print("   - BioBase._physics_process() 调用 state_machine._physics_process()")
	print("   - StateMachine._physics_process() 调用当前状态的_physics_process()")
	print("   - StateBase._physics_process() 调用 behavior_tree.execute()")
	print("   - 行为树被执行两次，可能导致冲突")
	
	# 测试WanderState问题
	print("\n3. WanderState问题分析:")
	print("   - WanderState继承自StateBase，会执行行为树")
	print("   - 行为树默认结构：CheckThreat -> CheckHungry -> WanderAction -> IdleAction")
	print("   - WanderState中的目标位置与WanderAction中的目标位置计算分开")
	print("   - 可能因为行为树优先级，WanderAction不被执行")
	
	# 测试状态转换条件
	print("\n4. 状态转换条件:")
	print("   - 能量 < 30: 转换到RestState")
	print("   - 饱食度 < 40: 转换到SeekFoodState")
	print("   - 否则保持WanderState")
	
	print("\n=== 测试完成 ===")

# 运行测试
test_ai_system()
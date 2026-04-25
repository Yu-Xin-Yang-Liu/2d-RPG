class_name ComponentManager
extends Node

# 组件管理器：管理所有AI组件的加载和实例化

# 组件路径映射
var component_paths = {
	"movement": "res://systems/ai/components/movement_component.gd",
	"growth": "res://systems/ai/components/growth_component.gd",
	"spiritual": "res://systems/ai/components/spiritual_component.gd",
	"construct": "res://systems/ai/components/construct_component.gd"
}

# 单例实例
static var instance: ComponentManager = null

# ============ 初始化 ============

# 初始化
func _ready() -> void:
	if instance == null:
		instance = self

# ============ 静态方法 ============

# 获取单例实例
static func get_instance() -> ComponentManager:
	if instance == null:
		var manager = ComponentManager.new()
		manager._ready()
	return instance

# ============ 组件管理 ============

# 加载组件
# component_name: 组件名称
# 返回: 组件脚本，如果加载失败返回null
func load_component(component_name: String) -> Script:
	var path = component_paths.get(component_name, "")
	if path == "":
		return null
	return load(path)

# 创建组件实例
# component_name: 组件名称
# 返回: 组件实例，如果创建失败返回null
func create_component(component_name: String) -> Node:
	var script = load_component(component_name)
	if not script:
		return null
	return script.new()

# 注册自定义组件
# component_name: 组件名称
# path: 组件脚本路径
func register_component(component_name: String, path: String) -> void:
	component_paths[component_name] = path

# 获取组件路径
# component_name: 组件名称
# 返回: 组件路径，如果不存在返回空字符串
func get_component_path(component_name: String) -> String:
	return component_paths.get(component_name, "")

# 获取所有组件名称
func get_all_component_names() -> Array:
	return component_paths.keys()

# ============ 调试方法 ============

# 打印组件信息
func print_component_info() -> void:
	print("Component Manager Info:")
	for name in component_paths.keys():
		print("  " + name + ": " + component_paths[name])

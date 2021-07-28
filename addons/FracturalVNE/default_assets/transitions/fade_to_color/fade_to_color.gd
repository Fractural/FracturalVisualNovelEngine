extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Fades a node to a color.


export var fade_curve_var_path: NodePath
export var reverse_curve_var_path: NodePath
export var node_holder_var_path: NodePath
export var percentage_var_path: NodePath
export var color_var_path: NodePath

onready var fade_curve = get_node(fade_curve_var_path)
onready var reverse_curve = get_node(reverse_curve_var_path)
onready var node_holder = get_node(node_holder_var_path)
onready var percentage = get_node(percentage_var_path)
onready var color = get_node(color_var_path)


func _ready():
	# duplicate(true) duplicates all children as well, which includes the 
	# tint shader attached to the material.
	node_holder.value.material = node_holder.value.material.duplicate(true)


func run(args = []):
	node_holder.value.material.set_shader_param("tint_amount", fade_curve.value.interpolate((1 - percentage.value) if reverse_curve.value else percentage.value))

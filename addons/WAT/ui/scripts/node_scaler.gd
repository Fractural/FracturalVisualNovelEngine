tool
extends Node
# Scales the set properties by multiplying them with the editor scale.


const FracUtils = FracVNE.Utils

export(Array, String) var scaled_properties
export(Array, String) var scaled_constants
export(Array, String) var scaled_textures
export var target_node_path: NodePath = NodePath(".")
export var dep__assets_registry_path: NodePath

onready var target_node = get_node(target_node_path)
onready var assets_registry = FracUtils.get_valid_node_or_dep(self, dep__assets_registry_path, assets_registry)


func _ready():
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	var editor_scale = assets_registry.get_editor_scale()
	for property_name in scaled_properties:
		if property_name in target_node:
			var property_value = target_node.get(property_name)
			var scaled_value = property_value
			if FracUtils.is_type(property_value, "Number") or FracUtils.is_type(property_value, "Vector2"):
				scaled_value *= editor_scale
			target_node.set(property_name, scaled_value)
	for constant in scaled_constants:
		if target_node is Control:
			target_node.add_constant_override(constant, target_node.get_constant(constant) * editor_scale)

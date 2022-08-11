tool
extends Button
# A scaled button/


const FracUtils = FracVNE.Utils

export var dep__assets_registry_path: NodePath

onready var assets_registry = FracUtils.get_valid_node_or_dep(self, dep__assets_registry_path, assets_registry)


func _ready():
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	icon = assets_registry.load_asset(icon)
	

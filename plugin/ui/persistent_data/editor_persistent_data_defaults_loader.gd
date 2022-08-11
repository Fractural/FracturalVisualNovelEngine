extends Reference
# Modifies the defaults for FracVNEPersistentData in the editor.
# This is mostly applying scaling to certain default values.


const FracUtils = FracVNE.Utils

var persistent_data
var assets_registry


func _init(persistent_data_, assets_registry_):
	persistent_data = persistent_data_
	assets_registry = assets_registry_
	persistent_data.connect("get_defaults", self, "_on_get_defaults")


func _on_get_defaults(persistent_data):
	var editor_scale = assets_registry.get_editor_scale()
	persistent_data.main_hsplit_offset *= editor_scale

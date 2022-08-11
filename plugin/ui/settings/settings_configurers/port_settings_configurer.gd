tool
extends "res://addons/FracturalVNE/plugin/ui/settings/settings_configurers/settings_configurer.gd"
# Configures the settings for the port used by networking.
# Networking is not being used atm so this setting may be deprecated.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PortSettingsConfigurer")
	return arr

# ----- Typeable ----- #


const FracUtils = FracVNE.Utils

export var dep__persistent_data_path: NodePath

onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func configure_settings(settings_window):
	# Only add the port settings if
	# we are in the editor
	if not Engine.is_editor_hint():
		return
	
	settings_window.add_int_field("Editor/Port", persistent_data.port) \
		.connect("changed", self, "_on_port_changed")


func _on_port_changed(new_value: int):
	persistent_data.set_property("port", new_value)

extends "res://addons/FracturalVNE/plugin/ui/settings/settings_configurers/settings_configurer.gd"
# Configures the settings for Docker.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("DockerSettingsConfigurer")
	return arr

# ----- Typeable ----- #


const FracUtils = FracVNE.Utils
const Docker = preload("res://addons/FracturalVNE/plugin/ui/docker.gd")

export var dep__docker_path: NodePath
export var dep__persistent_data_path: NodePath

onready var docker = FracUtils.get_valid_node_or_dep(self, dep__docker_path, docker)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func configure_settings(settings_window):
	# Only add the docker settings if 
	# we are running in the editor.
	if not Engine.is_editor_hint():
		return
	
	settings_window.add_enum_field("General/Display", persistent_data., Docker.DockType.keys())

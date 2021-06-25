extends Reference
tool

# Prefix that groups together all settings added through this script
var _plugin_prefix

func _init(pluginName: String, pluginPrefix: String) -> void:
	_plugin_prefix = pluginPrefix + "/";
	
	push_warning("You may change any setting for " + pluginName + " in Project -> ProjectSettings -> General -> " + pluginPrefix.replace("_", " "))

	ProjectSettings.save()
	
func _get_prefixed_name(name: String) -> String:
	return _plugin_prefix + name

# Adds a setting to the Project Settings
func add_setting(name: String, type: int, value, hint_type: int = -1, hint_string = "") -> void:
	var prefixed_name = _get_prefixed_name(name)

	# Set default value if property does not exist
	if not ProjectSettings.has_setting(prefixed_name):
		ProjectSettings.set(prefixed_name, value)
	
	# Add the custom property info for the setting
	# Note that a setting's custom property info is not saved, therefore you must re-add it every time the editor restarts
	var prop: Dictionary = {}
	prop["name"] = prefixed_name
	prop["type"] = type
	if hint_type > -1:
		prop["hint"] = hint_type
		prop["hint_string"] = hint_string
	ProjectSettings.add_property_info(prop)

# Returns `true` if the setting specified by name exists, `false` otherwise.
func has_setting(name: String) -> bool:
	return ProjectSettings.has_setting(_get_prefixed_name(name))

# Sets the value of a setting.
func set_setting(name: String, value):
	ProjectSettings.set_setting(_get_prefixed_name(name), value)

# Returns the value of a setting.
func get_setting(name: String):
	return ProjectSettings.get_setting(_get_prefixed_name(name))

# Saves the Project Settings
func save():
	ProjectSettings.save()

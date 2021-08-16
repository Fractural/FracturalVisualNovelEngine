extends Node


export var enum_field_prefab: PackedScene
export var int_field_prefab: PackedScene
export var float_field_prefab: PackedScene
export var string_field_prefab: PackedScene
export var array_field_prefab: PackedScene
export var settings_configurer_holder_path: NodePath

var loaded_categories: Array = []

onready var settings_configurer_holder = get_node(settings_configurer_holder_path)


func _ready() -> void:
	refresh()


func refresh() -> void:
	for settings_configurer in settings_configurer_holder:
		settings_configurer.configure_settings(self)


func category_exists(category_name: String) -> bool:
	return get_category(category_name) != null


func get_category(category_name: String):
	for category in loaded_categories:
		if category.name == category_name:
			return category
	return null


func add_category(category_name: String):
	if not category_exists(category_name):
		var new_category = VBoxContainer.new()
		new_category.name = category_name 
		loaded_categories.append(new_category)


func get_or_add_category(category_name: String):
	var category = get_category(category_name)
	if category == null:
		category = add_category(category_name)
	return category


func add_enum_field(category_and_name: String, original_value: int, enum_values: Array):
	return _instance_field(category_and_name, enum_field_prefab, [original_value, enum_values])


func add_float_field(category_and_name: String, original_value: float):
	return _instance_field(category_and_name, float_field_prefab, [original_value])


func add_int_field(category_and_name: String, original_value: float):
	return _instance_field(category_and_name, int_field_prefab, [original_value])


func add_string_field(category_and_name: String, original_value: String):
	return _instance_field(category_and_name, string_field_prefab, [original_value])


func add_array_field(category_and_name: String, original_value: Array, element_type: String):
	return _instance_field(category_and_name, string_field_prefab, [original_value, element_type])


func _instance_field(category_and_name: String, prefab: PackedScene, init_args: Array):
	var split = category_and_name.split("/", true, 1)
	# The last item should be the label
	var label_text = split[split.last()]
	var category
	if split.size() == 2:
		category = split[0]
	
	var field = prefab.instance()
	field.callv("init", init_args)
	_add_field_to_category(field, category)
	return field


func _add_field_to_category(field, category_name: String):
	if category_name == "":
		push_warning("No category specified. FracVNE settings window will default to using a the \"General\" category.")
		category_name = "General"
	var category = get_or_add_category(category_name)
	category.append()

tool
extends Popup


const FracUtils = FracVNE.Utils

export var enum_field_prefab: PackedScene
export var int_field_prefab: PackedScene
export var float_field_prefab: PackedScene
export var string_field_prefab: PackedScene
export var array_field_prefab: PackedScene
export var settings_configurer_holder_path: NodePath
export var categories_holder_path: NodePath
export var category_buttons_holder_path: NodePath
export var category_button_prefab: PackedScene
export var category_prefab: PackedScene
export var dep__assets_registry_path: NodePath

var loaded_categories: Array = []
var category_button_group: ButtonGroup = ButtonGroup.new()

onready var settings_configurer_holder = get_node(settings_configurer_holder_path)
onready var categories_holder = get_node(categories_holder_path)
onready var category_buttons_holder = get_node(category_buttons_holder_path)
onready var assets_registry = FracUtils.get_valid_node_or_dep(self, dep__assets_registry_path, assets_registry)


func _ready() -> void:
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	refresh()
	
	rect_size = rect_size * assets_registry.get_editor_scale()
	set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	

func refresh() -> void:
	for settings_configurer in settings_configurer_holder.get_children():
		settings_configurer.configure_settings(self)
	if loaded_categories.size() > 0:
		open_category(loaded_categories[0])
		category_buttons_holder.get_child(0).pressed = true


func open_category(category: Control):
	for other_category in loaded_categories:
		other_category.visible = other_category == category


func category_exists(category_name: String) -> bool:
	return get_category(category_name) != null


func get_category(category_name: String):
	for category in loaded_categories:
		if category.name == category_name:
			return category
	return null


func add_category(category_name: String):
	if not category_exists(category_name):
		var new_category = category_prefab.instance()
		FracUtils.try_inject_dependency(assets_registry, new_category)
		new_category.name = category_name 
		
		loaded_categories.append(new_category)
		categories_holder.add_child(new_category)
		
		var category_button = category_button_prefab.instance()
		category_button.text = category_name
		category_button.group = category_button_group
		FracUtils.try_inject_dependency(assets_registry, category_button)
		category_button.connect("pressed", self, "open_category", [new_category])
		category_buttons_holder.add_child(category_button)
		return new_category


func get_or_add_category(category_name: String):
	var category = get_category(category_name)
	if category == null:
		category = add_category(category_name)
	return category


func field_exists(field_name: String, category_name: String):
	return get_field(field_name, category_name) != null


func get_field(field_name: String, category_name: String):
	var category = get_category(category_name)
	if category != null:
		var field = category.get_node_or_null(field_name)
		return field
	else:
		return null


func add_enum_field(category_and_name: String, original_value: int, enum_values: Array):
	return _instance_field(category_and_name, original_value, [enum_values], enum_field_prefab)


func add_float_field(category_and_name: String, original_value: float):
	return _instance_field(category_and_name, original_value, [], float_field_prefab)


func add_int_field(category_and_name: String, original_value: float):
	return _instance_field(category_and_name, original_value, [], int_field_prefab)


func add_string_field(category_and_name: String, original_value: String):
	return _instance_field(category_and_name, original_value, [], string_field_prefab)


func add_array_field(category_and_name: String, original_value: Array, element_type: String):
	return _instance_field(category_and_name, original_value, [element_type], array_field_prefab)


func _instance_field(category_and_name: String, original_value, init_args: Array, prefab: PackedScene):
	var split = category_and_name.split("/", true, 1)
	# The last item should be the label
	var field_name = split[split.size() - 1]
	var category_name
	if split.size() == 2:
		category_name = split[0]
	if category_name == "":
		push_warning("No category specified. FracVNE settings window will default to using a the \"General\" category.")
		category_name = "General"
	
	var existing_field = get_field(field_name, category_name)
	if existing_field != null:
		return existing_field
	
	var field = prefab.instance()
	field.name = field_name
	FracUtils.try_inject_dependency(assets_registry, field)
	
	# All prefabs must accept the field name and the original value
	# as the first two arguments. actual_init_args holds the
	# actual arguments that will be passed into init, which
	# include the original value and the field name.
	var actual_init_args = [field_name, original_value]
	actual_init_args.append_array(init_args)
	field.callv("init", actual_init_args)
	
	_add_field_to_category(field, category_name)
	return field


func _add_field_to_category(field, category_name: String):
	var category = get_or_add_category(category_name)
	category.add_child(field)

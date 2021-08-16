tool
extends Control


signal script_selected(script_path)
signal valid_script_selected(script_path)
signal invalid_script_selected(script_path)

const FracUtils = FracVNE.Utils

var SCRIPT_ICON: Texture
var REFRESH_ICON: Texture

export var search_line_edit_path: NodePath
export var scripts_item_list_path: NodePath
export var open_directory_button_path: NodePath
export var open_directory_dialog_path: NodePath
export var popup_dim_path: NodePath
export var refresh_button_path: NodePath
export var current_directory_label_path: NodePath
export var tree_path: NodePath

export var persistent_data_dep_path: NodePath

var loaded_scripts: Array = []
var auto_remove_invalid_scripts: bool = true

onready var search_line_edit: LineEdit = get_node(search_line_edit_path)
onready var scripts_item_list: ItemList = get_node(scripts_item_list_path)
onready var open_directory_button: Button = get_node(open_directory_button_path)
onready var open_directory_dialog: FileDialog = get_node(open_directory_dialog_path)
onready var refresh_button: Button = get_node(refresh_button_path)
onready var popup_dim: Node = get_node(popup_dim_path)
onready var current_directory_label: Label = get_node(current_directory_label_path)
onready var tree: Tree = get_node(tree_path)

onready var persistent_data_dep = get_node(persistent_data_dep_path)


func _ready():
	search_line_edit.connect("text_changed", self, "_on_search_text_changed")
	scripts_item_list.connect("item_selected", self, "_on_item_selected")
	open_directory_button.connect("pressed", self, "_start_open_directory")
	
	open_directory_dialog.connect("dir_selected", self, "_on_dir_selected")
	open_directory_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	open_directory_dialog.connect("popup_hide", self, "_on_popup_hide")
	
	refresh_button.connect("pressed", self, "_on_refresh_button_pressed")
	
	scripts_item_list.clear()
	print("Using persistent data for curr_directory_path: " + persistent_data_dep.dependency.current_directory_path)
	set_current_directory(persistent_data_dep.dependency.current_directory_path)


func _post_assets_setup():
	print("_post_assets_setup for browser w/ curr_directory: " + get_current_directory())
	if get_current_directory() != "":
		load_scripts_in_dir(get_current_directory())
	if get_current_script_path() != "":
		load_script(get_current_script_path())
	var item = tree.create_item()
	item.set_icon(0, SCRIPT_ICON)
	item.set_icon(0, SCRIPT_ICON)
	item.set_text(0, "TESTING")

func refresh_script_item_list():
	if get_current_directory() == "":
		return
	
	scripts_item_list.clear()
	for script_path in loaded_scripts:
		var file_name = script_path.get_file()
		if search_line_edit.text == "" or file_name.find(search_line_edit.text) > -1:
			scripts_item_list.add_item(file_name, SCRIPT_ICON)
			scripts_item_list.set_item_metadata(scripts_item_list.get_item_count() - 1, script_path)
			if get_current_script_path() != "" and script_path == get_current_script_path():
				scripts_item_list.select(scripts_item_list.get_item_count() - 1, true)


func clear_scripts():
	loaded_scripts = []


func load_scripts_in_dir(directory: String) -> void:
	var script_file_paths = FracUtils.get_dir_files(directory, true, ["storyscript"])
	for file_path in script_file_paths:
		load_script(file_path, false)
	refresh_script_item_list()


func load_script(path: String, refresh: bool = true) -> void:
	if not is_script_loaded(path):
		var file_name = path.get_file()
		loaded_scripts.append(path)
		if refresh:
			refresh_script_item_list()


func is_script_loaded(path: String) -> bool:
	return loaded_scripts.has(path)


func remove_script(path: String) -> void:
	var file_name = path.get_file()
	if is_script_loaded(path):
		loaded_scripts.erase(path)
		refresh_script_item_list()


func set_current_directory(directory) -> void:
	current_directory_label.text = '"%s"' % directory
	persistent_data_dep.dependency.current_directory_path = directory


func get_current_directory() -> String:
	return persistent_data_dep.dependency.current_directory_path


func get_current_script_path():
	return persistent_data_dep.dependency.current_script_path


func _on_item_selected(index: int):
	var selected_script_path = scripts_item_list.get_item_metadata(index)
	var file = File.new()
	emit_signal("script_selected", selected_script_path)
	if file.file_exists(selected_script_path):
		emit_signal("valid_script_selected", selected_script_path)
	else:
		emit_signal("invalid_script_selected", selected_script_path)
		if auto_remove_invalid_scripts:
			remove_script(selected_script_path)


func _on_dir_selected(directory):
	clear_scripts()
	set_current_directory(directory)
	load_scripts_in_dir(directory)


func _on_popup_about_to_show() -> void:
	popup_dim.visible = true
	open_directory_dialog.invalidate()


func _on_popup_hide() -> void:
	popup_dim.visible = false


func _on_search_text_changed(new_text) -> void:
	refresh_script_item_list()


func _on_refresh_button_pressed() -> void:
	if get_current_directory() != "":
		load_scripts_in_dir(get_current_directory())


func _start_open_directory() -> void:
	open_directory_dialog.popup()


func _setup_editor_assets(assets_registry) -> void:
	SCRIPT_ICON = assets_registry.load_asset("assets/icons/script.svg")
	
	open_directory_dialog.rect_size = open_directory_dialog.rect_size * assets_registry.get_editor_scale()
	open_directory_dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	
	refresh_button.icon = assets_registry.load_asset("assets/icons/reload.svg")
	open_directory_button.icon = assets_registry.load_asset("assets/icons/load.svg")
	search_line_edit.right_icon = assets_registry.load_asset("assets/icons/search.svg")
	self.rect_min_size *= assets_registry.get_editor_scale()
	
	_post_assets_setup()

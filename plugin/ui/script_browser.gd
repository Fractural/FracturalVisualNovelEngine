tool
extends Control


signal script_selected(script_path)
signal valid_script_selected(script_path)
signal invalid_script_selected(script_path)

enum FileDisplay {
	ITEM_LIST,
	TREE,
}

const FracUtils = FracVNE.Utils
const FilesItemList = preload("res://addons/FracturalVNE/plugin/ui/files_item_list.gd")
const FilesTree = preload("res://addons/FracturalVNE/plugin/ui/files_tree.gd")

var SCRIPT_ICON: Texture
var REFRESH_ICON: Texture

export var search_line_edit_path: NodePath
export var scripts_item_list_path: NodePath
export var scripts_tree_path: NodePath
export var scripts_tree_toggle_path: NodePath
export var scripts_item_list_toggle_path: NodePath
export var open_directory_button_path: NodePath
export var open_directory_dialog_path: NodePath
export var popup_dim_path: NodePath
export var refresh_button_path: NodePath
export var current_directory_label_path: NodePath
export var dep__persistent_data_path: NodePath

onready var search_line_edit: LineEdit = get_node(search_line_edit_path)
onready var scripts_item_list: FilesItemList = get_node(scripts_item_list_path)
onready var scripts_tree: FilesTree = get_node(scripts_tree_path)
onready var scripts_tree_toggle: Button = get_node(scripts_tree_toggle_path)
onready var scripts_item_list_toggle: Button = get_node(scripts_item_list_toggle_path)
onready var open_directory_button: Button = get_node(open_directory_button_path)
onready var open_directory_dialog: FileDialog = get_node(open_directory_dialog_path)
onready var refresh_button: Button = get_node(refresh_button_path)
onready var popup_dim: Node = get_node(popup_dim_path)
onready var current_directory_label: Label = get_node(current_directory_label_path)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func _ready():
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	search_line_edit.connect("text_changed", self, "_on_search_text_changed")
	open_directory_button.connect("pressed", self, "_start_open_directory")
	
	scripts_item_list.connect("file_selected", self, "_on_file_selected")
	scripts_tree.connect("file_selected", self, "_on_file_selected")
	
	open_directory_dialog.connect("dir_selected", self, "_on_dir_selected")
	open_directory_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	open_directory_dialog.connect("popup_hide", self, "_on_popup_hide")
	
	refresh_button.connect("pressed", self, "_on_refresh_button_pressed")
	
	scripts_item_list.file_extensions = ["storyscript"]
	scripts_tree.file_extensions = ["storyscript"]
	
	scripts_item_list.clear()
	scripts_tree.clear()
	
	scripts_item_list_toggle.connect("toggled", self, "_on_file_display_type_button_toggled", [FileDisplay.ITEM_LIST])
	scripts_tree_toggle.connect("toggled", self, "_on_file_display_type_button_toggled", [FileDisplay.TREE])
	
	set_current_directory(persistent_data.current_directory_path)
	set_current_file_display_type(persistent_data.current_file_display_type)


func _post_assets_setup():
	if get_current_directory() != "":
		get_current_file_display().directory = get_current_directory()
	refresh_file_display()



func select_file(path: String):
	get_current_file_display().select_file(path)


func refresh_file_display():
	get_current_file_display().refresh(get_current_script_path())


func set_current_directory(directory) -> void:
	current_directory_label.text = '"%s"' % directory
	get_current_file_display().directory = directory
	persistent_data.set_property("current_directory_path", directory)


func get_current_directory() -> String:
	return persistent_data.current_directory_path


func get_current_script_path() -> String:
	return persistent_data.current_script_path


var _halt_toggle_signals: bool = false

func set_current_file_display_type(file_display: int):
	if _halt_toggle_signals:
		return
	_halt_toggle_signals = true
	
	scripts_item_list_toggle.pressed = file_display == FileDisplay.ITEM_LIST
	scripts_tree_toggle.pressed = file_display == FileDisplay.TREE
	
	scripts_item_list.visible = scripts_item_list_toggle.pressed
	scripts_tree.visible = scripts_tree_toggle.pressed
	
	persistent_data.set_property("current_file_display_type", file_display)
	get_current_file_display().search_text = search_line_edit.text
	get_current_file_display().directory = get_current_directory()
	refresh_file_display()
	
	_halt_toggle_signals = false


func get_current_file_display_type() -> int:
	return persistent_data.current_file_display_type


func get_current_file_display():
	match get_current_file_display_type():
		FileDisplay.ITEM_LIST:
			return scripts_item_list
		FileDisplay.TREE:
			return scripts_tree


func _on_file_selected(selected_script_path: String):
	var file = File.new()
	emit_signal("script_selected", selected_script_path)
	if file.file_exists(selected_script_path):
		emit_signal("valid_script_selected", selected_script_path)
	else:
		emit_signal("invalid_script_selected", selected_script_path)
		refresh_file_display()


func _on_dir_selected(directory):
	set_current_directory(directory)
	refresh_file_display()


func _on_popup_about_to_show() -> void:
	popup_dim.visible = true
	open_directory_dialog.invalidate()


func _on_popup_hide() -> void:
	popup_dim.visible = false


func _on_search_text_changed(new_text) -> void:
	get_current_file_display().search_text = new_text
	refresh_file_display()


func _on_refresh_button_pressed() -> void:
	if get_current_directory() != "":
		refresh_file_display()


func _start_open_directory() -> void:
	open_directory_dialog.popup()


func _on_file_display_type_button_toggled(enabled: bool, type: int):
	if enabled:
		set_current_file_display_type(type)


func _setup_editor_assets(assets_registry) -> void:
	SCRIPT_ICON = assets_registry.load_asset("assets/icons/script.svg")
	
	scripts_item_list.default_file_icon = assets_registry.load_asset("assets/icons/storyscript.svg")
	
	scripts_tree.default_file_icon = assets_registry.load_asset("assets/icons/storyscript.svg")
	scripts_tree.folder_icon = assets_registry.load_asset("assets/icons/folder.svg")
	scripts_tree.favorites_cion = assets_registry.load_asset("assets/icons/favorites.svg")
	
	open_directory_dialog.rect_size = open_directory_dialog.rect_size * assets_registry.get_editor_scale()
	open_directory_dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	
	search_line_edit.right_icon = assets_registry.load_asset("assets/icons/search.svg")
	self.rect_min_size *= assets_registry.get_editor_scale()
	
	current_directory_label.rect_min_size.y *= assets_registry.get_editor_scale()
	
	scripts_item_list_toggle.icon = assets_registry.load_asset("assets/icons/file_list.svg")
	scripts_tree_toggle.icon = assets_registry.load_asset("assets/icons/filesystem.svg")
	
	_post_assets_setup()

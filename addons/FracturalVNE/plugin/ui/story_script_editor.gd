tool
class_name StoryScriptEditor
extends Node
# Controls the story script editor and wires up the UI buttons within the
# editor.


const PluginAssetsRegistry = preload("res://addons/FracturalVNE/plugin/plugin_assets_registry.gd")

export var compile_button_path: NodePath
export var run_button_path: NodePath
export var script_text_edit_path: NodePath
export var compiler_path: NodePath
export var compiled_ui_path: NodePath
export var compiled_icon_path: NodePath
export var saved_ui_path: NodePath
export var saved_icon_path: NodePath
export var file_menu_path: NodePath
export var settings_button_path: NodePath
export var editing_file_label_path: NodePath
export var open_file_dialog_path: NodePath
export var save_file_dialog_path: NodePath
export var popup_dim_path: NodePath
export var script_browser_path: NodePath

export var story_runner_dep_path: NodePath
export var persistent_data_dep_path: NodePath

var compiled: bool = false setget set_compiled
var saved: bool = false setget set_saved
var current_script_path: String = ""

onready var compile_button: Button = get_node(compile_button_path)
onready var run_button: Button = get_node(run_button_path)
onready var script_text_edit: StoryScriptTextEdit = get_node(script_text_edit_path)
onready var compiler: StoryScriptCompiler = get_node(compiler_path)
onready var compiled_ui: Control = get_node(compiled_ui_path)
onready var compiled_icon: TextureRect = get_node(compiled_icon_path)
onready var saved_ui: Control = get_node(saved_ui_path)
onready var saved_icon: TextureRect = get_node(saved_icon_path)
onready var file_menu: MenuButton = get_node(file_menu_path)
onready var settings_button: Button = get_node(settings_button_path)
onready var editing_file_label: Label = get_node(editing_file_label_path)
onready var open_file_dialog: FileDialog = get_node(open_file_dialog_path)
onready var save_file_dialog: FileDialog = get_node(save_file_dialog_path)
onready var popup_dim: ColorRect = get_node(popup_dim_path)
onready var script_browser = get_node(script_browser_path)

onready var story_runner_dep = get_node(story_runner_dep_path)
onready var persistent_data_dep = get_node(persistent_data_dep_path)


func _ready() -> void:
	if FracVNE.Utils.is_in_editor_scene_tab(self):
		return
	
	# If this is running standalone, then set up editor assets with a default scale of 1.
	if not Engine.is_editor_hint():
		_setup_editor_assets(PluginAssetsRegistry.new())
	
	set_compiled(persistent_data_dep.dependency.compiled)
	set_saved(persistent_data_dep.dependency.saved)
	compile_button.connect("pressed", self, "compile_script")
	run_button.connect("pressed", self, "run_script")
	compiler.connect("throw_error", script_text_edit, "display_error")
	script_text_edit.connect("text_changed", self, "_on_script_text_changed")
	
	file_menu.connect("menu_item_pressed", self, "_on_file_menu_item_pressed")
	file_menu.create_shortcut("Open", "open", KEY_O, ["ctrl"])
	file_menu.create_separator()
	file_menu.create_shortcut("New", "new", KEY_N, ["ctrl"])
	file_menu.create_separator()
	file_menu.create_shortcut("Save", "save", KEY_S, ["ctrl"])
	file_menu.create_shortcut("Save As", "save as", KEY_S, ["ctrl", "alt"])
	
	open_file_dialog.connect("file_selected", self, "open_file")
	save_file_dialog.connect("file_selected", self, "save_file_to")
	open_file_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	save_file_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	open_file_dialog.connect("popup_hide", self, "_on_popup_hide")
	save_file_dialog.connect("popup_hide", self, "_on_popup_hide")
	
	script_browser.connect("valid_script_selected", self, "_on_valid_script_selected")
	
	if persistent_data_dep.dependency.current_script_path == "":
		new_file()
	# Loads existing file in script_browser.gd


func new_file() -> void:
	set_current_script_path("")
	script_text_edit.text = """# This is a comment!
define b = Character(name="Bob", name_color="#fcba03")
define j = Character("Joe", "#03a1fc", "#03a1fc")
b "Hi there, I'm Bob!"
j "Hi there, I'm Joe!"
"Tom" "Hi there, I'm tom!"
label start:
	b "I'm in a label!"
	j "I'm also in a label!"
	"Tom" "I'm also in a label!"
	"Here's some narration in the label!"
	"Tom" "Lets jump recursively back to that label!"
	jump start
label impossible_to_reach:
	"You will never reach this label!"
"""
	
	# Clear the undo history after switching to a new script -- we don't want users to undo
	# back to the original script after they loaded a new one.
	script_text_edit.clear_undo_history()

	set_compiled(false)
	set_saved(false)

# Returns true if successful.
func open_file(file_path) -> bool:
	var file = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK:
		printerr("Cannot open file at \"%s\", got error code \"%s\"." % [file_path, str(error)])
		return false
	script_text_edit.text = file.get_as_text()
	file.close()
	
	set_current_script_path(file_path)
	
	script_text_edit.clear_undo_history()
	script_browser.load_script(file_path)
	
	set_compiled(false)
	set_saved(true)
	return true


# Returns true if successful.
func save_file_to(file_path) -> bool:
	var file = File.new()
	var error = file.open(file_path, File.WRITE)
	if error != OK:
		printerr("Cannot open file at \"%s\", got error code \"%s\"." % [file_path, str(error)])
		return false
	
	set_current_script_path(file_path)
	file.store_string(script_text_edit.text)
	file.close()
	
	set_saved(true)
	return true


# Returns true if successful.
func save_current_file() -> bool:
	if current_script_path == "":
		save_file_dialog.popup()
		return false
	else:
		return save_file_to(current_script_path)


# Sets compiled to true if successful.
func compile_script() -> void:
	if persistent_data_dep.dependency.current_script_path == "":
		save_file_dialog.popup()
		return
	
	var ast_tree = compiler.compile(script_text_edit.text)
	if ast_tree is FracVNE.StoryScript.Error:
		script_text_edit.display_error(ast_tree)
		set_compiled(false)
	else:
		script_text_edit.clear_error()
		var successful = save_ast_to_file(ast_tree, persistent_data_dep.dependency.current_script_path.trim_suffix(".storyscript") + ".story")
		set_compiled(successful)
		if not successful:
			printerr("Could not compile due to file saving issues.")


# Returns true if successful.
func save_ast_to_file(ast_tree, file_path) -> bool:
	var serialized_ast = JSON.print(ast_tree.serialize())
	
	var serialized_file = File.new()
	var error = serialized_file.open_compressed(file_path, File.WRITE)
	if error != OK:
		printerr("Cannot open file at \"%s\", got error code \"%s\"." % [file_path, str(error)])
		return false
	
	serialized_file.store_string(serialized_ast)
	serialized_file.close()
	
	persistent_data_dep.dependency.current_saved_story_path = file_path
	return true


func run_script() -> void:
	if not compiled:
		compile_script()
	
	if not compiled:
		return
	
	if not save_current_file():
		return
	
	if not Engine.is_editor_hint():
		story_runner_dep.dependency.run(persistent_data_dep.dependency.current_saved_story_path, load("res://addons/FracturalVNE/plugin/ui/story_script_editor.tscn"))
	else:
		story_runner_dep.dependency.run(persistent_data_dep.dependency.current_saved_story_path)


func set_compiled(new_value: bool) -> void:
	compiled = new_value
	persistent_data_dep.dependency.compiled = new_value
	if compiled_ui != null:
		compiled_ui.modulate.a = 1 if new_value else 0.5


func set_saved(new_value: bool) -> void:
	saved = new_value
	persistent_data_dep.dependency.saved = new_value
	if saved_ui != null:
		saved_ui.modulate.a = 1 if new_value else 0.5


func set_current_script_path(new_value: String) -> void:
	current_script_path = new_value
	persistent_data_dep.dependency.current_script_path = new_value
	if editing_file_label != null:
		editing_file_label.text = "Editing \"%s\" " % current_script_path


func _on_script_text_changed() -> void:
	set_compiled(false)
	set_saved(false)


func _on_file_menu_item_pressed(meta: String) -> void:
	match meta:
		"open":
			open_file_dialog.popup()
		"new":
			new_file()
		"save":
			save_current_file()
		"save as":
			save_file_dialog.popup()


func _on_popup_about_to_show() -> void:
	popup_dim.visible = true
	open_file_dialog.invalidate()
	save_file_dialog.invalidate()


func _on_popup_hide() -> void:
	popup_dim.visible = false


func _on_valid_script_selected(file_path: String) -> void:
	open_file(file_path)


func _setup_editor_assets(assets_registry) -> void:
	compile_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	run_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	compiled_icon.texture = assets_registry.load_asset("assets/icons/check_box.svg")
	saved_icon.texture = assets_registry.load_asset("assets/icons/check_box.svg")
	file_menu.icon = assets_registry.load_asset("assets/icons/load.svg")
	settings_button.icon = assets_registry.load_asset("assets/icons/settings.png")
	
	open_file_dialog.rect_size = open_file_dialog.rect_size * assets_registry.get_editor_scale()
	save_file_dialog.rect_size = open_file_dialog.rect_size * assets_registry.get_editor_scale()
	
	open_file_dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	save_file_dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	
	script_text_edit._setup_editor_assets(assets_registry)
	script_browser._setup_editor_assets(assets_registry)

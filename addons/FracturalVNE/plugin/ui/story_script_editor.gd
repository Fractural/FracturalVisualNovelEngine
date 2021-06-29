tool
class_name StoryScriptEditor
extends Node
# Controls the story script editor and wires up the UI buttons within the
# editor.


const TEMP_SCRIPT_PATH: String = "res://temp.storyscript"

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
export var editing_file_label_path: NodePath
export var open_file_dialog_path: NodePath
export var save_file_dialog_path: NodePath
export var popup_dim_path: NodePath

export var story_runner_dep_path: NodePath
export var persistent_data_dep_path: NodePath

var compiled: bool = false setget set_compiled
var saved: bool = false setget set_saved
var current_script_path: String = TEMP_SCRIPT_PATH

onready var compile_button: Button = get_node(compile_button_path)
onready var run_button: Button = get_node(run_button_path)
onready var script_text_edit: StoryScriptTextEdit = get_node(script_text_edit_path)
onready var compiler: StoryScriptCompiler = get_node(compiler_path)
onready var compiled_ui: Control = get_node(compiled_ui_path)
onready var compiled_icon: TextureRect = get_node(compiled_icon_path)
onready var saved_ui: Control = get_node(saved_ui_path)
onready var saved_icon: TextureRect = get_node(saved_icon_path)
onready var file_menu: MenuButton = get_node(file_menu_path)
onready var editing_file_label: Label = get_node(editing_file_label_path)
onready var open_file_dialog: FileDialog = get_node(open_file_dialog_path)
onready var save_file_dialog: FileDialog = get_node(save_file_dialog_path)
onready var popup_dim: ColorRect = get_node(popup_dim_path)

onready var story_runner_dep = get_node(story_runner_dep_path)
onready var persistent_data_dep = get_node(persistent_data_dep_path)


func _ready():
	if FracturalUtils.is_in_editor_scene_tab(self):
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
	file_menu.create_shortcut("Save", "save", KEY_S, ["ctrl"])
	file_menu.create_shortcut("Save As", "save as", KEY_S, ["ctrl", "alt"])
	
	open_file_dialog.connect("file_selected", self, "open_file")
	save_file_dialog.connect("file_selected", self, "save_file_to")
	open_file_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	save_file_dialog.connect("about_to_show", self, "_on_popup_about_to_show")
	open_file_dialog.connect("popup_hide", self, "_on_popup_hide")
	save_file_dialog.connect("popup_hide", self, "_on_popup_hide")
	
	if persistent_data_dep.dependency.current_script_path == "":
		# TODO: Remove when done testing
		script_text_edit.text = ""
	#	for i in 100:
	#		script_text_edit.text += '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."'
	#		script_text_edit.text += "\n"
		script_text_edit.text += 'define b = Character(name="Bob", name_color="#fcba03") \n'
		script_text_edit.text += 'define j = Character("Joe", "#03a1fc", "#03a1fc") \n'
		script_text_edit.text += 'b "Hi there, I\'m bob!" \n'
		script_text_edit.text += 'j "Hi there, I\'m joeeee!" \n'
		script_text_edit.text += '"Tom" "Hi there, I\'m tom!" \n'
		script_text_edit.text += 'say(b, "This is from a function!") \n'
		script_text_edit.text += 'say(j, "This is also from a function!") \n'
		script_text_edit.text += 'say("lol", "This is also also from a function!") \n'
		script_text_edit.text += 'label lol: \n'
		script_text_edit.text += '\tb "I\'m in a label!" \n'
		script_text_edit.text += '\tj "I\'m also in a label!" \n'
		script_text_edit.text += '\t"Tom" "I\'m also also in a label!" \n'
		script_text_edit.text += '\t"Here\'s some narration in the label!" \n'
		script_text_edit.text += '\t"Tom" "Lets jump recursively back to that label!" \n'
		script_text_edit.text += '\tjump lol\n'
		script_text_edit.text += 'label another_one: \n'
		script_text_edit.text += '\t "You will never reach this label!"\n'
		
		persistent_data_dep.dependency.current_script_path = TEMP_SCRIPT_PATH
		set_current_script_path(persistent_data_dep.dependency.current_script_path)
	else:
		open_file(persistent_data_dep.dependency.current_script_path)
	
	# Clear the undo history after switching to a new script -- we don't want users to undo
	# back to the original script after they loaded a new one.
	script_text_edit.clear_undo_history()


func open_file(file_path):
	set_current_script_path(file_path)
	var file = File.new()
	file.open(file_path, File.READ)
	script_text_edit.text = file.get_as_text()
	file.close()
	
	set_compiled(false)
	set_saved(true)


func save_file_to(file_path):
	set_current_script_path(file_path)
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(script_text_edit.text)
	file.close()
	
	set_saved(true)


func save_current_file():
	save_file_to(current_script_path)


func compile_script():
	var ast_tree = compiler.compile(script_text_edit.text)
	
	if ast_tree is StoryScriptError:
		script_text_edit.display_error(ast_tree)
		set_compiled(false)
	else:
		script_text_edit.clear_error()
		set_compiled(true)
		save_ast_to_file(ast_tree, persistent_data_dep.dependency.current_script_path.trim_suffix(".storyscript") + ".story")


func save_ast_to_file(ast_tree, file_path):
	var serialized_ast = JSON.print(ast_tree.serialize())
	
	var serialized_file = File.new()
	serialized_file.open_compressed(file_path, File.WRITE)
	serialized_file.store_line(serialized_ast)
	serialized_file.close()
	
	persistent_data_dep.dependency.current_saved_story_path = file_path


func run_script():
	if not compiled:
		compile_script()
	
	if not compiled:
		return
	
	save_current_file()
	
	# TODO: Add support for playing story from editor
	# 		PluginUI should implement it's own "StoryRunner" and manually
	#		inject the dependency into StoryScriptEditor
	if not Engine.is_editor_hint():
		story_runner_dep.dependency.run(persistent_data_dep.dependency.current_saved_story_path, load("res://addons/FracturalVNE/plugin/ui/story_script_editor.tscn"))
	else:
		story_runner_dep.dependency.run(persistent_data_dep.dependency.current_saved_story_path)


func set_compiled(new_value):
	compiled = new_value
	persistent_data_dep.dependency.compiled = new_value
	if compiled_ui != null:
		compiled_ui.modulate.a = 1 if new_value else 0.5


func set_saved(new_value):
	saved = new_value
	persistent_data_dep.dependency.saved = new_value
	if saved_ui != null:
		saved_ui.modulate.a = 1 if new_value else 0.5


func set_current_script_path(new_value):
	current_script_path = new_value
	persistent_data_dep.dependency.current_script_path = new_value
	if editing_file_label != null:
		editing_file_label.text = "Editing \"%s\" " % current_script_path


func _on_script_text_changed():
	set_compiled(false)
	set_saved(false)


func _on_file_menu_item_pressed(meta):
	match meta:
		"open":
			open_file_dialog.popup()
		"save":
			save_current_file()
		"save as":
			save_file_dialog.popup()


func _on_popup_about_to_show():
	popup_dim.visible = true


func _on_popup_hide():
	popup_dim.visible = false


func _setup_editor_assets(assets_registry):
	compile_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	run_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	compiled_icon.texture = assets_registry.load_asset("assets/icons/check_box.svg")
	saved_icon.texture = assets_registry.load_asset("assets/icons/check_box.svg")
	file_menu.icon = assets_registry.load_asset("assets/icons/load.svg")
	
	script_text_edit._setup_editor_assets(assets_registry)

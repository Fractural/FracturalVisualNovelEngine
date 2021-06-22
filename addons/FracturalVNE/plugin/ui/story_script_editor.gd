tool
class_name StoryScriptEditor
extends Node

const TEMP_STORY_PATH = "res://temp.story"

export var compiled_ui_path: NodePath
export var compile_button_path: NodePath
export var run_button_path: NodePath
export var script_text_edit_path: NodePath
export var compiler_path: NodePath

onready var compiled_ui: Control = get_node(compiled_ui_path)
onready var compile_button: Button = get_node(compile_button_path)
onready var run_button: Button = get_node(run_button_path)
onready var script_text_edit: StoryScriptTextEdit = get_node(script_text_edit_path)
onready var compiler: StoryScriptCompiler = get_node(compiler_path)
onready var story_save_manager = StoryServiceRegistry.get_service("StorySaveManager")

var compiled: bool = false

func _ready():
	compiled_ui.modulate.a = 0.5
	compile_button.connect("pressed", self, "compile_script")
	run_button.connect("pressed", self, "run_script")
	compiler.connect("throw_error", script_text_edit, "display_error")
	
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
	script_text_edit.text += '\t"Tom" "Lets jump recursively back to that label!" \n'
	script_text_edit.text += '\tjump lol\n'
	script_text_edit.text += 'label lol: \n'

func compile_script():
	var ast_tree = compiler.compile(script_text_edit.text)
	
	if ast_tree is StoryScriptError:
		script_text_edit.display_error(ast_tree)
		compiled_ui.modulate.a = 0.5
		compiled = false
	else:
		script_text_edit.clear_error()
		compiled = true
		compiled_ui.modulate.a = 1
		save_ast_to_file(ast_tree, TEMP_STORY_PATH)

func save_ast_to_file(ast_tree, file_path):
	var serialized_ast = JSON.print(ast_tree.serialize())
	
	var serialized_file = File.new()
	serialized_file.open_compressed(file_path, File.WRITE)
	serialized_file.store_line(serialized_ast)
	serialized_file.close()

func run_script():
	if not compiled:
		compile_script()
	
	if not compiled:
		return
	
	# TODO: Add support for playing story from editor
	# 		Use this to play custom scene in editor: plugin.get_editor_interface().play_custom_scene("scene_file_path")
	if Engine.is_editor_hint():
		return
	else:
		run_from_standalone_editor()

func run_from_standalone_editor():
	StoryServiceRegistry.get_service("StoryRunner").run(TEMP_STORY_PATH)

func _setup_editor_assets(assets_registry):
	compile_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	run_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	script_text_edit._setup_editor_assets(assets_registry)

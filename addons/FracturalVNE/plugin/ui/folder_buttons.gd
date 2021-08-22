tool
extends Node
# Provides behaviour for the compile all and run main buttons


const FracUtils = FracVNE.Utils

export var story_script_editor_path: NodePath
export var compile_all_button_path: NodePath
export var run_main_button_path: NodePath
export var dep__persistent_data_path: NodePath

onready var story_script_editor = get_node(story_script_editor_path)
onready var compile_all_button = get_node(compile_all_button_path)
onready var run_main_button = get_node(run_main_button_path)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func _ready():
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	compile_all_button.connect("pressed", self, "compile_all")
	run_main_button.connect("pressed", self, "run_main")


func compile_all():
	var script_paths = FracUtils.get_dir_files(persistent_data.current_directory_path, true, ["storyscript"])
	for script_path in script_paths:
		story_script_editor.compile_script(script_path)


func run_main():
	var script_paths = FracUtils.get_dir_files(persistent_data.current_directory_path, true, ["storyscript"])
	for script_path in script_paths:
		if script_path.get_file() == "main.storyscript":
			story_script_editor.compile_script(script_path)
			# compile_script() compiles the data into the same folder
			story_script_editor.run_compiled_script(script_path.replace(".storyscript", ".story"))
			return
	push_warning("No main script found! Make sure you have a \"main.storyscript\" file somewhere in the directory.")

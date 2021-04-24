tool
class_name StoryScriptEditor
extends Node

export var compile_button_path: NodePath
export var script_text_edit_path: NodePath
export var compiler_path: NodePath

onready var compile_button: Button = get_node(compile_button_path)
onready var script_text_edit: StoryScriptTextEdit = get_node(script_text_edit_path)
onready var compiler: StoryScriptCompiler = get_node(compiler_path)

func _ready():
	compile_button.connect("pressed", self, "compile_script")

func compile_script():
	compiler.compile(script_text_edit.text)

func _setup_editor_assets(assets_registry):
	compile_button.icon = assets_registry.load_asset("assets/icons/play.svg")
	script_text_edit._setup_editor_assets(assets_registry)

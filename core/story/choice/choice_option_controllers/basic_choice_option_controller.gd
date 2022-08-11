extends "res://addons/FracturalVNE/core/story/choice/choice_option_controller.gd"
# Basic choice option controller that uses just a Button.


export var choice_button_path: NodePath

onready var choice_button: Button = get_node(choice_button_path)


func _ready():
	choice_button.connect("pressed", self, "choice_selected")


func init(choice_option):
	.init(choice_option)
	
	choice_button.text = choice_option.text
	choice_button.disabled = not choice_option.is_valid

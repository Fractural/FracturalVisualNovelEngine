extends Node
# -- Abstract Class -- #
# Handles choices from a ChoiceManager.


const FracUtils = FracVNE.Utils

export var dep__choice_manager_path: NodePath

onready var choice_manager = FracUtils.get_valid_node_or_dep(self, dep__choice_manager_path, choice_manager)


func _ready():
	choice_manager.connect("start_choice", self, "_on_start_choice")


func _on_start_choice(choices_options: Array):
	pass

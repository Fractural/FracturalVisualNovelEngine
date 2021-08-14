extends Node
# -- Abstract Class -- #
# Handles choices from a ChoiceManager.


export var choice_manager_dep_path: NodePath

onready var choice_manager_dep = get_node(choice_manager_dep_path)


func _ready():
	choice_manager_dep.dependency.connect("start_choice", self, "_on_start_choice")


func _on_start_choice(choices_options: Array):
	pass

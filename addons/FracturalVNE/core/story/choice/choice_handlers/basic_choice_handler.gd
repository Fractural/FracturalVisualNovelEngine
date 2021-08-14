extends "res://addons/FracturalVNE/core/story/choice/choice_handler.gd"
# Handles choices from a ChoiceManager.


export var option_controller_prefab: PackedScene
export var option_controllers_holder_path: NodePath

var option_controllers: Array = []

onready var option_controllers_holder = get_node(option_controllers_holder_path)


func _ready():
	for child in option_controllers_holder.get_children():
		child.queue_free()


func _on_start_choice(choices_options: Array):
	reset()
	
	for choice_option in choices_options:
		var controller = option_controller_prefab.instance()
		option_controllers.append(controller)
		option_controllers_holder.add_child(controller)
		controller.init(choice_option)
		controller.connect("choice_selected", self, "select_choice", [choice_option])


func select_choice(choice_option):
	choice_manager_dep.dependency.select_choice(choice_option)
	reset()


func reset():
	for controller in option_controllers:
		controller.queue_free()

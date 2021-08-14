extends Node
# Handles choices.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptService", get_service_name(), "ASTVisitor"]

# ----- Typeable ----- #


# ----- StoryService ----- #

# Optional
# Configures a service for a new AST.
# (program_node is the root of the AST).
func configure_service(program_node):
	_cleanup()


func get_service_name():
	return "ChoiceManager"

# ----- StoryService ----- #


signal choice_selected(option_index)
signal start_choice(choice_options)

var choice_options: Array = []
var has_ongoing_choice: bool = false


func start_choice(choice_options_: Array):
	choice_options = choice_options_
	emit_signal("start_choice", choice_options)
	has_ongoing_choice = true


func select_choice(choice_option):
	var option_index = choice_options.find(choice_option)
	emit_signal("choice_selected", option_index)
	_cleanup()


func skip_choice():
	_cleanup()


func has_ongoing_choice():
	return has_ongoing_choice


func _cleanup():
	has_ongoing_choice = false
	choice_options = []

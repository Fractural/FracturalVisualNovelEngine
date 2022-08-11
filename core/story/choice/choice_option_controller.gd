extends Node
# -- Abstract Class -- #
# Controls a choice option


signal choice_selected()

var choice_option


func init(choice_option_):
	choice_option = choice_option_


func choice_selected():
	emit_signal("choice_selected")

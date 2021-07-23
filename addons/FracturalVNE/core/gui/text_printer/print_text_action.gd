extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for printing something in the TextPrinter


var text_printer


# No implementation for skip for print text action since printed text should 
# persist until a new piece of text is printer over it.
func _init(text_printer_, skippable_ = true).(skippable_):
	text_printer = text_printer_


func skip():
	text_printer.emit_signal("skip")

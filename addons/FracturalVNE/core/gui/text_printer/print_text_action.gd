extends "res://addons/FracturalVNE/core/story/step_action.gd"
# Action for printing something in the TextPrinter


var text_printer


# No implementation for skip for print text action since printed text should 
# persist until a new piece of text is printer over it.
func _init(_text_printer, _skippable).(_skippable):
	text_printer = _text_printer


func skip():
	text_printer.emit_signal("skip")

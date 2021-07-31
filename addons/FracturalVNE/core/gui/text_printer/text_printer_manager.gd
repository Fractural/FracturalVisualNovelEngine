extends Node
# Creates and keeps track of TextPrinters.


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
	FuncDef.new("TextPrinter", [
		Param.new("text_printer_path"),
		Param.new("cached", false),
		])
]


func get_service_name():
	return "TextPrinterManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const TextPrinter = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer.gd")

export var actor_manager_path: NodePath 

var default_text_printer_controller = null

onready var actor_manager = get_node(actor_manager_path)


func get_default_text_printer():
	return get_default_text_printer_controller().get_text_printer()


func get_default_text_printer_controller():
	return default_text_printer_controller


func add_text_printer(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.add_actor(text_printer)


func remove_text_printer(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.remove_actor(text_printer)


func load_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.load_actor_controller(text_printer)


func remove_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.remove_actor_controller(text_printer)


# Returns the text_printer_controller that belongs to the text_printer. If there is none
# then the a new text_printer_controller will be loaded, assigned to the text_printer, 
# and returned.
func get_or_load_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	return actor_manager.get_or_load_actor_controller(text_printer)


# ----- StoryScriptFunc ----- #

func TextPrinter(text_printer_path, cached):
	if not text_printer_path is String:
		return SSUtils.error("Expected text_printer_path to be a string.")
	
	var text_printer = TextPrinter.new(cached, text_printer_path)

	var init_result = actor_manager.add_new_actor(text_printer, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return text_printer

# ----- StoryScriptFunc ----- #

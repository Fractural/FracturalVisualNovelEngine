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


func configure_service(program_node):
	# If we have a default text printer, then re-add it
	# since we have loaded a new tree and the actor_manager 
	# has been wiped.
	if default_text_printer_controller != null:
		add_new_text_printer_with_controller(get_default_text_printer(), default_text_printer_controller)
		


func get_service_name():
	return "TextPrinterManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const TextPrinter = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer.gd")

export var actor_manager_path: NodePath 
export var reference_registry_path: NodePath

var default_text_printer_controller = null

onready var actor_manager = get_node(actor_manager_path)
onready var reference_registry = get_node(reference_registry_path)


# ----- Default Text Printer ----- #

func set_default_text_printer_controller(value):
	default_text_printer_controller = value


func get_default_text_printer():
	if default_text_printer_controller != null:
		return default_text_printer_controller.get_text_printer()
	return null


func get_default_text_printer_controller():
	return default_text_printer_controller

# ----- Default Text Printer ----- #


# ----- Generic Actor Manager Funcs ----- #

func add_text_printer(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.add_actor(text_printer)


func remove_text_printer(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.remove_actor(text_printer)


func remove_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	actor_manager.remove_actor_controller(text_printer)


func load_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	return actor_manager.load_actor_controller(text_printer)


func get_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	return actor_manager.get_actor_controller(text_printer)


# Returns the TextPrinterController that belongs to the text_printer. If there is none
# then the a new TextPrinterController will be loaded, assigned to the text_printer, 
# and returned.
func get_or_load_text_printer_controller(text_printer):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter"))
	return actor_manager.get_or_load_actor_controller(text_printer)


func add_new_text_printer_with_controller(text_printer, text_printer_controller):
	assert(FracVNE.Utils.is_type(text_printer, "TextPrinter")
		and FracVNE.Utils.is_type(text_printer_controller, "TextPrinterController"))
	actor_manager.add_new_actor_with_controller(text_printer, text_printer_controller)

# ----- Generic Actor Manager Funcs ----- #


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


# ----- Serialization ----- #

func serialize_state() -> Dictionary:
	return {
		"service_name": get_service_name(),
		"default_text_printer_id": reference_registry.get_reference_id(get_default_text_printer())
	} 


func deserialize_state(serialized_state) -> void:
	if serialized_state["default_text_printer_id"] > -1:
		# Delete old default printer if it exists.
		# This is so that the new printer can be loaded in successfully.
		if get_default_text_printer() != null:
			remove_text_printer(get_default_text_printer())
		set_default_text_printer_controller(
			actor_manager.get_actor_controller(
				reference_registry.get_reference(serialized_state["default_text_printer_id"])))

# ----- Serialization ----- #

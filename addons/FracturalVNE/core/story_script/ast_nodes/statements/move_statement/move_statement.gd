extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Moves a visual to a position with an optional smoothing.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("move")
	return arr

# ----- Typeable ----- #


const MoveAction = preload("res://addons/FracturalVNE/core/visuals/movement/move_action.gd")

var visual
var target_position
var travel_curve
var duration


func _init(position_ = null, visual_ = null, target_position_ = null, travel_curve_ = null, duration_ = null).(position_):
	visual = visual_
	target_position = target_position_
	travel_curve = travel_curve_
	duration = duration_


func execute():
	var visual_result = visual.evaluate()
	
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the Visual."))
		return
	
	var target_position_result = target_position.evaluate()
	if not is_success(target_position_result):
		throw_error(stack_error(target_position_result, "Could not evaluate the target position."))
		return
	if not target_position_result is Vector2:
		throw_error(error("Expected a Vector2 for the target position in the move statement."))
		return
	
	var travel_curve_result = null
	if travel_curve != null:
		travel_curve_result = travel_curve.evaluate()
		if not is_success(travel_curve_result):
			throw_error(stack_error(travel_curve_result, "Could not evaluate the travel curve."))
			return
		if not travel_curve_result is Curve:
			throw_error(error("Expected a Curve for the travel curve in the move statement."))
			return
	
	var duration_result = null
	if duration != null:
		duration_result = duration.evaluate()
		if not is_success(duration_result):
			throw_error(stack_error(duration_result, "Could not evaluate the duration."))
			return
		if not (duration_result is float or duration_result is int):
			throw_error(error("Expected a number for the duration result in the move statement."))
			return
	
	if duration_result == null:
		if travel_curve_result == null:
			# We have no travel_curve and no duration.
			duration_result = 0
		else:
			# We have a travel_curve but no duration.
			# Therefore we must use the default duration for the travel curve, 
			# which is 1 second
			duration_result = 1
	
	if visual_result is Object:
		if visual_result.is_type("Character"):
			visual_result = visual_result.visual
		
		if visual_result.is_type("Visual"):
			visual_result.visual_mover.move(target_position_result, travel_curve_result, duration_result, MoveAction.new(visual_result.visual_mover))
			.execute()
		else:
			throw_error(error("Expected a visual for the move statement."))
			return
	else:
		throw_error(error("Expected a visual for the move statement."))
		return
	

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MOVE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tVISUAL: "
	string += "\n" + tabs_string + "\t{"
	string += visual.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "\tTARGET POS: "
	string += "\n" + tabs_string + "\t{"
	string += target_position.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if travel_curve != null:
		string += "\n" + tabs_string + "\tCURVE: "
		string += "\n" + tabs_string + "\t{"
		string += travel_curve.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	visual.propagate_call(method, arguments, parent_first)
	target_position.propagate_call(method, arguments, parent_first)
	if travel_curve != null:
		travel_curve.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["visual"] = visual.serialize()
	serialized_object["target_position"] = target_position.serialize()
	if travel_curve != null:
		serialized_object["travel_curve"] = travel_curve.serialize()
	if duration != null:
		serialized_object["duration"] = duration.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.visual = SerializationUtils.deserialize(serialized_object["visual"])
	instance.target_position = SerializationUtils.deserialize(serialized_object["target_position"])
	if serialized_object.has("travel_curve"):
		instance.travel_curve = SerializationUtils.deserialize(serialized_object["travel_curve"])
	if serialized_object.has("duration"):
		instance.duration = SerializationUtils.deserialize(serialized_object["duration"])
	
	return instance

# ----- Serialization ----- #

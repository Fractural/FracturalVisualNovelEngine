extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Moves an actor to a position with an optional smoothing.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("move")
	return arr

# ----- Typeable ----- #


var actor
var target_position
var travel_curve
var duration


func _init(position_ = null, actor_ = null, target_position_ = null, travel_curve_ = null, duration_ = null).(position_):
	actor = actor_
	target_position = target_position_
	travel_curve = travel_curve_
	duration = duration_


func execute():
	var actor_result = actor.evaluate()
	
	if not is_success(actor_result):
		throw_error(stack_error(actor_result, "Could not evaluate the actor."))
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
	
	if actor_result is Object:
		if FracUtils.is_type(actor_result, "Character"):
			actor_result = actor_result.visual
		
		if FracUtils.is_type(actor_result, "Actor"):
			var actor_controller = get_runtime_block().get_service("ActorManager").get_or_load_actor_controller(actor_result)
			if not is_success(actor_controller):
				throw_error(stack_error(actor_controller, "Could not load actor controller for the move statement."))
				return
			# TODO: Add rotation and scaling for move statement.
			actor_controller.actor_mover.move(target_position_result, null, null, travel_curve_result, duration_result)
			
			_finish_execute()
		else:
			throw_error(error("Expected an actor for the move statement."))
			return
	else:
		throw_error(error("Expected an actor for the move statement."))
		return
	

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MOVE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tactor: "
	string += "\n" + tabs_string + "\t{"
	string += actor.debug_string(tabs_string + "\t\t")
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
	
	actor.propagate_call(method, arguments, parent_first)
	target_position.propagate_call(method, arguments, parent_first)
	if travel_curve != null:
		travel_curve.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["actor"] = actor.serialize()
	serialized_object["target_position"] = target_position.serialize()
	if travel_curve != null:
		serialized_object["travel_curve"] = travel_curve.serialize()
	if duration != null:
		serialized_object["duration"] = duration.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.actor = SerializationUtils.deserialize(serialized_object["actor"])
	instance.target_position = SerializationUtils.deserialize(serialized_object["target_position"])
	if serialized_object.has("travel_curve"):
		instance.travel_curve = SerializationUtils.deserialize(serialized_object["travel_curve"])
	if serialized_object.has("duration"):
		instance.duration = SerializationUtils.deserialize(serialized_object["duration"])
	
	return instance

# ----- Serialization ----- #

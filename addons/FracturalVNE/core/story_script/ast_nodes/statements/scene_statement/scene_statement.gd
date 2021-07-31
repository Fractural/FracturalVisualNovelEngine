extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Transitions to a BGScene.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("scene")
	return arr

# ----- Typeable ----- #


const SceneTransitionAction = preload("res://addons/FracturalVNE/core/scene/scene_transition_action.gd")

var scene
var animation


func _init(position_, scene_, animation_).(position_):
	scene = scene_
	animation = animation_


func execute():
	var scene_result = scene.evaluate()
	if not is_success(scene_result) or not (scene_result is PackedScene or scene_result is Texture):
		throw_error(stack_error(scene_result, "Expected a valid PackedScene or Texture for the scene statement."))


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SCENE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tSCENE: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + scene.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if animation != null:
		string += "\n" + tabs_string + "\tANIMATION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + animation.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	scene.propagate_call(method, arguments, parent_first)
	if animation != null:
		animation.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)

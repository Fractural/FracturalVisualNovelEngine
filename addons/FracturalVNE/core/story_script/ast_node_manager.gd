extends Node

# ----- StoryService Info ----- #

var program_node

func get_service_name():
	return "ASTNodeManager"

func configure_service(program_node_):
	program_node = program_node_
	curr_reference_id = 0

# --- StoryService Info End --- #





var _results = []
var curr_reference_id = 0

func _add_result(node):
	_results.append(node)

func find_node_with_id(reference_id):
	_results = []
	program_node.propagate_call("find_node_with_id", [reference_id])
	if _results.size() == 0:
		return null
	return _results[0]

func next_reference_id():
	curr_reference_id += 1
	return curr_reference_id - 1

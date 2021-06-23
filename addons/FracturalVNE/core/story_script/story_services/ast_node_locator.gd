extends Node
# Responsible for searching a story tree for a specific node that has
# a specific id.


# ----- StoryService ----- #

var program_node

func get_service_name():
	return "ASTNodeLocator"

func configure_service(program_node_):
	program_node = program_node_

# --- StoryService --- #


var _results = []

func _add_result(node):
	_results.append(node)


func find_node_with_id(reference_id):
	_results = []
	program_node.propagate_call("find_node_with_id", [reference_id])
	if _results.size() == 0:
		return null
	return _results[0]

extends Node
# Responsible for searching a story tree for a specific node that has
# a specific id.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptService", get_service_name(), "ASTVisitor"]

# ----- Typeable ----- #


# ----- StoryService ----- #

func get_service_name():
	return "ASTNodeLocator"

func configure_service(program_node_):
	set_program_node(program_node_)

# --- StoryService --- #


var program_node: WeakRef setget set_program_node, get_program_node

var _results = []
var _target_reference_id: int


func set_program_node(value):
	program_node = weakref(value)


func get_program_node():
	if program_node != null:
		return program_node.get_ref()


# Visiting is really inefficient (O(n) complexity) where
# n is the size of the AST.
#
# TODO DISCUSS: Refactor the search to cache the entire AST
#				in a dictionary and then just perform lookups
func find_node_with_id(reference_id: int):
	_results = []
	_target_reference_id = reference_id
	get_program_node().propagate_call("accept_visitor", [self])
	if _results.size() == 0:
		return null
	return _results[0]


func visit(node):
	if node.reference_id == _target_reference_id:
		_results.append(node)


func _add_result(node):
	_results.append(node)

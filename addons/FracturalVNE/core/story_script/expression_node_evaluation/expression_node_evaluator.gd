extends Reference
# Used to evaluate expression nodes at runtime, returning errors if there
# are any.


# ----- StoryService ----- #

func get_service_name():
	return "ExpressionNodeEvaluator"

# ----- StoryService ----- #


const ObjectEvaluatorConstants = preload("object_evaluator_constants.gd")
const StoryScriptError = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")
const StoryScriptUtils = preload("res://addons/FracturalVNE/core/story_script/story_script_utils.gd")
const FracUtils = preload("res://addons/FracturalVNE/core/utils/utils.gd")

var evaluators_dict = ObjectEvaluatorConstants.new().EVALUATORS_DICT


func evaluate(type_name: String, expression_node):
	assert(FracUtils.is_type(expression_node, "expression"))
	if evaluators_dict.has(type_name):
		return evaluators_dict[type_name].evaluate(self, expression_node)
	
	# There is no dedicated evaluator for this type.
	# Just evaluate the expression and use a simple type check instead.
	var result = expression_node.evaluate()
	if not is_success(result):
		return result
	if not FracUtils.is_type(result, type_name):
		return error("Expected the type %s." % type_name)
	return result


func is_success(result):
	return StoryScriptUtils.is_success(result)


func error(message, position = null, confidence = 0):
	return StoryScriptUtils.error(message, position, confidence)

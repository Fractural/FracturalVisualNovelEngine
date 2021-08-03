extends "res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluator.gd"
# Attempts to get a Visual from an expression node.


func get_evaluate_type():
	return "Number"


func evaluate(evaluator, object):
	var result = object.evaluate()
	if not evaluator.is_success(result):
		return result
	
	if result is float or result is int:
		return result
	else:
		return evaluator.error("Expected a number (float or int).")

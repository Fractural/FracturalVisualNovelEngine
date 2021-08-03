extends "res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluator.gd"
# Attempts to get an Actor from an expression node


func get_evaluate_type():
	return "Actor"


func evaluate(evaluator, object):
	var result = object.evaluate()
	if not evaluator.is_success(result):
		return result
	
	if result is Object:
		if FracUtils.is_type(result, "Character"):
			result = result.visual
		
		if not FracUtils.is_type(result, "Actor"):
			return evaluator.error("Expected an Actor.")
		return result
	else:
		return evaluator.error("Expected an Actor.")

extends "res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluator.gd"
# Attempts to get a Visual from an expression node.


func get_evaluate_type():
	return "MultiVisual"


func evaluate(evaluator, object):
	var result = object.evaluate()
	if not evaluator.is_success(result):
		return result
	
	if result is Object:
		if FracUtils.is_type(result, "Character"):
			result = result.visual
		
		if not FracUtils.is_type(result, "MultiVisual"):
			return evaluator.error("Expected a MultVisual.")
		return result
	else:
		return evaluator.error("Expected a MultVisual.")

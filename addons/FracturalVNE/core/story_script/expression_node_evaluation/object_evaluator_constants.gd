extends Reference


const ActorEvaluator = preload("res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluators/actor_evaluator.gd")
const VisualEvaluator = preload("res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluators/visual_evaluator.gd")
const MultiVisualEvaluator = preload("res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluators/multi_visual_evaluator.gd")
const NumberEvaluator = preload("res://addons/FracturalVNE/core/story_script/expression_node_evaluation/object_evaluators/number_evaluator.gd")

var EVALUATORS = [
	ActorEvaluator.new(),
	VisualEvaluator.new(),
	MultiVisualEvaluator.new(),
	NumberEvaluator.new(),
]

var EVALUATORS_DICT: Dictionary

func _init():	
	for evaluator in EVALUATORS:
		EVALUATORS_DICT[evaluator.get_evaluate_type()] = evaluator

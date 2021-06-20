class_name StoryScriptConstants
extends Reference

# Expression Components
const FloatLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/float_literal_construct.gd")
const IntegerLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/integer_literal_construct.gd")
const StringLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/string_literal_construct.gd")
const FunctionCall = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/function_call_construct.gd")
const ParenthesizedArguments = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_arguments_construct.gd")
const ParenthesizedParameters = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_parameters_construct.gd")
const ParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression_construct.gd")
const VariableGet = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/variable_construct.gd")

# Expressions
const Expression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_construct.gd")
const ExpressionComponent = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component_construct.gd")

# Constant Expressions
const ConstantParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/constant_parenthesized_expression_construct.gd")
const ConstantExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/constant_expression_construct.gd")
const ConstantExpressionComponent = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/constant_expression_component_construct.gd")

# Binary Operators
const AddOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/add_operator_construct.gd")
const SubtractOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/subtract_operator_construct.gd")
const MultiplyOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/multiply_operator_construct.gd")
const DivideOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/division_operator_construct.gd")

# Unary Operators
const FlipSignOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/flip_sign_operator_construct.gd")
const NegateOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/negate_operator_construct.gd")

# Misc
const Block = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_construct.gd")
const Program = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_construct.gd")

# Statements
const JumpStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/jump_statement_construct.gd")
const LabelStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/label_statement_construct.gd")
const VariableDeclaration = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_declaration_construct.gd")
const VariableAssignment = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_assignment_construct.gd")
const SayStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/say_statement_construct.gd")
const ExpressionStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/expression_statement_construct.gd")

var CONSTRUCTS = [
	# Value Components
	FloatLiteral.new(),
	IntegerLiteral.new(),
	StringLiteral.new(),
	FunctionCall.new(),
	
	# Parenthesized
	ParenthesizedArguments.new(),
	ParenthesizedParameters.new(),
	ParenthesizedExpression.new(),
	ConstantParenthesizedExpression.new(),
	
	VariableGet.new(),
	
	# Blocks
	Block.new(),
	Program.new(),
	
	# Statements
	JumpStatement.new(),
	LabelStatement.new(),
	VariableDeclaration.new(),
	VariableAssignment.new(),
	SayStatement.new(),
	ExpressionStatement.new(),
]

var CONSTRUCTS_DICT: Dictionary

func _init():
	var binary_operators = [
			AddOperator.new(),
			SubtractOperator.new(),
			MultiplyOperator.new(),
			DivideOperator.new(),
		]
	
	var unary_operators = [
			FlipSignOperator.new(),
			NegateOperator.new(),
		]
	
	for operator in binary_operators:
		CONSTRUCTS.append(operator)
	
	for operator in unary_operators:
		CONSTRUCTS.append(operator)
	
	CONSTRUCTS.append_array([
		Expression.new(),
		ExpressionComponent.new(),
		ConstantExpression.new(),
		ConstantExpressionComponent.new(),
	])
	
	for construct in CONSTRUCTS:
		for type in construct.get_parse_types():
			if CONSTRUCTS_DICT.has(type):
				CONSTRUCTS_DICT[type].append(construct)
			else:
				CONSTRUCTS_DICT[type] = [construct]

class_name StoryScriptConstants
extends Reference

# Expression Components
const FloatLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/float_literal/float_literal_construct.gd")
const IntegerLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/integer_literal/integer_literal_construct.gd")
const StringLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/string_literal/string_literal_construct.gd")
const FunctionCall = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/function_call/function_call_construct.gd")
const ParenthesizedArguments = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_arguments/parenthesized_arguments_construct.gd")
const ParenthesizedParameters = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_parameters/parenthesized_parameters_construct.gd")
const ParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression/parenthesized_expression_construct.gd")
const VariableGet = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/variable/variable_construct.gd")

# Expressions
const Expression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression/expression_construct.gd")
const ExpressionComponent = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component/expression_component_construct.gd")

# Constant Expressions
const ConstantParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_parenthesized_expression/constant_parenthesized_expression_construct.gd")
const ConstantExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_expression/constant_expression_construct.gd")
const ConstantExpressionComponent = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_expression_component/constant_expression_component_construct.gd")

# Binary Operators
const AddOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/add_operator/add_operator_construct.gd")
const SubtractOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/subtract_operator/subtract_operator_construct.gd")
const MultiplyOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/multiply_operator/multiply_operator_construct.gd")
const DivideOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/division_operator/division_operator_construct.gd")

# Unary Operators
const FlipSignOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/flip_sign_operator/flip_sign_operator_construct.gd")
const NegateOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/negate_operator/negate_operator_construct.gd")

# Misc
const Block = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_construct.gd")
const Program = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node/program_construct.gd")

# Statements
const JumpStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/jump_statement/jump_statement_construct.gd")
const LabelStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/label_statement/label_statement_construct.gd")
const VariableDeclaration = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_declaration/variable_declaration_construct.gd")
const VariableAssignment = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_assignment/variable_assignment_construct.gd")
const SayStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/say_statement/say_statement_construct.gd")
const ShowStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/show_statement/show_statement_construct.gd")
const ExpressionStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/expression_statement/expression_statement_construct.gd")

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
	ShowStatement.new(),
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

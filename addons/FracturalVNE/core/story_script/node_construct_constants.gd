extends Reference

# Expression Components
const FloatLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/float_literal/float_literal_construct.gd")
const IntegerLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/integer_literal/integer_literal_construct.gd")
const StringLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/string_literal/string_literal_construct.gd")
const BoolLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/bool_literal/bool_literal_construct.gd")
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
const AddOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/addition_operator/addition_operator_construct.gd")
const SubtractOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/subtraction_operator/subtraction_operator_construct.gd")
const MultiplyOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/multiplication_operator/multiplication_operator_construct.gd")
const DivideOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/division_operator/division_operator_construct.gd")

const EqualityOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/equality_operator/equality_operator_construct.gd")
const InequalityOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/inequality_operator/inequality_operator_construct.gd")
const GreaterThanOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/greater_than_operator/greater_than_operator_construct.gd")
const GreaterThanOrEqualOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/greater_than_or_equal_operator/greater_than_or_equal_operator_construct.gd")
const LessThanOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/less_than_operator/less_than_operator_construct.gd")
const LessThanOrEqualOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/less_than_or_equal_operator/less_than_or_equal_operator_construct.gd")

# Unary Operators
const FlipSignOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/flip_sign_operator/flip_sign_operator_construct.gd")
const NegateOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/negate_operator/negate_operator_construct.gd")

# Misc
const Block = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_construct.gd")
const ProgramBlock = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node/program_block_construct.gd")

# Statements
const JumpStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/jump_statement/jump_statement_construct.gd")
const LabelStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/label_statement/label_statement_construct.gd")
const VariableDeclaration = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_declaration/variable_declaration_construct.gd")
const VariableAssignment = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_assignment/variable_assignment_construct.gd")
const SayStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/say_statement/say_statement_construct.gd")
const ShowStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/show_statement/show_statement_construct.gd")
const HideStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/hide_statement/hide_statement_construct.gd")
const AnimateStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/animate_statement/animate_statement_construct.gd")
const PauseStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/pause_statement/pause_statement_construct.gd")
const MoveStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/move_statement/move_statement_construct.gd")
const SceneStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/scene_statement/scene_statement_construct.gd")
const SoundStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/sound_statement/sound_statement_construct.gd")
const ImportStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/import_statement/import_statement_construct.gd")
const IfStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/if_statement/if_statement_construct.gd")
const ChoiceStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/choice_statement/choice_statement_construct.gd")
const ChoiceOptionNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/choice_statement/choice_option_node/choice_option_construct.gd")
const PassStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/pass_statement/pass_statement_construct.gd")
const FullTransitionStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/full_transition_statement/full_transition_statement_construct.gd")
const RemoveStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/remove_statement/remove_statement_construct.gd")
const ExpressionStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/expression_statement/expression_statement_construct.gd")

var CONSTRUCTS = [
	# Value Components
	FloatLiteral.new(),
	IntegerLiteral.new(),
	StringLiteral.new(),
	BoolLiteral.new(),
	FunctionCall.new(),
	
	# Parenthesized
	ParenthesizedArguments.new(),
	ParenthesizedParameters.new(),
	ParenthesizedExpression.new(),
	ConstantParenthesizedExpression.new(),
	
	VariableGet.new(),
	
	# Blocks
	Block.new(),
	ProgramBlock.new(),
	
	# Statements
	JumpStatement.new(),
	LabelStatement.new(),
	VariableDeclaration.new(),
	VariableAssignment.new(),
	SayStatement.new(),
	ShowStatement.new(),
	HideStatement.new(),
	AnimateStatement.new(),
	PauseStatement.new(),
	MoveStatement.new(),
	SceneStatement.new(),
	SoundStatement.new(),
	ImportStatement.new(),
	IfStatement.new(),
	ChoiceStatement.new(),
	ChoiceOptionNode.new(),
	PassStatement.new(),
	FullTransitionStatement.new(),
	RemoveStatement.new(),
	ExpressionStatement.new(),
]

var CONSTRUCTS_DICT: Dictionary


func _init():
	var binary_operators = [
			AddOperator.new(),
			SubtractOperator.new(),
			MultiplyOperator.new(),
			DivideOperator.new(),
			
			EqualityOperator.new(),
			InequalityOperator.new(),
			GreaterThanOperator.new(),
			GreaterThanOrEqualOperator.new(),
			LessThanOperator.new(),
			LessThanOrEqualOperator.new(),
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

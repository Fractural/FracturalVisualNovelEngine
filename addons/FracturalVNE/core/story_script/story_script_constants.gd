class_name StoryScriptConstants
extends Reference

# Expression Components
const FloatLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/float_literal_parser.gd")
const IntegerLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/integer_literal_parser.gd")
const StringLiteral = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/string_literal_parser.gd")
const ParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression_parser.gd")
const FunctionCall = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/function_call_parser.gd")

# Expressions
const Expression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_parser.gd")
const ExpressionComponent = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component_parser.gd")

# Binary Operators
const AddOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/add_operator_parser.gd")
const SubtractOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/subtract_operator_parser.gd")
const MultiplyOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/multiply_operator_parser.gd")
const DivideOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/division_operator_parser.gd")

# Unary Operators
const FlipSignOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/flip_sign_operator_parser.gd")
const NegateOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/negate_operator_parser.gd")

# Misc
const Block = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_parser.gd")
const Program = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_parser.gd")

# Statements
const JumpStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/jump_statement_parser.gd")
const LabelStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/label_statement_parser.gd")
const VariableDeclaration = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_declaration.gd")

var CONSTRUCTS = [
	FloatLiteral.new(),
	IntegerLiteral.new(),
	StringLiteral.new(),
	ParenthesizedExpression.new(),
	
	Expression.new(self, []),
	ExpressionComponent.new(self, []),
	
	Block.new(),
	Program.new(),
	
	JumpStatement.new(),
	LabelStatement.new(),
	VariableDeclaration.new(),
]

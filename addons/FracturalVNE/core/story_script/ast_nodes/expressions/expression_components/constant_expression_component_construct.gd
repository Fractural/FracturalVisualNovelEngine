extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("constant expression component")
	return arr

# Overrides expression component to only include constant values (which are only literals at the moment).
# Parses unary operators.
func parse(parser):
	var checkpoint = parser.save_reader_state()
	var pre_unary = parser.expect("pre unary operator")
	if parser.is_success(pre_unary):
		var expression = parser.expect("constant expression component")
		if parser.is_success(expression):
			pre_unary.operand = expression
			return pre_unary
		else:
			return parser.error(expression, 0, checkpoint)
	else:
		var value = parser.expect("constant value component")
		if parser.is_success(value):
			var previous_unary = null
			# Chaining together post unary operators
			while true:
				var post_unary = parser.expect("post unary operator")
				if not parser.is_success(post_unary):
					break
				if previous_unary == null:
					# If we are in our first post_unary operator,
					# then assign this operator the actual value component.
					post_unary.operand = value
				else:
					# Otherwise, bind the previous unary operator 
					# to the current operator.
					#
					# This means post_unary operators are evaluated from
					# left to right with the leftmost post unary operator 
					# having the highest precedence.
					post_unary.operand = previous_unary
				previous_unary = post_unary
			# If there were no unary operators, 
			# then return the expression as is.
			return value
		else:
			return parser.error(value, value.confidence, checkpoint)
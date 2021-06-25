class_name FracturalUtils
extends Reference


# define a constant that maps the type ID to the string for it's name.
# we won't need to include TYPE_OBJECT since we will handle it differently.
const TYPE_STR_MAPPING = {
	TYPE_NIL: "Null",
	TYPE_INT: "int",
	TYPE_REAL: "float",
	TYPE_STRING: "String",
}


# Declare a function to determine the name of the type.
# Because we need nothing but the constant and the parameter,
# we do not need state information, so we should make this a static function.
static func get_type_name(p_value):
	# check the type of the value given to us
	match typeof(p_value):
		# If it's an Object, return Object.get_class().
		# Will work for Node, Resource, etc.
		TYPE_OBJECT:
			return p_value.get_class()
		# For every other type, return our custom mapped string.
		_:
			return TYPE_STR_MAPPING[typeof(p_value)]


# Snakecase conversions source:
# https://gist.github.com/me2beats/443b40ba79d5b589a96a16c565952419

static func snake2camel(string: String) -> String:
	var result = PoolStringArray()
	var prev_is_underscore = false
	for ch in string:
		if ch=='_':
			prev_is_underscore = true
		else:
			if prev_is_underscore:
				result.append(ch.to_upper())
			else:
				result.append(ch)
			prev_is_underscore = false


	return result.join('')


static func snake2pascal(string: String) -> String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result


static func camel2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())

	return result.join('')


static func pascal2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')

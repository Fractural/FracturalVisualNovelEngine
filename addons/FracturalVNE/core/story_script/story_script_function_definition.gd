extends Reference


var name: String
var parameters = []
var stepped_as_statement: bool


func _init(name_: String, parameters_: Array = [], stepped_as_statement_: bool = false):
	name = name_
	parameters = parameters_
	stepped_as_statement = stepped_as_statement_

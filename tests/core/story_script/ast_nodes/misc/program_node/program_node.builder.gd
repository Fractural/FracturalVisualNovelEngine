extends Node
# Builds a ProgramNode for testing.


const FracUtils = FracVNE.Utils
const ProgramNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node/program_node.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_node.gd")
const BlockNodeBuilder = preload("res://tests/core/story_script/ast_nodes/misc/block_node/block_node.builder.gd")

var auto_init_post: bool = false
var auto_runtime_initialize: bool = false

var block
var services: Array

var program_node


func build():
	program_node = ProgramNode.new(block)
	for service in services:
		program_node.add_service(service)
	if auto_init_post:
		program_node._init_post()
	if auto_runtime_initialize:
		program_node.start_runtime_initialize()
	return program_node


func auto_init_post():
	auto_init_post = true
	return self


func auto_runtime_initialize():
	auto_runtime_initialize = true
	return self


func inject_block(block_: Array):
	FracUtils.try_free(block)
	block = block_
	return self


func inject_services(services_: Array):
	FracUtils.try_free(services)
	services = services_
	return self


# Used to quickly test a single statement
func default_test_statement(direct, statement, services = []):
	default_test_statements(direct, [statement], services)


# Used to quickly test a group of statements
func default_test_statements(direct, statement: Array, services = []):
	inject_block(BlockNodeBuilder.new().default(direct) \
		.inject_statements(statement) \
		.build())
	inject_services(services)
	auto_init_post()
	auto_runtime_initialize()


func default(direct):
	inject_block(direct.script_blank(BlockNode))
	inject_services([])
	return self

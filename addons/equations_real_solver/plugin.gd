@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("Equation", "res://addons/equations_real_solver/equations.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("Equation")

tool
extends "res://src/StateMachine/State.gd"


func _get_configuration_warning() -> String:
	var warning := ""
	#if owner != Ship:
	#	warning = "L''owner' de l'estat no és una tropa"
	return warning


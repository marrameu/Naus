extends Node

var pitch := 0.0
var yaw := 0.0
var roll := 0.0
var strafe := 0.0
var throttle := 0.0
export(float, -1, 1) var MIN_THROTTLE := 0.3

var can_turbo = false
var recover_turbo := false
var turboing := false


var MAX_TURBO_TIME := 5.0
var turbo_time := MAX_TURBO_TIME


func _on_TurboTimer_timeout():
	pass # Replace with function body.

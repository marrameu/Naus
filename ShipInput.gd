extends Node

var pitch := 0.0
var yaw := 0.0
var roll := 0.0
var strafe := 0.0
var throttle := 0.0
export(float, -1, 1) var MIN_THROTTLE := 0.3

# TURBO
var TURBO_RECHARGE_TIME := 3.0
var MAX_AVALIABLE_TURBOS : int = 5
var avaliable_turbos : int = 0

var turboing := false
var wants_turbo = false


func _process(delta):
	_recover_turbo()


func _on_ReloadTurboTimer_timeout():
	avaliable_turbos = clamp(avaliable_turbos + 1, 0, MAX_AVALIABLE_TURBOS)


func _recover_turbo():
	if MAX_AVALIABLE_TURBOS == avaliable_turbos or wants_turbo:
		$ReloadTurboTimer.stop()
	else:
		if $ReloadTurboTimer.is_stopped():
			$ReloadTurboTimer.start()
		$ReloadTurboTimer.wait_time = TURBO_RECHARGE_TIME


func _on_DrainTurboTimer_timeout():
	avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)

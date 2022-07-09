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
var do_turbo = false
var drifting := false
var wants_turbo := false
var wants_drift := false


func _process(delta):
	_recover_turbo()
	
	# BLOC 1
	if drifting:
		if wants_turbo and avaliable_turbos:
			drifting = false
			$DriftTimer.stop() # per evitar possibles problemes
			do_turbo = true
	
	# BLOC 2 (ha d'anar sempre després, si no amb el comandament s'activa el turbo immediatament)
	if not turboing:
		if wants_turbo and avaliable_turbos:
			do_turbo = true
			$TurboAudio.play()
	else:
		if wants_drift:
			drifting = true
			do_turbo = false
			$DriftAudio.play()
		# drifting = Input.is_action_pressed(drift_action) # just?
	
	if not drifting: # aquesta comprovació potser sorba una mica
		if turboing and do_turbo: # espera q arribi a turboing
			if $DrainTurboTimer.is_stopped():
				$DrainTurboTimer.start()
	else:
		if $DriftTimer.is_stopped():
			$DriftTimer.start() # fer-ho per temps o quan la vel arribi a gairebé 0
		if not $DrainTurboTimer.is_stopped():
			$DrainTurboTimer.stop()
			avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)


func _on_ReloadTurboTimer_timeout():
	avaliable_turbos = clamp(avaliable_turbos + 1, 0, MAX_AVALIABLE_TURBOS)


func _recover_turbo():
	if MAX_AVALIABLE_TURBOS == avaliable_turbos or do_turbo or turboing:
		$ReloadTurboTimer.stop()
	else:
		if $ReloadTurboTimer.is_stopped():
			$ReloadTurboTimer.start()
		$ReloadTurboTimer.wait_time = TURBO_RECHARGE_TIME


func _on_DrainTurboTimer_timeout():
	avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)
	do_turbo = wants_turbo and avaliable_turbos


func _on_DriftTimer_timeout():
	drifting = false

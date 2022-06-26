extends "res://ShipInput.gd"

signal activated_turboing

const THROTTLE_SPEED := 2.5
const ROLL_SPEED := 2.5

var mouse_input := Vector2()
var input_device : int

var move_right_action := "move_right"
var move_left_action := "move_left"
var move_forward_action := "move_forward"
var move_backward_action := "move_backward"

var camera_down_action := "camera_down"
var camera_up_action := "camera_up"
var camera_left_action := "camera_left"
var camera_right_action := "camera_right"

var turbo_action := "turbo"
var drift_action := "drift"
var zoom_action := "zoom"

var zooming := false


func _process(delta : float) -> void:
	roll = clamp(lerp(roll, (Input.get_action_strength(move_right_action) - 
		Input.get_action_strength(move_left_action)), delta * ROLL_SPEED), -1, 1)
	
	wants_turbo = Input.is_action_pressed(turbo_action) and avaliable_turbos
	if turboing:
		drifting = Input.is_action_pressed(drift_action) # just?
	
	if not drifting:
		if turboing and wants_turbo:
			if $DrainTurboTimer.is_stopped():
				$DrainTurboTimer.start()
		elif turboing and not wants_turbo: # player has stopped pressing or run out of turbos
			if not $DrainTurboTimer.is_stopped():
				$DrainTurboTimer.stop()
				avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)
		else:
			_recover_turbo()
	else:
		if $DriftTimer.is_stopped():
			$DriftTimer.start()
		if not $DrainTurboTimer.is_stopped():
			$DrainTurboTimer.stop()
			avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)
		drifting = Input.is_action_pressed(drift_action)
		if not drifting: # ha deixat de premer
			$DriftTimer.stop() # per evitar possibles problemes
	
	zooming = Input.is_action_pressed(zoom_action) and not turboing and not drifting # ferho a la cam tmb
	
	update_yaw_and_ptich()
	update_throttle(move_forward_action, move_backward_action, delta)


func update_yaw_and_ptich() -> void:
	mouse_input.x = get_node("../PlayerHUD").cursor_input.x
	mouse_input.y = -get_node("../PlayerHUD").cursor_input.y
	
	pitch = mouse_input.y if not Settings.controller_input else Input.get_action_strength(camera_down_action) - Input.get_action_strength(camera_up_action)
	yaw = -mouse_input.x if not Settings.controller_input else Input.get_action_strength(camera_left_action) - Input.get_action_strength(camera_right_action)
	
	if zooming: # fer que quan faci zoom la velocitat de girar és sempre la minima encara q sigui al mig?
		pitch /= 2
		yaw /= 2


func update_throttle(increase_action : String, decrease_action : String, delta : float) -> void:
	if drifting:
		throttle = 0.0
		turboing = false
		return
	
	var target := throttle
	var turbo_clamp := 2.0
	if wants_turbo:
		target += delta
	elif throttle > 1: # espera abans de fer el clamp, si no, baixa a 1 de cop
		target -= delta
	else:
		turbo_clamp = 1.0
		target += (Input.get_action_strength(increase_action) - Input.get_action_strength(decrease_action)) * delta
	
	target = clamp(target, MIN_THROTTLE, turbo_clamp) # TURBO_THROTTLE
	
	turboing = target > 1
	if target > 1 and throttle <= 1: # s'acaba d'activar el turbo
		emit_signal("activated_turboing", true)
	elif throttle > 1 and target <= 1:
		emit_signal("activated_turboing", false)
	
	throttle = target


func _on_DrainTurboTimer_timeout():
	avaliable_turbos = clamp(avaliable_turbos - 1, 0, MAX_AVALIABLE_TURBOS)
	$TurboSwitchAudio.play()


"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_player_input()


func set_player_input() -> void:
	pass
	
	var ship_camera : Camera = get_node("/root/Main").players_cameras[get_parent().number_of_player - 1].ship_camera
	var player = get_node("/root/Main").local_players[get_parent().number_of_player - 1]
	if not player: # Mirar si es pot treure aquesta comporvació
		return
	input_manager = player.get_node("InputManager")
	input_map = input_manager.input_map
	
	$Player.input_device = input_manager.number_of_device
	
	$Player.move_right_action = input_map.move_right
	$Player.move_left_action = input_map.move_left
	$Player.move_forward_action = input_map.move_forward
	$Player.move_backward_action = input_map.move_backward
	
	$Player.camera_right_action = input_map.camera_right
	$Player.camera_left_action = input_map.camera_left
	$Player.camera_up_action = input_map.camera_up
	$Player.camera_down_action = input_map.camera_down
	
	get_parent().jump_action = input_map.jump
	get_node("../Shooting").shoot_action = input_map.shoot
	get_node("../Shooting").zoom_action = input_map.zoom
	
	ship_camera.input_device = input_manager.number_of_device
	
	ship_camera.zoom_ship_action = input_map.zoom_ship
	ship_camera.look_behind_action = input_map.look_behind
	ship_camera.camera_right_action = input_map.camera_right
	ship_camera.camera_left_action = input_map.camera_left
	ship_camera.camera_up_action = input_map.camera_up
	ship_camera.camera_down_action = input_map.camera_down
	"""


extends Node


onready var physics : ShipPhysics = get_node("../../Physics") # ¿?
onready var ship = get_node("../") # ¿?

var pitch := 0.0
var yaw := 0.0
var roll := 0.0
var strafe := 0.0
var throttle := 0.0
export(float, -1, 1) var min_throttle := 0.3

# How quickly reacts to input
# Move Towards 0.5
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


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	roll = clamp(lerp(roll, (Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)), delta * ROLL_SPEED), -1, 1)
	
	update_yaw_and_ptich()
	update_throttle(move_forward_action, move_backward_action, delta)


func update_yaw_and_ptich() -> void:
	mouse_input.x = get_node("../PlayerHUD").cursor_input.x
	mouse_input.y = -get_node("../PlayerHUD").cursor_input.y
	
	pitch = mouse_input.y #if LocalMultiplayer.number_of_players == 1 and not Settings.controller_input or input_device == -1 else Input.get_action_strength(camera_down_action) - Input.get_action_strength(camera_up_action)
	yaw = -mouse_input.x #if LocalMultiplayer.number_of_players == 1 and not Settings.controller_input or input_device == -1 else Input.get_action_strength(camera_left_action) - Input.get_action_strength(camera_right_action)


func update_throttle(increase_action : String, decrease_action : String, delta : float) -> void:
	var target := throttle
	target = clamp(Input.get_action_strength(increase_action) - Input.get_action_strength(decrease_action), min_throttle, 1)
	# Change to move_towards
	throttle = clamp(lerp(throttle, target, delta * THROTTLE_SPEED), -1, 1)

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


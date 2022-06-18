extends "res://src/Ships/ShipShooting.gd"

var shoot_action := "shoot"
var change_bullet_action := "change_bullet"


func _process(delta):
	if Input.is_action_just_released(change_bullet_action):
		if current_bullet == 0:
			current_bullet = 1
		elif current_bullet == 1:
			current_bullet = 0
	
	if Input.is_action_pressed(shoot_action) and can_shoot:
		if get_tree().has_network_peer():
			rpc("shoot", shoot_target())
		else:
			shoot(shoot_target())


func shoot_target() -> Vector3:
	# Camera
	var current_cam : Camera = get_node("/root/Level/Camera")
	var space_state = get_parent().get_world().direct_space_state
	
	var camera_width_center := 0.0
	var camera_height_center := 0.0
	var shoot_origin := Vector3()
	var shoot_normal := Vector3()
	var shoot_target := Vector3()
	
	if current_cam:
		var viewport : Viewport = get_viewport()
		"""
		if get_tree().has_network_peer():
			viewport = get_node("/root/Main/Splitscreen")._renders[0].viewport
		else:
			viewport = get_node("/root/Main/Splitscreen")._renders[get_parent().number_of_player - 1].viewport
		"""
		camera_width_center = viewport.get_visible_rect().size.x / 2
		camera_height_center = viewport.get_visible_rect().size.y / 2
		
		# TEST
		var cursor_pos = get_node("../PlayerHUD/Center/CursorPivot/Cursor").rect_position # .clamped(350)
		"""
		if LocalMultiplayer.number_of_players > 1:
			cursor_pos /= 2
		"""
		camera_width_center += cursor_pos.x
		camera_height_center += cursor_pos.y
		
		shoot_origin = current_cam.project_ray_origin(Vector2(camera_width_center, camera_height_center))
		shoot_normal = shoot_origin + current_cam.project_ray_normal(Vector2(camera_width_center, camera_height_center)) * shoot_range
		
		var result = space_state.intersect_ray(shoot_origin, shoot_normal, [get_parent()])
		if result.empty():
			var ray_dir = current_cam.project_ray_normal(Vector2(camera_width_center, camera_height_center))
			shoot_target = shoot_origin + ray_dir * shoot_range
		else:
			shoot_target = result.position
		
	return shoot_target

# fer-ho en la ship.tscn general
func _on_Input_activated_turboing(enabled):
	turboing = enabled

extends Node

class_name ShipPhysics

signal started_turboing
signal stopped_turboing

onready var ship = get_parent()

var linear_force := Vector3(0, 0, 200)
var linear_force_turbo := Vector3(0, 0, 400)
var angular_force := Vector3(90, 90, 175) / 100.0

var applied_linear_force := Vector3()
var applied_angular_force := Vector3()

var desired_linear_force := Vector3()
var desired_angular_force := Vector3()

var angular_drag := 3.5 # ¿?
var linear_drag := 5.0 # ¿?

var stabilizing := false
var stabilized := false

var descense_vel := 0.0
var DESIRED_DESCENSE_VEL := 5.0

var MAX_TURBO_TIME := 5.0
var turbo_time := MAX_TURBO_TIME

var wants_turbo := false
var can_turbo := true
var turboing = false


func _process(delta : float) -> void:
	if Input.is_action_just_pressed("test"):
		add_force(-Vector3.FORWARD * 10000, delta)
	
	add_force(applied_linear_force, delta)
	add_torque(applied_angular_force, delta) # * rotate_speed?
	
	if can_turbo and turbo_time <= 0:
		can_turbo = false
	elif not can_turbo and turbo_time > MAX_TURBO_TIME/2:
		can_turbo = true


func set_physics_input(linear_input : Vector3, angular_input : Vector3, delta):
	applied_angular_force = angular_input * angular_force
	if wants_turbo and can_turbo:
		turboing = true
		emit_signal("started_turboing")
		turbo_time = clamp(turbo_time - delta, 0, MAX_TURBO_TIME)
	else:
		turboing = false
		emit_signal("stopped_turboing")
		turbo_time = clamp(turbo_time + delta, 0, MAX_TURBO_TIME)
	applied_linear_force = linear_input * linear_force
	


func add_force(force : Vector3, delta : float):
	desired_linear_force = desired_linear_force.linear_interpolate(force, delta / linear_drag * 10)
	#desired_linear_force = desired_linear_force.move_toward(force, delta / linear_drag * 1000)
	#desired_linear_force.x = clamp(desired_angular_force.x, 0, force.x)
	#desired_linear_force.y = clamp(desired_angular_force.y, 0, force.y)
	#desired_linear_force.z = clamp(desired_angular_force.z, 0, force.z)
	ship.linear_velocity = ship.global_transform.basis.xform(desired_linear_force)


func add_torque(torque : Vector3, delta : float):
	desired_angular_force = desired_angular_force.linear_interpolate(torque, delta / angular_drag * 10)
	ship.angular_velocity = ship.global_transform.basis.xform(desired_angular_force)


func _stabilize_rotation(time : float = 2.0) -> void:
	# Calcular el temps
	time *= abs(get_parent().rotation.x) if abs(get_parent().rotation.x) > abs(get_parent().rotation.z) else abs(get_parent().rotation.z / 2)
	time += 0.25
	
	$Tween.interpolate_property(get_parent(), "rotation", get_parent().rotation, Vector3(0, get_parent().rotation.y, 0), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
	stabilizing = true

func _on_Tween_tween_all_completed():
	stabilized = true

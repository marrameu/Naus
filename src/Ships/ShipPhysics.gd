extends Node

class_name ShipPhysics

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



func _process(delta : float) -> void:
	if Input.is_action_just_pressed("test"):
		add_force(-Vector3.FORWARD * 10000, delta)
	
	add_force(applied_linear_force, delta)
	add_torque(applied_angular_force, delta) # * rotate_speed?


func set_physics_input(linear_input : Vector3, angular_input : Vector3, delta):
	var b = ship.transform.basis
	var v_len = ship.linear_velocity.length()
	var v_nor = ship.linear_velocity.normalized()
	var vel : Vector3
	vel.z = b.z.dot(v_nor) * v_len
	
	var mutiplier := 1.0
	
	if vel.z <= 100:
		mutiplier = (0.01 * vel.z) + 1
	elif vel.z <= 200: # and vel.z < 400:
		mutiplier = 3 - (0.01 * vel.z)
	
	if ship.name == "PlayerShip":
		print(mutiplier)
	
	applied_angular_force = angular_input * angular_force * mutiplier
	applied_linear_force = linear_input * linear_force
	


func add_force(force : Vector3, delta : float):
	desired_linear_force = desired_linear_force.linear_interpolate(force, delta / linear_drag * 10)
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

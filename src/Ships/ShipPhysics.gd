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

var angular_drag := 3.5
var linear_drag := 5.0 # temps en frenar/accelerar (inèrcia)
var NORMAL_LINEAR_DRAG := 5.0
var DRIFTING_LINEAR_DRAG := 10.0
#si accelera de pressa (turbo) es redreça més de pressa (lerp)

var drifting := false

var stabilizing := false
var stabilized := false

var descense_vel := 0.0
var DESIRED_DESCENSE_VEL := 5.0



func _process(delta : float) -> void:
	drifting = ship.input.drifting
	
	linear_drag = NORMAL_LINEAR_DRAG if !drifting else DRIFTING_LINEAR_DRAG
	# es canvia car aquí els motors "s'apaguen", en l'altre cas se suposa q quan els motors estan a zero
	# fan força per a frenar (aquí en egeuixen fent (si no, no pararia), però més a poc a poc)
	
	if not drifting:
		add_force(applied_linear_force, delta)
	else:
		add_force(Vector3.ZERO, delta) # apaga els motors del tot, sols roman la inèrcia
	
	add_torque(applied_angular_force, delta)


func set_physics_input(linear_input : Vector3, angular_input : Vector3, delta):
	var b = ship.transform.basis
	var v_len = ship.linear_velocity.length()
	var v_nor = ship.linear_velocity.normalized()
	var vel : Vector3
	vel.z = b.z.dot(v_nor) * v_len
	
	var mutiplier := 1.0
	
	if owner.input.throttle <= 0.5:
		mutiplier = 2 * owner.input.throttle + 1
	elif owner.input.throttle > 0.5 and owner.input.throttle <= 1.0:
		mutiplier = 3 - (2 * owner.input.throttle)
	elif owner.input.throttle > 1.0: # turbo
		mutiplier = 1.5 - (0.5 * owner.input.throttle)
	
	"""
	if vel.z <= 100:
		mutiplier = (0.01 * vel.z) + 1
	elif vel.z <= 200: # vel.z < 400 si vols que amb el turbo li costi enacra més (0.5 em pens)
		mutiplier = 3 - (0.01 * vel.z)
	"""
	
	applied_angular_force = angular_input * angular_force * mutiplier
	# lerp per a derrapar
	#var a = linear_input * linear_force
	#applied_linear_force = applied_linear_force.linear_interpolate(ship.global_transform.basis.xform(a), delta)
	
	var a = linear_input * linear_force
	applied_linear_force = a #applied_linear_force.linear_interpolate(ship.global_transform.basis.xform(a), delta)


func add_force(force : Vector3, delta : float):
	# lerp per a derrapar
	desired_linear_force = desired_linear_force.linear_interpolate(ship.global_transform.basis.xform(force), delta / linear_drag * 10)
	# lerp per a accelerar/frenar
	# desired_linear_force = desired_linear_force.linear_interpolate(desired_linear_force, delta / linear_drag * 10)
	ship.linear_velocity = desired_linear_force
	
	var b = owner.transform.basis
	var v_len = owner.linear_velocity.length()
	var v_nor = owner.linear_velocity.normalized()
	var vel : Vector3
	vel.z = b.z.dot(v_nor) * v_len
	vel.x = b.x.dot(v_nor) * v_len
	vel.y = b.y.dot(v_nor) * v_len
	get_node("../Pito").translation = vel


func add_torque(torque : Vector3, delta : float):
	#if drifting:
	#	torque *= DRIFTING_TORQUE_MULTIPLIER
	
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

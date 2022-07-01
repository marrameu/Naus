extends "AIShipState.gd"


func enter():
	# turbo
	owner.input.des_throttle = 1
	owner.input.target = owner.translation + Vector3(rand_range(-500, 500), rand_range(-500, 500), rand_range(-500, 500))


func _on_HealthSystem_shield_recovered():
	emit_signal("finished", "choose_objective")

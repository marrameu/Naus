extends "res://src/Ships/ShipShooting.gd"


onready var ray : RayCast = $RayCast

var target : Spatial

var enemy_in_range := false

func _ready():
	pass


func _process(delta):
	wants_shoots[0] = false
	"""
	enemy_in_range = false
	# cal la weakref? si pot ser evitat millor
	# si ho faig amb body_entered/exited el problema esq si canvia d'enemic i l'anterior no ha sortit de l'àrea...
	if weakref(target).get_ref():
		for body in $ShootingArea.get_overlapping_bodies():
			if body == target:
				enemy_in_range = true
		if can_shoot and enemy_in_range:
			wants_shoot = true
			if get_tree().has_network_peer():
				rpc("shoot", target.translation)
			else:
				shoot(target.translation)
	"""
	# cal la weakref? si pot ser evitat millor
	if weakref(target).get_ref():
		if can_shoots[0] and enemy_in_range:
			wants_shoots[0] = true
			if get_tree().has_network_peer():
				rpc("shoot", target.translation)
			else:
				shoot_bullet(0, target.translation)


func _on_ShootingArea_body_entered(body):
	if body == target:
		enemy_in_range = true


func _on_ShootingArea_body_exited(body):
	if body == target:
		enemy_in_range = false

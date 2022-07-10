extends "res://src/Ships/ShipShooting.gd"


onready var ray : RayCast = $RayCast

var target : Spatial

var enemy_in_range := false

func _ready():
	pass


func _physics_process(delta):
	pass
	#if $RayCast.is_colliding():
	#	enemy_in_range = $RayCast.get_collider() == target


func _process(delta):
	enemy_in_range = false
	# cal la weakref? si pot ser evitat millor
	# si ho faig amb body_entered/exited el problema esq si canvia d'enemic i l'anterior no ha sortit de l'àrea...
	if weakref(target).get_ref():
		for body in $ShootingArea.get_overlapping_bodies():
			if body == target:
				enemy_in_range = true
	
	# cal la weakref? si pot ser evitat millor
	if weakref(target).get_ref():
		if enemy_in_range:
			for value in wants_shoots:
				if wants_shoots[value] and can_shoots[value]:
					if get_tree().has_network_peer():
						rpc("shoot", target.translation)
					else:
						shoot_bullet(value, target.translation)


func _on_ShootingArea_body_entered(body):
	return
	if body == target:
		enemy_in_range = true


func _on_ShootingArea_body_exited(body):
	return
	if body == target:
		enemy_in_range = false

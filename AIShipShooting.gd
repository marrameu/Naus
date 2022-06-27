extends "res://src/Ships/ShipShooting.gd"


onready var ray : RayCast = $RayCast

var target : Spatial

var enemy_in_range := false

func _ready():
	pass
	"""
	if owner.pilot_man.blue_team:
		target = get_node("/root/Level/BigShipRed")
	else:
		target = get_node("/root/Level/BigShipBlue")
		"""


func _process(delta):
	wants_shoot = false
	# cal la weakref? si pot ser evitat millor
	if weakref(target).get_ref():
		if can_shoot and enemy_in_range:
			wants_shoot = true
			if get_tree().has_network_peer():
				rpc("shoot", target.translation)
			else:
				shoot(target.translation)


func _on_ShootingArea_body_entered(body):
	if body == target:
		enemy_in_range = true


func _on_ShootingArea_body_exited(body):
	if body == target:
		enemy_in_range = false

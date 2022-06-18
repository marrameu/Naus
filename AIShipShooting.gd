extends "res://src/Ships/ShipShooting.gd"


onready var ray : RayCast = $RayCast

var target : Spatial


func _ready():
	if owner.pilot_man.blue_team:
		target = get_node("/root/Level/BigShipRed")
	else:
		target = get_node("/root/Level/BigShipBlue")


func _process(delta):
	if ray.is_colliding() and ray.get_collider() == target and can_shoot_pri:
		if get_tree().has_network_peer():
			rpc("shoot")
		else:
			shoot()

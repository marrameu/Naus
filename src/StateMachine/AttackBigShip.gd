extends "AIShipState.gd"

var enemy_bs : Spatial
var attack_rel_pos : Vector3

var get_away_from_the_enemy := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter():
	print(owner, " entered ", name)
	
	enemy_bs = owner.shooting.target


func update(delta):
	if not weakref(enemy_bs).get_ref():
		emit_signal("finished", "choose_objective")
		return
	
	if not get_away_from_the_enemy:
		if owner.translation.distance_to(enemy_bs.translation) < 500:
			owner.input.target = owner.translation + attack_rel_pos
			get_away_from_the_enemy = true
			change_rel_pos()
		else:
			owner.input.des_throttle = 0.7
			owner.input.target = enemy_bs.translation
	else:
		owner.input.des_throttle = 1.0
		if owner.translation.distance_to(owner.input.target) < 250:
			get_away_from_the_enemy = false


func change_rel_pos():
	var x : float = rand_range(-1000, -500) if randi() % 2 else rand_range(500, 1000)
	var y : float = rand_range(-1000, -500) if randi() % 2 else rand_range(500, 1000)
	var z : float = rand_range(-1000, -500) if randi() % 2 else rand_range(500, 1000)
	attack_rel_pos = Vector3(x, y, z)

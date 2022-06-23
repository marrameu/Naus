extends "AIShipState.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var enemy_middle_point = 0.0
var num_of_enemies = 0

var wait_to_init := true

var target := Vector3.ZERO
var x := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter():
	if wait_to_init: # q facin spawn totes les naus
		wait_to_init = false
		return
	
	for ship in get_node("/root/Level/Ships").get_children():
		if owner.pilot_man.blue_team != ship.pilot_man.blue_team:
			num_of_enemies += 1
			enemy_middle_point += ship.translation.x
	enemy_middle_point /= num_of_enemies
	# potser amb dir-li 1000/-1000 n'hi ha prou 
	
	target.y = rand_range(-150, 150)
	target.z = rand_range(-150, 150)
	x = rand_range(-150, 150)
	
	target.x = enemy_middle_point + x
	
	owner.get_node("Input").target = target
	emit_signal("finished", "attack_enemies")


func update(_delta):
	pass
	"""
	for ship in get_node("/root/Level/Ships").get_children():
		if owner.pilot_man.blue_team != ship.pilot_man.blue_team:
			num_of_enemies += 1
			enemy_middle_point += ship.translation.x
	enemy_middle_point /= num_of_enemies
	
	target.z = enemy_middle_point + z
	
	owner.get_node("Input").target = target
	"""

func _on_InitTimer_timeout():
	wait_to_init = false
	enter()

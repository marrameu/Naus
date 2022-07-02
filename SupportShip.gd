extends "res://BigShip.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blue_team != PlayerInfo.player_blue_team:
		$SupportArea.hide()


func _physics_process(delta):
	# en funció de l'estat de la partida o(1 o 2 [o sigui]) la línia
	#move_and_collide(Vector3(10 * delta, 0, 0))
	pass


func _on_SupportArea_body_entered(body):
	if body is Ship:
		if body.pilot_man.blue_team == blue_team:
			body.get_node("HealthSystem").heal(99999999)
			body.get_node("HealthSystem").heal_shield(9999999)
			var a : int = 0
			for value in body.shooting.ammos:
				body.shooting.ammos[a] = body.shooting.MAX_AMMOS[a]
				if body.shooting.ease_ammos[a]:
					body.shooting.not_eased_ammos[a] = body.shooting.MAX_AMMOS[a]
				a += 1


func _on_SupportArea_body_exited(body):
	pass # Replace with function body.

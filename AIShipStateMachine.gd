extends "res://src/StateMachine/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# si no és el servidor que es desactivi l'state machine (active) o crear un estat Client
	states_map = {
		"chose_objective": $ChoseObjective,
		"attack_enemies": $AttackEnemies,
		#"dead": $Dead
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

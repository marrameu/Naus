extends Ship

signal enemy_attack_ship_shields_down

var battle_man


# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.set_active(true)


func _on_BigShip_shields_down(ship):
	if ship.is_in_group("AttackShips") and ship.blue_team != pilot_man.blue_team:
		emit_signal("enemy_attack_ship_shields_down")

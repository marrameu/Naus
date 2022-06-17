extends CanvasLayer


export var blue_ship : NodePath
export var red_ship : NodePath


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# fer-ho per senyals? (a la nau del jugador tmb?) o massa complciat
	update_lifebars(false)
	update_lifebars(true)


func update_lifebars(blue : bool):
	var ship = get_node(blue_ship) if blue else get_node(red_ship)
	
	if not ship:
		return
	
	var ship_health = float(ship.get_node("HealthSystem").health)
	var ship_max_health = float(ship.get_node("HealthSystem").MAX_HEALTH)
	
	var ship_shield = float(ship.get_node("HealthSystem").shield)
	var ship_max_shield = float(ship.get_node("HealthSystem").MAX_SHIELD)
	
	var time_left = ship.get_node("HealthSystem/ShieldTimer").time_left
	var wait_time = ship.get_node("HealthSystem/ShieldTimer").wait_time
	
	
	
	if blue:
		$Control/Control/LifeBarBlueShield/LifeBarBlue.value = ship_health / ship_max_health * 100
		if ship_shield:
			$Control/Control/LifeBarBlueShield.value = ship_shield / ship_max_shield * 100
		else:
			$Control/Control/LifeBarBlueShield.value = (1.0 - (time_left / wait_time)) * 100
	else:
		$Control/Control/LifeBarRedShield/LifeBarRed.value = ship_health / ship_max_health * 100
		if ship_shield:
			$Control/Control/LifeBarRedShield.value = ship_shield / ship_max_shield * 100
		else:
			$Control/Control/LifeBarRedShield.value = (1.0 - (time_left / wait_time)) * 100

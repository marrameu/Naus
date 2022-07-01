extends Spatial

const player_ship_scene : PackedScene = preload("res://PlayerShip.tscn")
const ai_ship_scene : PackedScene = preload("res://AIShip.tscn")

var ai_num := 0

# middle point
var middle_point := 0.0
var blue_point := 0.0
var num_of_blues : int = 0
var red_point := 0.0
var num_of_reds : int = 0

var RED_LIMIT = -4000
var BLUE_LIMIT = 4000


# Called when the node enters the scene tree for the first time.
func _ready():
	$WaittingCam.make_current()
	
	var x = 0
	while x < 5:
		x += 1 
		spawn_AI(ai_num, true)
		ai_num += 1
	var y = 0
	while y < 5:
		y += 1
		spawn_AI(ai_num, false)
		ai_num += 1


func _process(delta):
	if Input.is_action_just_pressed("spawn_ai"):
		spawn_AI(ai_num, randi() % 2)
		ai_num += 1
	
	
	middle_point = 0.0
	blue_point = 0.0
	num_of_blues = 0
	red_point = 0.0
	num_of_reds = 0
	
	for ship in $Ships.get_children():
		if not ship.pilot_man.blue_team:
			num_of_reds += 1
			red_point += ship.translation.x
		else:
			num_of_blues += 1
			blue_point +=  ship.translation.x
	while num_of_reds < 5:
		red_point += RED_LIMIT
		num_of_reds += 1
	while num_of_blues < 5:
		blue_point += BLUE_LIMIT
		num_of_blues += 1
	red_point /= 5
	blue_point /= 5
	middle_point = (red_point + blue_point) / 2
	$RedPoint.translation.x = red_point
	$BluePoint.translation.x = blue_point
	$MiddlePoint.translation.x = clamp(middle_point, RED_LIMIT, BLUE_LIMIT)
	$Label.text = "MIDDLE_POINT = " + str(middle_point)


func _on_BigShip_destroyed(blue_team):
	$Results/Control.show()
	if not blue_team:
		$Results/Control/RichTextLabel.show()
	else:
		$Results/Control/RichTextLabel2.show()
	# stop tot


func _on_PlayerShip_tree_exited():
	$SpawnHUD.show()
	$WaittingCam.make_current()


func _on_AIShip_tree_exited(num):
	var t = Timer.new()
	t.set_wait_time(20)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	t.connect("timeout", self, "spawn_AI", [num])
	t.connect("timeout", t, "queue_free")


func spawn_player():
	var ship = player_ship_scene.instance()
	ship.pilot_man = $PilotManagers/PlayerManager
	ship.translation = choose_spawn_position(ship.pilot_man.blue_team)
	ship.rotation_degrees.y = -90 if ship.pilot_man.blue_team else 90
	$Ships.add_child(ship)
	
	ship.connect("tree_exited", self, "_on_PlayerShip_tree_exited")
	
	$SpawnHUD/Control.hide()
	
	# cam
	#ship.get_node("Input").connect("activated_turboing", $Camera, "_on_Input_activated_turboing")
	$Camera.ship = ship
	ship.cam = $Camera
	$Camera.make_current()
	$Camera.init_cam()


func spawn_AI(number, blue_team : bool = false):
	var ship = ai_ship_scene.instance()
	
	var pilot_man : PilotManager = get_node_or_null("PilotManagers/AIManager" + str(number))
	# crea'n un de nou
	if not pilot_man:
		pilot_man = PilotManager.new()
		$PilotManagers.add_child(pilot_man)
		pilot_man.name = ("AIManager" + str(number))
		pilot_man.blue_team = blue_team
	
	ship.pilot_man = pilot_man
	
	ship.translation = choose_spawn_position(pilot_man.blue_team)
	ship.rotation_degrees.y = -90 if pilot_man.blue_team else 90
	$Ships.add_child(ship)
	
	ship.connect("ship_died", self, "_on_AIShip_tree_exited", [number])
	
	var b = true if pilot_man.blue_team else false
	var r = false if pilot_man.blue_team else true
	$BigShips/CapitalShipBlue/HealthSystem.connect("shield_die", ship.get_node("StateMachine"), "capital_ship_shield_died", [b])
	$BigShips/CapitalShipRed/HealthSystem.connect("shield_die", ship.get_node("StateMachine"), "capital_ship_shield_died", [r])


# això?! endaya
func choose_spawn_position(blue_team : bool) -> Vector3:
	if blue_team:
		return(Vector3(rand_range(BLUE_LIMIT - 50, BLUE_LIMIT + 50), rand_range(-250, -350), rand_range(-500, 500)))
	else:
		return(Vector3(rand_range(RED_LIMIT - 50, RED_LIMIT + 50), rand_range(-250, -350), rand_range(-500, 500)))
	
	"""
		# POTSER cal fer algun clamp
	if blue_team:
		var blue_spawn = (BLUE_LIMIT + middle_point) / 2
		return(Vector3(rand_range(blue_spawn - 50, blue_spawn + 50), rand_range(-50, 50), rand_range(-500, 500)))
	else:
		var red_spawn = (RED_LIMIT + middle_point) / 2
		return(Vector3(rand_range(red_spawn - 50, red_spawn + 50), rand_range(-50, 50), rand_range(-500, 500)))
	"""

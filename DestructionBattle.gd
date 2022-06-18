extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const player_ship_scene : PackedScene = preload("res://PlayerShip.tscn")
const ai_ship_scene : PackedScene = preload("res://AIShip.tscn")

var ai_num := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaittingCam.make_current()


func _process(delta):
	if Input.is_action_just_pressed("spawn_ai"):
		spawn_AI(ai_num, randi() % 2)
		ai_num += 1


func _on_BigShip_destroyed(blue_team):
	$Results/Control.show()
	if not blue_team:
		$Results/Control/RichTextLabel.show()
	else:
		$Results/Control/RichTextLabel2.show()
	# stop tot


func _on_Ship_tree_exited():
	$SpawnHUD.show()
	$WaittingCam.make_current()


func _on_SpawnHUD_respawn():
	var ship = player_ship_scene.instance()
	ship.pilot_man = $PilotManagers/PlayerManager
	$Ships.add_child(ship)
	
	ship.connect("tree_exited", self, "_on_Ship_tree_exited")
	
	$SpawnHUD/Control.hide()
	
	# cam
	$Camera.fp_target_path = ship.get_node("FPCameraPosition").get_path()
	$Camera.tp_target_path = ship.get_node("CameraPosition").get_path()
	ship.get_node("Physics").connect("started_turboing", $Camera, "_on_Physics_started_turboing")
	ship.get_node("Physics").connect("stopped_turboing", $Camera, "_on_Physics_stopped_turboing")
	$Camera.make_current()
	$Camera.init_cam()


func spawn_AI(number, blue_team : bool):
	print(blue_team)
	var ship = ai_ship_scene.instance()
	var pilot_man : PilotManager = get_node_or_null("PilotManagers/AIManager" + str(number))
	if not pilot_man:
		pilot_man = PilotManager.new()
		$PilotManagers.add_child(pilot_man)
		pilot_man.name = ("AIManager" + str(number))
	pilot_man.blue_team = blue_team
	ship.pilot_man = pilot_man
	$Ships.add_child(ship)

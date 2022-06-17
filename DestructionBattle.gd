extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ship_scene : PackedScene = preload("res://PlayerShip.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaittingCam.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	var ship = ship_scene.instance()
	add_child(ship)
	
	ship.connect("tree_exited", self, "_on_Ship_tree_exited")
	
	$SpawnHUD/Control.hide()
	
	# cam
	$Camera.fp_target_path = ship.get_node("FPCameraPosition").get_path()
	$Camera.tp_target_path = ship.get_node("CameraPosition").get_path()
	ship.get_node("Physics").connect("started_turboing", $Camera, "_on_Physics_started_turboing")
	ship.get_node("Physics").connect("stopped_turboing", $Camera, "_on_Physics_stopped_turboing")
	$Camera.make_current()
	$Camera.init_cam()

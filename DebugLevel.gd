extends Spatial


const player_ship_scene : PackedScene = preload("res://PlayerShip.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var ship = player_ship_scene.instance()
	$Camera.ship = ship
	ship.pilot_man = $PilotManager
	ship.cam = $Camera
	$Ships.add_child(ship)
	$Camera.make_current()
	$Camera.init_cam()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

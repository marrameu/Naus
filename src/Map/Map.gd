extends CanvasLayer


const ship_min_scene : PackedScene = preload("res://src/Map/NormalShipMin.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control.visible = Input.is_action_pressed("map")


func add_normal_ship(ship : Spatial, is_player := false):
	var new_ship_min = ship_min_scene.instance()
	new_ship_min.modulate = Color.cornflower if ship.pilot_man.blue_team else Color.indianred
	$Control.add_child(new_ship_min)
	new_ship_min.true_self = ship
	# new_ship_min.rect_position = Vector2(rand_range(0, 1000), rand_range(0, 1000))

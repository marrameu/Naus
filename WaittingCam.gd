extends Camera

# var current_location_index : int = 0
var target : Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if target and weakref(target).get_ref():
		translation = target.global_transform.origin
		rotation = target.global_transform.basis.get_euler()


func _on_SpawnHUD_change_spectate(location : int, index : int = 0):
	var target_ships : Array
	match location:
		0:
			target = null
			translation = Vector3(1060, 1512, 2512)
			rotation_degrees = Vector3(-26.6, 11.842, 4.789)
			return
		1:
			target_ships = get_tree().get_nodes_in_group("CapitalShips")
		2:
			target_ships = get_tree().get_nodes_in_group("AttackShips")
		3:
			target_ships = get_tree().get_nodes_in_group("SupportShips")
		4:
			target_ships = get_tree().get_nodes_in_group("Ships")
	
	if target_ships:
		if index < 0:
			print(index)
			if index < -target_ships.size() + 1:
				index = int(abs(index))
				index %= target_ships.size()
			index = int(abs(index))
			if index != 0:
				index = target_ships.size() - index
		elif index > target_ships.size() - 1:
			index %= target_ships.size()
		print(index)
		target = target_ships[index].get_node("SpectateCamPos")

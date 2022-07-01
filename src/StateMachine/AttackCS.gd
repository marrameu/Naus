extends "AIShipState.gd"


var enemy_cs : Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter():
	if owner.pilot_man.blue_team:
		enemy_cs = get_node("/root/Level/BigShips/CapitalShipRed")
		owner.shooting.target = enemy_cs
	else:
		enemy_cs = get_node("/root/Level/BigShips/CapitalShipBlue")
		owner.shooting.target = enemy_cs
	
	var t = Timer.new()
	t.set_wait_time(rand_range(7, 14))
	self.add_child(t)
	t.start()
	t.connect("timeout", self, "update_point")
	connect("finished", t, "queue_free")


func update_point():
	var count = randi() % (enemy_cs.get_node("ShipPoints").get_child_count() - 1)
	owner.input.target = enemy_cs.get_node("ShipPoints").get_child(count).global_transform.origin

extends "AIShipState.gd"


var enemy : Spatial
var enemy_wr : WeakRef

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update(_delta):
	if enemy_wr and enemy_wr.get_ref():
		owner.get_node("Input").target = enemy.translation


func _on_EnemyDetectArea_body_entered(body):
	if not enemy and body.is_in_group("Ships"):
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			enemy = body
			enemy_wr = weakref(enemy)
			owner.get_node("Shooting").target = enemy

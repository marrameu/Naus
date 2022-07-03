extends KinematicBody

signal destroyed

export var red_mat : Material
export var blue_mat : Material

export var blue_team : bool = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if blue_team:
		$Mesh.material_override = blue_mat
	else:
		$Mesh.material_override = red_mat


func _on_HealthSystem_die(attacker : Node):
	emit_signal("destroyed", blue_team)
	queue_free()


func _on_HealthSystem_shield_die():
	$ShieldMesh.hide()
	for turret in $Turrets.get_children():
		turret.get_node("DamageArea/CollisionShape").disabled = false


func _on_HealthSystem_shield_recovered():
	$ShieldMesh.show()
	for turret in $Turrets.get_children():
		turret.get_node("DamageArea/CollisionShape").disabled = true


func _on_enemy_died(attacker : Node):
	if attacker == self:
		pass #print("he matat algú")

extends Ship

var cam : Camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Utilities.first_person:
		$ShipMesh.visible = false
		$PlayerShipInterior.visible = true
	else:
		$ShipMesh.visible = true
		$PlayerShipInterior.visible = false


func _on_damagable_hit():
	$PlayerHUD.on_damagable_hit()


func _on_enemy_died(attacker : Node):
	if attacker == self:
		$PlayerHUD.on_enemy_died()


func _on_HealthSystem_die(attacker : Node):
	dead = true
	print("HAS ESTAT MORT PER ", attacker)
	if attacker:
		cam.killer = (attacker)
	
	# animacions
	
	var t = Timer.new()
	t.set_wait_time(2)
	self.add_child(t)
	t.start()
	t.connect("timeout", self, "die")


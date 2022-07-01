extends "AIShipState.gd"

var out_of_range_timer : Timer

var enemy : Spatial
var enemy_wr : WeakRef

var attack_rel_pos : Vector3
var total_attack_pos : Vector3

var get_away_from_the_enemy := true
var has_reached_enemy := false


func _ready():
	out_of_range_timer = Timer.new()
	add_child(out_of_range_timer)
	out_of_range_timer.connect("timeout", self, "_on_OutOfRangeTimer_timeout")


func enter():
	# temporal -> dos estats q estenen i q nomes canvien això
	var clos_enemy = owner.shooting.most_frontal_enenmy()
	if clos_enemy:
		if clos_enemy.translation.distance_to(owner.translation) < 500:
			set_enemy(clos_enemy)
			return
	
	var own_cs = get_node("/root/Level/BigShips/CapitalShipRed") if owner.pilot_man.blue_team else get_node("/root/Level/BigShips/CapitalShipBlue")
	var closest_dsit := INF#3000
	for ship in get_tree().get_nodes_in_group("Ships"):
		if ship.pilot_man.blue_team != owner.pilot_man.blue_team:
			var a = ship.translation.distance_to(own_cs.translation)
			if a < closest_dsit:
				closest_dsit = a
				clos_enemy = ship
	set_enemy(clos_enemy)
	
	"""
		if clos_enemy:
			set_enemy(clos_enemy)
		else:
			var t = Timer.new()
			t.set_wait_time(rand_range(2, 4))
			self.add_child(t)
			t.start()
			t.connect("timeout", self, "enter")
			connect("finished", t, "queue_free")
			# emit_signal("finished", "attack_cs") # no hi ha cap enemic a menys de 500m de mi ni a menys de 3000m de la meva CS
	"""


func update(_delta):
	if enemy_wr and enemy_wr.get_ref():
		attack_current_enemy()
	else:
		print("no enemy")
		enter()
		"""
		var t = Timer.new()
		t.set_wait_time(rand_range(2, 4))
		self.add_child(t)
		t.start()
		t.connect("timeout", self, "enter")
		connect("finished", t, "queue_free")
		"""


func attack_current_enemy():
	if enemy_wr and enemy_wr.get_ref():
		if has_reached_enemy:
			if get_away_from_the_enemy:
				owner.input.des_throttle = 1.0
				owner.input.target = total_attack_pos
				if owner.translation.distance_to(owner.input.target) < 100: # distancia a la attack pos
					get_away_from_the_enemy = false
			else: # disa
				if not owner.shooting.enemy_in_range and out_of_range_timer.is_stopped():
					out_of_range_timer.wait_time = rand_range(5, 14)
					out_of_range_timer.start()
					#no cal - elif owner.get_node("Shooting").enemy_in_range:
					#	timer.stop()
					# girar de pressa
				owner.input.des_throttle = 0.4
				owner.input.target = enemy.translation
		else:
			owner.input.des_throttle = 1.0
			owner.input.target = enemy.translation + attack_rel_pos # q si no sumes la relativa es xoquen
			if owner.translation.distance_to(enemy.translation) < 400: # distancia a l'enemic
				has_reached_enemy = true
				total_attack_pos = enemy.translation + attack_rel_pos


func set_enemy(new_enemy):
	enemy = new_enemy
	enemy_wr = weakref(enemy)
	owner.shooting.target = enemy
	has_reached_enemy = false
	get_away_from_the_enemy = true
	change_rel_pos()


func _on_OutOfRangeTimer_timeout():
	if enemy_wr and enemy_wr.get_ref():
		change_rel_pos()
		total_attack_pos = enemy.translation + attack_rel_pos
		get_away_from_the_enemy = true


func change_rel_pos():
	attack_rel_pos = Vector3(rand_range(-200, 200), rand_range(-200, 200), rand_range(-200, 200))


# si persegueix un enemic però li'n apareix un altre per davant, q ataqui al de devant
func _on_ShootingArea_body_entered(body):
	return
	if body != enemy and body.is_in_group("Ships"):
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			set_enemy(body)

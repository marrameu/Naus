extends "AIShipState.gd"


onready var timer : Timer = $OutOfRangeTimer

var enemy : Spatial
var enemy_wr : WeakRef

var attack_rel_pos : Vector3
var total_attack_pos : Vector3

var go_to_attack_rel_pos := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter():
	attack_rel_pos = Vector3(rand_range(-200, 200), rand_range(-200, 200), rand_range(-200, 200)) # si va bé, fer-ho més gran


func update(_delta):
	if enemy_wr and enemy_wr.get_ref():
		if go_to_attack_rel_pos:
			owner.get_node("Input").des_throttle = 1.0
			owner.get_node("Input").target = total_attack_pos
			if owner.translation.distance_to(owner.get_node("Input").target) < 100: # distancia a la attack pos
				go_to_attack_rel_pos = false
		else:
			if not owner.get_node("Shooting").enemy_in_range and timer.is_stopped():
				timer.wait_time = rand_range(5, 14)
				timer.start()
				#no cal - elif owner.get_node("Shooting").enemy_in_range:
				#	timer.stop()
				# girar de pressa
			owner.get_node("Input").des_throttle = 0.4
			owner.get_node("Input").target = enemy.translation


func _on_EnemyDetectArea_body_entered(body):
	if body.is_in_group("Ships"): #and not enemy: # fer q passat un mig minut passi de l'enemic
		if body.pilot_man.blue_team != owner.pilot_man.blue_team:
			enemy = body
			enemy_wr = weakref(enemy)
			owner.get_node("Shooting").target = enemy
			
			# encara és massa lluny, no pot agafar la posició d'atac pq seria massa lluny
			# això ho haruia de treure, fer l'area de detecció més petita i fer directament q si no troba
			# cap enemic q vagi directament al q sigui més a  prop, coneixent ja la posicició de tots els enemics
			if owner.translation.distance_to(enemy.translation) > 1200:
				timer.wait_time = rand_range(4, 6)
				timer.start()
			
			total_attack_pos = enemy.translation + attack_rel_pos


func _on_OutOfRangeTimer_timeout():
	if enemy_wr and enemy_wr.get_ref():
		enter()
		total_attack_pos = enemy.translation + attack_rel_pos
		go_to_attack_rel_pos = true

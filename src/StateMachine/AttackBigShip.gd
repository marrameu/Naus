extends "AttackEnemy.gd"


func change_rel_pos():
	attack_rel_pos = Vector3(rand_range(-1000, 1000), rand_range(-1000, 1000), rand_range(-1000, 1000))

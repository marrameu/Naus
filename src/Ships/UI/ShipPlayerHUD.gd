extends CanvasLayer

onready var lock_target_info := $LockTargetInfo
onready var lock_target_nickname := $LockTargetInfo/Nickname
onready var lock_target_life_bar := $LockTargetInfo/LifeBar

# Tots els nodes de la nau agafen l'input des d'aquí, millor que l'agafin des del node PlayerInput
var cursor_input := Vector2()

var _cursor_visible := false
var _cursor_limit := 450
var _min_position := 20


func _ready() -> void:
	"""
	if LocalMultiplayer.number_of_players > 1:
		# Canviar l'escala d'alguns objectes
		$Center/CursorPivot/Cursor.rect_scale = Vector2(1.5, 1.5)
		$Center/Crosshair.rect_scale = Vector2(1.5, 1.5)
		$LifeBar.rect_scale = Vector2(2.25, 2.25) # No coincideix amb la del jugador
		$Indicators/LeaveIndicator.rect_scale = Vector2(2, 2)
		$Indicators/LandingIndicator.rect_scale = Vector2(2, 2)
		
		# Variable per a la sensibilitat en el mode multijugador, aquesta es multiplica per 2?
	"""


func _process(delta : float) -> void:
	if get_tree().has_network_peer():
		if get_parent().is_player:
			if get_parent().player_id != get_tree().get_network_unique_id():
				return
	
	#Utilities.canvas_scaler(get_parent().number_of_player, self)
	
	# Debug
	if Input.is_key_pressed(KEY_F1):
		_cursor_visible = true
	elif Input.is_key_pressed(KEY_F2):
		_cursor_visible = false
	
	if not _cursor_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	
	
	
	$Center.visible = true # is_player
	
	var target : Spatial = owner.shooting.lock_target
	if target and weakref(target).get_ref():
		if not owner.cam.is_position_behind(target.translation):
			lock_target_info.show()
			lock_target_nickname.text = target.name
			lock_target_life_bar.value = (float(target.get_node("HealthSystem").shield) / float(target.get_node("HealthSystem").MAX_SHIELD)) * 100
			lock_target_life_bar.get_node("LifeBar").value = (float(target.get_node("HealthSystem").health) / float(target.get_node("HealthSystem").MAX_HEALTH)) * 100
			lock_target_info.rect_position = (owner.cam as Camera).unproject_position(target.translation) - Vector2(lock_target_info.rect_size.x / 2, lock_target_info.rect_size.y / 2) + Vector2.UP * 80
		else:
			lock_target_info.hide()
	else:
			lock_target_info.hide()
			
	
	
	
	#$LifeBar.show()
	#$LifeBar.value = float(get_node("../HealthSystem").health) / float(get_node("../HealthSystem").MAX_HEALTH) * 100
	$ShieldLifeBar.show()
	$ShieldLifeBar.value = float(get_node("../HealthSystem").shield) / float(get_node("../HealthSystem").MAX_SHIELD) * 100
	$ShieldLifeBar/LifeBar.value = float(get_node("../HealthSystem").health) / float(get_node("../HealthSystem").MAX_HEALTH) * 100
	
	var a = get_node("../Input").avaliable_turbos
	var rects = $SpeedBars/HBoxContainer2.get_children()
	for rect in rects:
		if a > 0:
			rect.color = Color("b79b5b")
			a -= 1
		else:
			rect.color = Color("48b6b6b6")
	
	var old_throttle_bar_value = $SpeedBars/ThrottleBar.value
	$SpeedBars/ThrottleBar.value = get_node("../Input").throttle * 100 
	
	if not owner.input.wants_turbo: # and not owner.input.drifting:
		# q no faci salts (frenar)
		if (old_throttle_bar_value > 70 and $SpeedBars/ThrottleBar.value <= 70 and $SpeedBars/ThrottleBar.value > 30) or (old_throttle_bar_value < 30 and $SpeedBars/ThrottleBar.value >= 30 and $SpeedBars/ThrottleBar.value < 70):
			# hi entra
			$ThrottleInAudio.play()
		if (old_throttle_bar_value < 70 and $SpeedBars/ThrottleBar.value >= 70 and $SpeedBars/ThrottleBar.value > 30) or (old_throttle_bar_value > 30 and $SpeedBars/ThrottleBar.value <= 30 and old_throttle_bar_value <= 70):
			# en surt
			$ThrottleOutAudio.play()
	
	var b = owner.transform.basis
	var v_len = owner.linear_velocity.length()
	var v_nor = owner.linear_velocity.normalized()
	var vel : Vector3
	vel.z = b.z.dot(v_nor) * v_len
	$SpeedBars/SpeedBar.value = vel.z / 2
	$SpeedBars/SpeedBar.tint_progress = Color("966263ff") if not owner.input.turboing else Color("b79b5b")
	
	$Label.text = ""
	if owner.input.turboing:
		$Label.text += "turboing"
	if owner.input.drifting:
		$Label.text += "drifting"
	
	$AmmoBar.value = owner.shooting.ammo / owner.shooting.MAX_AMMO * 100
	
	"""
	# que no ho comprovi tota l'estona, amb un senyal anirià millor
	if get_parent().is_player:
		#$Indicators/LeaveIndicator.visible = get_parent().state == get_parent().State.LANDED
		
		if get_parent().state == get_parent().State.FLYING:
			#$Indicators/LandingIndicator.visible = get_parent().landing_areas > 0
			$LifeBar.show()
			$LifeBar.value = float(get_node("../HealthSystem").health) / float(get_node("../HealthSystem").MAX_HEALTH) * 100
		else:
			$Indicators/LandingIndicator.hide()
			$LifeBar.hide()
	"""

func _physics_process(delta : float) -> void:
	if $Center.visible:
		if not Settings.controller_input:
			$Center/CursorPivot/Cursor.rect_position += Utilities.mouse_movement * delta * Settings.mouse_sensitivity
			$Center/CursorPivot/Cursor.rect_position = $Center/CursorPivot/Cursor.rect_position.clamped(_cursor_limit)
			
			if $Center/CursorPivot/Cursor.rect_position.length() > _min_position:
				cursor_input.x = $Center/CursorPivot/Cursor.rect_position.x / _cursor_limit
				cursor_input.y = -$Center/CursorPivot/Cursor.rect_position.y / _cursor_limit
			else:
				cursor_input = Vector2()
		else:
			$Center/CursorPivot/Cursor.rect_position = Vector2()
			cursor_input = Vector2()

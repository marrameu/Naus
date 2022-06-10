extends Control

#Controls
onready var SensiblitySlider = $MarginContainer/VBoxContainer/TabContainer/CONTROLS/GridContainer/SensibilitySlider

#Audio
onready var MasterAudioSlider = $MarginContainer/VBoxContainer/TabContainer/AUDIO/GridContainer/MasterVolumSlider

# Called when the node enters the scene tree for the first time.
func _ready():

	#default sensibility
	SensiblitySlider.value = 75
	MasterAudioSlider.value = 0



func _process(delta):
	$FpsNode/FPS.text = str(Engine.get_frames_per_second())


func _on_SensibilitySlider_value_changed(value):
	Settings.mouse_sensitivity = value


func _on_MasterVolumSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)


func _on_CheckDisplayFps_toggled(button_pressed):
	if button_pressed == true:
		$FpsNode/FPS.show()
	else:
		$FpsNode/FPS.hide()
		


func _on_CheckVsync_toggled(button_pressed):
	if button_pressed == true:
		OS.vsync_enabled = true
	else:
		OS.vsync_enabled = false


func _on_Atrs_pressed():
	$"../".show()
	self.hide()
	

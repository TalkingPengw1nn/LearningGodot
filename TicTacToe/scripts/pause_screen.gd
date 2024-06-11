extends CanvasLayer

signal restart
	

func _on_restart_button_button_up():
	restart.emit()

func _on_restart_button_button_down():
	$RestartSound.play()

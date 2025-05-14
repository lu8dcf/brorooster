extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc"): # al presionarse la tecla ESC configurada en el proyecto el juego pasará a estar en el estado de pausa
		# de la siguiete forma se detiene el juego y si este código se recnoce que ya está en pausa, con la misma tecla se puede regresar al juego
		
		if get_tree().paused == true :
			$blur_pausa/animator.play("resume_pause_blur")
			$blur_pausa/bg_overlay/sound_pause_off.play()
		else:
			$blur_pausa/animator.play("pause_blur")
			$blur_pausa/bg_overlay/sound_pause_on.play()
			
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = not get_tree().paused
		
		$blur_pausa/bg_overlay/VBoxContainer.visible = not $blur_pausa/bg_overlay/VBoxContainer.visible
		#$VBoxContainer.visible = not $VBoxContainer.visible
		#$Popup.visible = not $Popup.visible




func _on_menu_pressed() -> void:
	$blur_pausa/bg_overlay/VBoxContainer/buttons.play()
	get_tree().paused = not get_tree().paused
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")


func _on_exit_pressed() -> void:
	$blur_pausa/bg_overlay/VBoxContainer/buttons.play()
	get_tree().quit()


func _on_restart_pressed() -> void:
	pass # Replace with function body.

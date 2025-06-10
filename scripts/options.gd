extends Control


#globalenemy.dificultad: int (1,2,3)


func _on_btn_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")


func _on_btn_aceptar_pressed() -> void:
	#acepta los cambios hechos en las opciones
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sound_menu.play()
	pass # Replace with function body.

func _on_play_pressed() -> void: # al hacer click en el boton de JUGAR empieza el juego en el nivel 1
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")
	


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")


func _on_boton_salir_pressed() -> void:
	get_tree().quit()

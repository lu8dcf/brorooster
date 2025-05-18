extends Node


func _ready():
	pass	
	
	# BOTONES
func _on_play_pressed() -> void: # al hacer click en el boton de JUGAR empieza el juego en el nivel 1
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()

extends Node


func _ready():
	# En cualquier script de escena
	GlobalAudio.play_music(preload("res://assets/sound/menus_effects/intro.mp3"))
	
	# BOTONES
func _on_play_pressed() -> void: # al hacer click en el boton de JUGAR empieza el juego en el nivel 1
	get_tree().change_scene_to_file("res://scenes/hud/character_selector.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()


# funcionalidad con teclado
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		_on_play_pressed()
	

extends Control

@onready var animator: AnimationPlayer = $blur_pausa/animator
@onready var sound_pause_on: AudioStreamPlayer2D = $blur_pausa/bg_overlay/sound_pause_on
@onready var sound_pause_off: AudioStreamPlayer2D = $blur_pausa/bg_overlay/sound_pause_off
@onready var pause_menu: VBoxContainer = $blur_pausa/bg_overlay/VBoxContainer

var is_paused := false

func _ready():
	# Desactivamos el procesamiento cuando está en pausa
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	# Conectamos señales de los botones
	pause_menu.find_child("menu").pressed.connect(_on_menu_pressed)
	pause_menu.find_child("restart").pressed.connect(_unpause_game)
	pause_menu.find_child("options").pressed.connect(_on_options_pressed)
	pause_menu.hide()

func _unpause_game():
	is_paused = false
	animator.play("resume_pause_blur")
	sound_pause_off.play()
	pause_menu.hide()
	get_tree().paused = false

func _pause_game():
	is_paused = true
	animator.play("pause_blur")
	sound_pause_on.play()
	pause_menu.show()
	get_tree().paused = true

func _input(event: InputEvent):
	if event.is_action_pressed("ui_esc") and !is_paused:
		_pause_game()
	elif event.is_action_pressed("ui_esc") and is_paused:
		_unpause_game()

# BOTONES - Modificados para manejar correctamente la pausa
func _on_menu_pressed() -> void:
	_unpause_game()  # Asegurarse de quitar la pausa antes de cambiar
	await get_tree().create_timer(0.1).timeout  # Pequeño delay para seguridad
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

func _on_play_pressed() -> void:
	_unpause_game()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/game/main_game.tscn")

func _on_options_pressed() -> void:
	# Aquí podrías cargar una escena de opciones que no requiera pausa
	pass

func _on_exit_pressed() -> void:
	_unpause_game()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()

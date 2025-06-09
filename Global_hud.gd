extends Node

# Precarga el sonido del botón
@onready var button_sound: AudioStreamPlayer = $button_sound
@export var button_click_sound: AudioStream

enum GameState {
	MAIN_MENU,
	CHARACTER_SELECT,
	WEAPON_SELECT,
	SHOP,
	IN_GAME
}

var current_state: GameState = GameState.MAIN_MENU

func _ready():
	# Asegúrate de que el sonido está asignado
	if button_click_sound:
		button_sound.stream = button_click_sound
	
	# Reproduce música de fondo (opcional)
	GlobalAudio.play_music(preload("res://assets/sound/loops/menu_loop.ogg"))

# Funciones de los botones
func _on_play_pressed() -> void:
	_play_button_sound()
	GlobalHud.current_state = GlobalHud.GameState.CHARACTER_SELECT
	get_tree().change_scene_to_file("res://scenes/hud/character_selector.tscn")

func _on_menu_pressed() -> void:
	_play_button_sound()
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

func _on_options_pressed() -> void:
	_play_button_sound()
	# Tu código para opciones aquí

func _on_credits_pressed() -> void:
	_play_button_sound()
	get_tree().change_scene_to_file("res://scenes/hud/credits.tscn")
	# Tu código para créditos aquí

func _on_exit_pressed() -> void:
	_play_button_sound()
	get_tree().quit()

# Función para reproducir sonido de botón
func _play_button_sound():
	if button_sound and button_sound.stream:
		button_sound.play()
	else:
		push_warning("Button sound not configured!")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_play_button_sound()
		
		match GlobalHud.current_state:
			GlobalHud.GameState.MAIN_MENU:
				_on_play_pressed()  # Va al selector de personajes
				GlobalHud.current_state = GlobalHud.GameState.CHARACTER_SELECT  # Actualiza el estado
			GlobalHud.GameState.CHARACTER_SELECT:
				GlobalHud.current_state = GlobalHud.GameState.WEAPON_SELECT  # Actualiza el estado
			GlobalHud.GameState.WEAPON_SELECT:
				GlobalHud.current_state = GlobalHud.GameState.IN_GAME
			_:
				pass  # Otras escenas no hacen nada con Enter

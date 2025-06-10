extends Control

# Variables para los volúmenes (valores entre 0 y 100)
var general_volume: int = 50
var music_volume: int = 50
var sfx_volume: int = 50

# Referencias a los nodos
@onready var general_label: Label = $VBoxContainer/panel_sounds/general/Label
@onready var music_label: Label = $VBoxContainer/panel_sounds/musica/Label
@onready var sfx_label: Label = $VBoxContainer/panel_sounds/efectos/Label

#globalenemy.dificultad: int (1,2,3)

#difcultad:
@onready var btn_facil: Button = $panel_game/dificultad/HBoxContainer/facil
@onready var btn_normal: Button = $panel_game/dificultad/HBoxContainer/normal
@onready var btn_dificil: Button = $panel_game/dificultad/HBoxContainer/dificil


# pantalla
@onready var btn_pantalla_completa: Button = $panel_game/pantalla/HBoxContainer/btn_completa
@onready var btn_modo_ventana: Button = $panel_game/pantalla/HBoxContainer/btn_ventana

# Variable para guardar el estado de pantalla
var pantalla_completa: bool = true


func _ready():
	# Cargar configuración existente
	load_settings()
	# Configurar botones de dificultad
	update_difficulty_buttons()
	cargar_configuracion_pantalla()
	update_ui()
	

func cargar_configuracion_pantalla():
	var config = ConfigFile.new()
	if config.load("user://config.cfg") == OK:
		pantalla_completa = config.get_value("video", "pantalla_completa", true)
		aplicar_modo_pantalla()

func load_settings():
	# Cargar volúmenes (tu código existente)
	load_volumes()
	
	# Cargar dificultad si existe
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		GlobalEnemy.dificultad = config.get_value("game", "difficulty", 2)  # Default 2 (normal)
	else:
		GlobalEnemy.dificultad = 2  # Valor predeterminado
	
func load_volumes():
	# Cargar de ConfigFile si existe
	var config = ConfigFile.new()
	if config.load("user://audio_settings.cfg") == OK:
		general_volume = config.get_value("audio", "general_volume", 100)
		music_volume = config.get_value("audio", "music_volume", 100)
		sfx_volume = config.get_value("audio", "sfx_volume", 100)
	
	# Asegurar que los valores estén entre 0 y 100
	general_volume = clamp(general_volume, 0, 100)
	music_volume = clamp(music_volume, 0, 100)
	sfx_volume = clamp(sfx_volume, 0, 100)

func update_ui():
	apply_volumes()     # Aplicar los volúmenes al sistema de audio

func apply_volumes():
	# Usar GlobalAudio para el volumen de música
	GlobalAudio.set_music_volume(music_volume / 100.0)
	GlobalAudio.set_sfx_volume(sfx_volume / 100.0)
	
	# Volumen general directamente con AudioServer
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear_to_db(general_volume / 100.0)
	)
	
	
	
func aplicar_modo_pantalla():
	if pantalla_completa:
		# Modo pantalla completa
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Modo ventana
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))  # Tamaño por defecto

func actualizar_botones_pantalla():
	btn_pantalla_completa.button_pressed = pantalla_completa
	btn_modo_ventana.button_pressed = not pantalla_completa

func guardar_configuracion_pantalla():
	var config = ConfigFile.new()
	config.set_value("video", "pantalla_completa", pantalla_completa)
	config.save("user://config.cfg")

# Función para convertir porcentaje a dB (ajusta según tus necesidades)
func percent_to_db(percent: int) -> float:
	# Convertir de porcentaje (0-100) a dB (rango típico -80 a 0)
	return clamp((percent * 0.8) - 80, -80, 0)

func _on_btn_atras_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")


func _on_btn_aceptar_pressed() -> void:
	#acepta los cambios hechos en las opciones
	# Guardar los cambios y volver al menú principal
	save_settings()
	save_volumes()
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

func save_settings():
	# Guardar volúmenes (tu código existente)
	save_volumes()
	
	# Guardar dificultad
	var config = ConfigFile.new()
	config.set_value("game", "difficulty", GlobalEnemy.dificultad)
	config.save("user://settings.cfg")
	
func save_volumes():
	# Guardar los volúmenes en ConfigFile
	var config = ConfigFile.new()
	config.set_value("audio", "general_volume", general_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save("user://audio_settings.cfg")

func update_difficulty_buttons():
	## Deseleccionar todos los botones primero
	#btn_facil.pressed = false
	#btn_normal.pressed = false
	#btn_dificil.pressed = false
	#
	## Seleccionar el botón correspondiente a la dificultad actual
	#match GlobalEnemy.dificultad:
		#1:
			#btn_facil.pressed = true
		#2:
			#btn_normal.pressed = true
		#3:
			#btn_dificil.pressed = true
	pass



func _on_g_off_pressed() -> void:
	general_volume = 0
	update_ui()


func _on_g_25_pressed() -> void:
	general_volume = 25
	update_ui()


func _on_g_50_pressed() -> void:
	general_volume = 50
	update_ui() 


func _on_g_75_pressed() -> void:
	general_volume = 75
	update_ui()
	

func _on_g_all_pressed() -> void:
	general_volume = 100
	update_ui()

# botones de musica 

func _on_m_off_pressed() -> void:
	music_volume = 0
	update_ui()
	

func _on_m_25_pressed() -> void:
	music_volume = 25
	update_ui()

func _on_m_50_pressed() -> void:
	music_volume = 50
	update_ui()

func _on_m_75_pressed() -> void:
	music_volume = 75
	update_ui()

func _on_m_all_pressed() -> void:
	music_volume = 100
	update_ui()
	
#botones de sfx efectos


func _on_e_off_pressed() -> void:
	sfx_volume = 0
	update_ui()

func _on_e_25_pressed() -> void:
	sfx_volume = 25
	update_ui()
	
func _on_e_50_pressed() -> void:
	sfx_volume = 50
	update_ui()


func _on_e_75_pressed() -> void:
	sfx_volume = 75
	update_ui()

func _on_e_all_pressed() -> void:
	sfx_volume = 100
	update_ui()


func _on_facil_pressed() -> void:
	GlobalEnemy.dificultad = 1
	update_difficulty_buttons()
	

func _on_normal_pressed() -> void:
	GlobalEnemy.dificultad = 2
	update_difficulty_buttons()

func _on_dificil_pressed() -> void:
	GlobalEnemy.dificultad = 3
	update_difficulty_buttons()


func _on_btn_completa_pressed() -> void:
	pantalla_completa = true
	aplicar_modo_pantalla()
	actualizar_botones_pantalla()
	guardar_configuracion_pantalla()

func _on_btn_ventana_pressed() -> void:
	pantalla_completa = false
	aplicar_modo_pantalla()
	actualizar_botones_pantalla()
	guardar_configuracion_pantalla()

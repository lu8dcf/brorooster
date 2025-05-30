extends Node

@onready var video_player = $VideoStreamPlayer
@export var next_scene_path: String = "res://scenes/main_menu.tscn" # Ruta a tu siguiente escena (ej. menú principal)

func _ready():
	# Conectar la señal 'finished' del VideoStreamPlayer
	video_player.finished.connect(_on_video_finished)
	
	#video_player.stretch_mode = VideoStreamPlayer.STRETCH_KEEP_ASPECT_CENTERED

	
	video_player.play()
	
	# funcion para expandir el video a pantalla completa pero se ve un poco feo
	#video_player.set_expand(true)
	#video_player.custom_minimum_size = DisplayServer.window_get_size()
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
func _input(event):
	# Detectar clic con el botón izquierdo del mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Si se hace clic, saltar el video
		skip_video()

func _on_video_finished():
	# Cuando el video termina automáticamente, cargar la siguiente escena
	load_next_scene()

func skip_video():
	# Detener el video
	video_player.stop()
	# Cargar la siguiente escena
	load_next_scene()

func load_next_scene():
	# Cargar la siguiente escena del juego
	# Esto libera la escena actual del video y la reemplaza con la nueva
	get_tree().change_scene_to_file("res://scenes/hud/Main_menu.tscn")

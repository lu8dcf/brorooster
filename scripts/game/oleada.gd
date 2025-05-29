extends Node2D

# Factory-Enemy
var factory_enemy_escene = preload("res://scenes/game/enemy/factoy_enemy.tscn")
var factory_enemy: Node = null  # Mejor inicializar como null

var duracion_oleada = GlobalOleada.tiempo_oleada
var duracion_seleccion = GlobalOleada.tiempo_seleccion
var numero_oleada = GlobalOleada.oleada

enum EstadoJuego { OLEADA, SELECCION }
var estado_actual: EstadoJuego = EstadoJuego.OLEADA
var tiempo_restante: float = 0.0
var menu_armas: Sprite2D = null  # Referencia al menú de armas

func _ready():
	iniciar_oleada()
	
func _input(event):
	# Detectar clic con el botón izquierdo del mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		match estado_actual:
			EstadoJuego.OLEADA:
				pass
			EstadoJuego.SELECCION:
				cambiar_estado()
		

func _process(delta):
	tiempo_restante -= delta
	
	if tiempo_restante <= 0:
		cambiar_estado()
		
func cambiar_estado():
	match estado_actual:
		EstadoJuego.OLEADA:
			iniciar_seleccion_armas()
		EstadoJuego.SELECCION:
			iniciar_oleada()

func iniciar_oleada():
	get_tree().paused = false
	estado_actual = EstadoJuego.OLEADA
	tiempo_restante = duracion_oleada
	
	# Activar generación de enemigos
	factory_enemy = factory_enemy_escene.instantiate()
	add_child(factory_enemy)
	
	# Eliminar menú de armas si existe
	if is_instance_valid(menu_armas):
		menu_armas.queue_free()
		menu_armas = null
	
	# Reanudar juego
	get_tree().paused = false
	
	# Actualizar oleada
	numero_oleada += 1
	GlobalOleada.oleada = numero_oleada

func iniciar_seleccion_armas():
	estado_actual = EstadoJuego.SELECCION
	tiempo_restante = duracion_seleccion
	
	# Eliminar factory_enemy si existe
	if is_instance_valid(factory_enemy):
		factory_enemy.queue_free()
		factory_enemy = null
	
	# Crear menú de armas (que ignore la pausa)
	menu_armas = Sprite2D.new()
	menu_armas.texture = load("res://assets/graphics/menu_graphics/menu_armas.png")
	menu_armas.scale = Vector2(1, 1)
	menu_armas.position = Vector2(400, 300)
	menu_armas.centered = true
	menu_armas.process_mode = Node.PROCESS_MODE_ALWAYS  # Para que ignore la pausa
	
	add_child(menu_armas)
	
	# Pausar el juego (el menú seguirá funcionando por PROCESS_MODE_ALWAYS)
	get_tree().paused = true

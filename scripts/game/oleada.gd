extends Node2D

# Factory-Enemy
var factory_enemy_escene = preload("res://scenes/game/enemy/factoy_enemy.tscn")
var factory_enemy: Node = null  # Mejor inicializar como null

var duracion_oleada = GlobalOleada.tiempo_oleada
var duracion_seleccion = GlobalOleada.tiempo_seleccion
var numero_oleada = GlobalOleada.oleada

enum EstadoJuego { OLEADA, SELECCION }
var estado_actual: EstadoJuego = EstadoJuego.OLEADA
var tiempo_restante = GlobalOleada.tiempo_oleada
var menu_armas: Sprite2D = null  # Referencia al menú de armas

var tienda_escene = preload("res://scenes/hud/hud_shop.tscn")


func _ready():
	
	
	# Configura un Timer para decrementar cada segundo
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(1.0)  # Intervalo de 1 segundo
	
	iniciar_oleada()
	
func _on_timer_timeout():
	tiempo_restante -= 1
	GlobalOleada.tiempo_restante_oleada = tiempo_restante
	GlobalOleada.time_changed.emit(tiempo_restante)
	# print (tiempo_restante)
		
	if tiempo_restante <= 0:
		# Opcional: Detener el timer al llegar a 0
		tiempo_restante = GlobalOleada.tiempo_oleada
		cambiar_estado()
		

	
func _input(event):
	# Detectar clic con el botón izquierdo del mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		match estado_actual:
			EstadoJuego.OLEADA:
				pass
			EstadoJuego.SELECCION:
				cambiar_estado()
		

func _process(delta):
	pass
		
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
	#
	GlobalOleada.eliminar_todos_enemigos()
	
	get_tree().paused = true
	GlobalHud.current_state = GlobalHud.GameState.SHOP
	get_tree().change_scene_to_file("res://scenes/hud/hud_shop.tscn")	
	# Pausar el juego (excepto la tienda)

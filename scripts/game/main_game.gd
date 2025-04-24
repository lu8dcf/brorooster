extends Node2D

#tamaño de pantalla
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo

# Estado de la partida
signal stage # Indicador del Stage Actual

# Player
var player = null
var screen_live = Global.lives   # cantidad de vidas que se muestran en pantalla
signal live  # muestra las vidas activas

# Enemigos
var enemies = []  # Almacenará las instancias de enemigos
var enemies_boss = [] # Almacenara las instancias de los enemigos Boss
var move_enemy = 0.05  # Intervalo de tiempo para el movimiento enemigo
var timer_between_enemy = .5 # .5 seg Intervalo que aparecen los enemigos
var boss_active=0 # Bandera para Agregar secuaces al BOSS

# Disparos
var timer_between_shoot = .5 # .5 seg Intervalo que aparecen los enemigos


func _ready():	# Comienza el juego
	
	init_player() # Instanciar y añadir el jugador en el punto central 
	
	timer_add_enemy() # Timer que marca los tiempos que se instancian los enemigos
	
	timer_shoot() # Timer entre disparos
	
	
#


func init_player():  # Inicia al player 1
	player = preload("res://scenes/game/player.tscn").instantiate()
	player.position = Vector2(pantalla_ancho/2,pantalla_alto/2)  # Colocar al jugador en la parte inferior al centro
	add_child(player)  # Agrega el nodo hijo
	#screen_lives() # Muestra la cantidad de vidas

func timer_add_enemy():
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = timer_between_enemy
	enemy_timer.one_shot = false #que sea ciclico
	add_child(enemy_timer)
	enemy_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a las naves enemigas
	enemy_timer.timeout.connect(init_enemy)
	
func init_enemy():
	
	
	#boss_activo =0 inicia el Boss
	#boss_activo 1,2 o 3 , agrega diferentes enemigos con el boss
	
	# emite la señal cuando hubo un cambio de stage y lo envia a la pantalla
	#emit_signal("stage_actual",stage)  
	# Nivel 1 - babosas
	var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
	var enemy = preload("res://scenes/game/enemy/enemy1.tscn").instantiate()
	enemy.position = Vector2(position[0], position[1]) # Ubica al enemigo en la X random e Y en el inicio
	add_child(enemy)  # Agrega como hijo del main al enemigo
	enemies.append(enemy)
	
	pass

func enemy_starting_point(): # genera una posisiocn aleatoria en los bordes de la pantalla para el inicio de los enemigos
	var posicion_x = 0
	var posicion_y = 0
	
	var side = randi() % 4 + 1
	match side:
		1: #arriba
			posicion_x = randf_range(100, pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = 0
		2: #derecha
			posicion_x = pantalla_ancho
			posicion_y = randf_range(100, pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		3: #abajo
			posicion_x = randf_range(100, pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = pantalla_alto
		4: #izquierda
			posicion_x = 0
			posicion_y = randf_range(100, pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		_:
			posicion_x = 0
			posicion_y = 0
	return [posicion_x,posicion_y]

func get_closest_enemy():   # obtiene la direccion del enemigo mas cercano
	var closest_enemy = null  # si no tiene ningun enemigo
	var shortest_distance = INF  # Inicia con una distancia infinita
	var player_position = player.global_position # sposision actual del player
	print (player_position)
	# buscar en toda las instancias de enemigos cual es la mar cercana
	for enemy in enemies:
		var distance_to_enemy = player_position.distance_to(enemy.global_position)
		if distance_to_enemy < shortest_distance:
			shortest_distance = distance_to_enemy
			closest_enemy = enemy
	
	return closest_enemy  #devuelve el enemigo mas cercano
	
func shoot_at_closest_enemy(): # disparo al enemigo mas cercano
	var closest_enemy = get_closest_enemy() #obtiene la ubicacion del enemigo mas cercano
	if closest_enemy:
		var direction = (closest_enemy.global_position - global_position).normalized()
		return direction  # Función de disparo que mueve el proyectil en la dirección

func timer_shoot():   #temporizador entre disparos
	var shoot_timer = Timer.new()
	shoot_timer.wait_time = timer_between_enemy
	shoot_timer.one_shot = false #que sea ciclico
	add_child(shoot_timer)
	shoot_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a las naves enemigas
	shoot_timer.timeout.connect(shoot)
	
func shoot():
	var direction = shoot_at_closest_enemy() # dispara un laser al enmigo mas cercano
	print (direction)
	pass

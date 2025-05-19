extends Node2D

#tamaño de pantalla
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo

# Estado de la partida
signal stage # Indicador del Stage Actual

# Player
var player = null
#var screen_live = Global.lives   # cantidad de vidas que se muestran en pantalla
#signal live  # muestra las vidas activas


# Enemigos
var enemies = []  # Almacenará las instancias de enemigos
var enemies_boss = [] # Almacenara las instancias de los enemigos Boss
var move_enemy = 0.05  # Intervalo de tiempo para el movimiento enemigo
var timer_between_enemy = .5 # .5 seg Intervalo que aparecen los enemigos
var boss_active=0 # Bandera para Agregar secuaces al BOSS
var limit_of_enemy = 30 # cantidad de enemigos que se instancian




# Entorno
var background = null

func _ready():	# Comienza el juego
	
	$level_loop.play()
	
	init_background()
	
	init_player() # Instanciar y añadir el jugador en el punto central 
	# asignar la señal del angulo del arma y disparo
	$player.connect("enemy_detected", $player._on_enemy_detected) 
	
	timer_add_enemy() # Timer que marca los tiempos que se instancian los enemigos
	

	#init_spawn() #Spawn de enemigos.
	
func _process(delta):
	var closest_enemy = get_closest_enemy()   # pide al enemigo mas cercano
	if closest_enemy:                         # si existe un enemigo 
		var angle = $player.global_position.angle_to_point(closest_enemy.global_position)   #envia el angulo al player
		$player._on_enemy_detected(angle)
		
func init_background():  # Inicia el fondo y los limites de pantalla
	background = preload("res://scenes/game/background.tscn").instantiate()
	background.position = Vector2(0,0)  # Colocar al jugador en la parte inferior al centro
	add_child(background)  # Agrega el nodo hijo

func init_player():  # Inicia al player 1
	# Definir parámetros, estos parametros deben se tomaddos de la global
	var p_health = Global._health
	var p_speed = Global._speed
	var p_armor = Global._armor
	var sprite_path = NodePath(Global._sprite_player)  # Ruta relativa al nodo Player
	
	player = PlayerFactory.load_player("res://scenes/game/player.tscn",p_health,p_speed,p_armor,sprite_path)
	player.position = Vector2(pantalla_ancho/2,pantalla_alto/2)  # Colocar al jugador en el centro
	add_child(player)  # Agrega el nodo hijo
	
	player = PlayerFactory.load_player("res://scenes/game/player.tscn",p_health,p_speed,p_armor,sprite_path)
	player.position = Vector2(pantalla_ancho/3,pantalla_alto/3)  # Colocar al jugador en el centro
	add_child(player)  # Agrega el nodo hijo

func timer_add_enemy():
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = timer_between_enemy
	enemy_timer.one_shot = false #que sea ciclico
	add_child(enemy_timer)
	enemy_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a los enemigos
	
	enemy_timer.timeout.connect(init_enemy)
	
	
func init_spawn():
	await get_tree().create_timer(.8).timeout
	add_child(preload("res://scenes/game/enemy/spawner_enemy.tscn").instantiate())
	
	
func init_enemy():
	limit_of_enemy -=1 #limitar la cantidad de enemigos que se instancian
	if limit_of_enemy>0:
	# Nivel 1 - babosas
		var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
		var enemy = preload("res://scenes/game/enemy/enemy1.tscn").instantiate()
		enemy.position = Vector2(position[0], position[1]) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
		#print ("Cantidad de enemigos: ",30-limit_of_enemy)
	
func enemy_starting_point(): # genera una posisiocn aleatoria en los bordes de la pantalla para el inicio de los enemigossalchicha
	var posicion_x = 0
	var posicion_y = 0
	
	var side = randi() % 4 + 1
	match side:
		1: #arriba
			posicion_x = randf_range(100, pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = 10
		2: #derecha
			posicion_x = pantalla_ancho
			posicion_y = randf_range(100, pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		3: #abajo
			posicion_x = randf_range(100, pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = pantalla_alto
		4: #izquierda
			posicion_x = 10
			posicion_y = randf_range(100, pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		_:
			posicion_x = 10
			posicion_y = 10
	return [posicion_x,posicion_y]

func get_closest_enemy():   # obtiene la direccion del enemigo mas cercano
	var closest_enemy = null  # si no tiene ningun enemigo
	var shortest_distance = INF  # Inicia con una distancia infinita
	var player_position = player.global_position # sposision actual del player
	
	# buscar en toda las instancias de enemigos cual es la mas cercana
	for enemy in enemies:
		if is_instance_valid(enemy):  # ← Filtra nodos eliminados
			var distance_to_enemy = player_position.distance_to(enemy.global_position)
			if distance_to_enemy < shortest_distance:
				shortest_distance = distance_to_enemy
				closest_enemy = enemy
	
	return closest_enemy  #devuelve el enemigo mas cercano
	
	

	
func shoot_at_closest_enemy(): # disparo al enemigo mas cercano
	var closest_enemy = get_closest_enemy() #obtiene la ubicacion del enemigo mas cercano
	#print("disparo")
	if closest_enemy:
		var direction = (closest_enemy.global_position - global_position).normalized()
		
		var angulo_disparo = (player.global_position - closest_enemy.global_position).angle()
		emit_signal("shoot",angulo_disparo) #envia un señal de disparo o ataque al arma y la socion del enemigo mas cercano
		

extends Node2D

#tamaño de pantalla
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo


# Player
var player = null  # instancia del player


# Entorno
var background = null

func _ready():	# Comienza el juego
	$sound_level.play()
	
	init_background()
	
	init_player() # Instanciar y añadir el jugador en el punto central 
	# asignar la señal del angulo del arma y disparo
	$player.connect("enemy_detected", $player._on_enemy_detected) 
	
	init_factory_enemy()
	
	
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
	print("personaje: ",Global.currentPlayer._display_name, " vida: ", Global.currentPlayer._health)
	if Global.currentPlayer != null:
		var p_health = Global.currentPlayer._health
		var p_speed = Global.currentPlayer._speed
		var p_armor = Global.currentPlayer._armor
		var sprite_path = Global.currentPlayer._sprite_player  # Ruta relativa al nodo Player
		
		player = PlayerFactory.load_player("res://scenes/game/player.tscn",p_health,p_speed,p_armor,sprite_path)
		player.position = Vector2(pantalla_ancho/2,pantalla_alto/2)  # Colocar al jugador en el centro
		add_child(player)  # Agrega el nodo hijo
	

func init_factory_enemy():
	await get_tree().create_timer(.2).timeout
	add_child(preload("res://scenes/game/enemy/factoy_enemy.tscn").instantiate())
		

func get_closest_enemy():   # obtiene la direccion del enemigo mas cercano
	var closest_enemy = null  # si no tiene ningun enemigo
	var shortest_distance = INF  # Inicia con una distancia infinita
	var player_position = player.global_position # sposision actual del player
	
	# buscar en toda las instancias de enemigos cual es la mas cercana
	for enemy in GlobalOleada.enemies:
		if is_instance_valid(enemy):  # ← Filtra nodos eliminados
			var distance_to_enemy = player_position.distance_to(enemy.global_position)
			if distance_to_enemy < shortest_distance:
				shortest_distance = distance_to_enemy
				closest_enemy = enemy
	
	return closest_enemy  #devuelve el enemigo mas cercano
	
	

	

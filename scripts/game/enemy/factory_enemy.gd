extends Node2D
class_name EnemyFactory

# spawn
var posicionCero = 10 # margen de posision de spawn de los enemigos en los bordes

# Enemigos
var timer_between_enemy = GlobalOleada.timer_between_enemy # .5 seg Intervalo que aparecen los enemigos
var tipo_enemigo = 1

# Diccionario con las rutas de los enemigos
var tipos_enemigos = {
	1: "res://scenes/game/enemy/enemy1.tscn",
	2: "res://scenes/game/enemy/enemy2.tscn", #seria enemigo 2
	3: "res://scenes/game/enemy/enemy3.tscn", #seria enemgio 3
	4: "res://scenes/game/enemy/enemy4.tscn",
	5: "res://scenes/game/enemy/enemy5.tscn"
}

var enemigo_iniciar = tipos_enemigos[tipo_enemigo]

func _ready() -> void:
	#await get_tree().create_timer(timer_between_enemy).timeout
	timer_add_enemy()
	
	

# Timer entre instancias de enemigos
func timer_add_enemy():
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = timer_between_enemy
	enemy_timer.one_shot = false #que sea ciclico
	add_child(enemy_timer)
	enemy_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a los enemigos
	enemy_timer.timeout.connect(init_enemy)	



# Instaciar en eenemigo correspondiente
func init_enemy ():
	var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
	var enemy = load(enemigo_iniciar).instantiate()
	enemy.position = Vector2(position[0], position[1]) # Ubica al enemigo en la X random e Y en el inicio
	GlobalOleada.enemies.append(enemy)  # Agrega el enmigo a la lista de nemigos 
	add_child(enemy)  # Agrega como hijo del main al enemigo



func enemy_starting_point(): # genera una posisiocn aleatoria en los bordes de la pantalla para el inicio de los enemigos
	var posicion_x = 0
	var posicion_y = 0
	
	var side = randi() % 4 + 1
	match side:
		1: #arriba
			posicion_x = randf_range(100, Global.pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = posicionCero
		2: #derecha
			posicion_x = Global.pantalla_ancho -posicionCero
			posicion_y = randf_range(100, Global.pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		3: #abajo
			posicion_x = randf_range(100, Global.pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
			posicion_y = Global.pantalla_alto -posicionCero
		4: #izquierda
			posicion_x = posicionCero
			posicion_y = randf_range(100, Global.pantalla_alto-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
		_:
			posicion_x = posicionCero
			posicion_y = posicionCero
	return [posicion_x,posicion_y]

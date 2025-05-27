extends Node2D
class_name EnemyFactory

# spawn
var posicionCero = 10 # margen de posision de spawn de los enemigos en los bordes

# Enemigos
var timer_between_enemy = GlobalOleada.timer_between_enemy # .5 seg Intervalo que aparecen los enemigos
var tipo_enemigo = 1

#oleada
var oleada = GlobalOleada.oleada
var dificult_oleada = oleada
var dificult_grupo = 1

var enemy2 = true
var enemy3 = true
var enemy4 = true
var enemy5 = true

# Diccionario con las rutas de los enemigos
var tipos_enemigos = {
	1: "res://scenes/game/enemy/enemy1.tscn", # Babosas
	2: "res://scenes/game/enemy/enemy2.tscn", # Lombris
	3: "res://scenes/game/enemy/enemy3.tscn", # Bicho bola
	4: "res://scenes/game/enemy/enemy4.tscn", # Saltamontes
	5: "res://scenes/game/enemy/enemy5.tscn" # Araña BOSS
}

var enemigo_iniciar = tipos_enemigos[1]

func _ready() -> void:
	#await get_tree().create_timer(timer_between_enemy).timeout
	
	deteccionDificultad()  # detecte la dificulta y genera parametro dependiendo la oleada
	
	timer_add_enemy()
	
	
func deteccionDificultad(): # desarma el valor d ela oleada en 2 parametros
	while dificult_oleada > 5:
		dificult_oleada -=5	 # busco el valor de 1-5 del grupo
		dificult_grupo +=1 # busco el nivel del grupo
	

# Timer entre instancias de enemigos
func timer_add_enemy():
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = timer_between_enemy
	enemy_timer.one_shot = false #que sea ciclico
	add_child(enemy_timer)
	enemy_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a los enemigos
	enemy_timer.timeout.connect(create_enemy)	

func create_enemy():
	if dificult_oleada > 4 and enemy5:
		enemy5=false  # Bloquea al boss para que solo se instancie una vez por oleada
		init_enemy(tipos_enemigos[5]) # elige al BOSS
	
	if dificult_oleada > 3 and enemy4:
		enemy4=false
		enemigo_iniciar = tipos_enemigos[4]  # elige la langosta
		init_enemy(enemigo_iniciar)
	
	if dificult_oleada > 2 and enemy3:
		enemy3=false
		enemigo_iniciar = tipos_enemigos[3]  # elige al bicho bola
		init_enemy(enemigo_iniciar)
	
	if dificult_oleada > 1 and enemy2:
		enemy2=false
		enemigo_iniciar = tipos_enemigos[2]  # elige al bicho bola
		init_enemy(enemigo_iniciar)
		
	if dificult_oleada > 0:
		reset_variables() # resetea todos los valores para volver a intanciar el grupo
		init_enemy(tipos_enemigos[1])  # elige a la babosa
		
		
# Instaciar en eenemigo correspondiente
func init_enemy (enemigo_iniciar):
	var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
	var enemy = load(enemigo_iniciar).instantiate()
	enemy.position = Vector2(position[0], position[1]) # Ubica al enemigo en la X random e Y en el inicio
	GlobalOleada.enemies.append(enemy)  # Agrega el enmigo a la lista de nemigos 
	add_child(enemy)  # Agrega como hijo del main al enemigo

func reset_variables(): # resetea los bichos para que se intancien ciclicos
	enemy2 = true
	enemy3 = true
	enemy4 = true

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

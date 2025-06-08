extends Node2D
class_name EnemyFactory

# spawn
var posicionCero = 100 # margen de posision de spawn de los enemigos en los bordes

# Enemigos
var timer_between_enemy = GlobalOleada.timer_between_enemy # Intervalo que aparecen los enemigos
var sprite_enemy_default = "res://assets/graphics/character_graphics/bichos/bicho" # se le agregara el numero de bicho y nivel
var enemy_count = GlobalEnemy.enemy_count  # Cantidad de enemigos para instanciar
var grup_dificult_per = GlobalEnemy.group_dificult/100 # porcentaje aumentado en el grupo d edificultad
var porcentaje_items = GlobalEnemy.porcentaje_items

#oleada
var dificult_oleada = GlobalOleada.oleada # tomo el valor d ela oleada actual
var dificult_grup = 1  # nivel inicial de los bichos
var dificult_percent = 1 # porcentaje aumentado de nivel en los bichos 1=100%
var dificult_extra = 0 # cuando dificultad de grupo supere el 4 se comienza a cambiar el valor d eextra, que modulara el sprite con color
# colores internos del sprite para oleada > 20
var red = 1
var green = 1
var blue = 1


var enemy2 = true #Lombris
var enemy3 = true #Bolita
var enemy4 = true #Langosta
var enemy5 = true #Araña


func _ready() -> void:
	#await get_tree().create_timer(timer_between_enemy).timeout
	
	deteccionDificultad()  # detecte la dificulta y genera parametro dependiendo la oleada
	
	timer_add_enemy() # Timer para agregar enemigos segun la logica del nivel
	
	
func deteccionDificultad(): # desarma el valor de la oleada en 2 parametros
	while dificult_oleada > enemy_count:
		dificult_oleada -=enemy_count	 # busco el valor de 1-5 del grupo
		dificult_grup +=1 # busco el nivel del grupo - al momento tenemos 4 grupos niveles
		dificult_percent = (grup_dificult_per * dificult_grup) + 1 # Aumenta el porcentaje de dificultad al cambiar de grupo
		if dificult_grup > 4:
			dificult_extra = dificult_grup - 4 # extraigo el extra calculado a partir d ela oleada 21
			dificult_grup = 4
	
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
		init_enemy(5) # elige al BOSS
	
	if dificult_oleada > 3 and enemy4:
		enemy4=false
		init_enemy(4) # elige la langosta
	
	if dificult_oleada > 2 and enemy3:
		enemy3=false
		init_enemy(3) # elige al bicho bola
	
	if dificult_oleada > 1 and enemy2:
		enemy2=false
		init_enemy(2) # elige a la lombriz
		
	if dificult_oleada > 0:
		reset_variables() # resetea todos los valores para volver a intanciar el grupo
		init_enemy(1)  # elige a la babosa
		
		
# Instaciar en eenemigo correspondiente
func init_enemy (enemy_type):
	var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
	var enemy_scene = GlobalEnemy.enemy_class[enemy_type] # busca la escena correspondinte al bicho seleccionado
	
	var enemy = load(enemy_scene).instantiate()  # instancia
	
	# leer parametros del bicho
	var parametros = GlobalEnemy.enemy_param[enemy_type] #obtiene los paramaetros del bicho [health, damage, velocity]
		
	# parametros de la intancia
	enemy.health = parametros[0] *  dificult_percent # carga la vida
	enemy.damage = parametros[1] *  dificult_percent # carga el daño
	enemy.veloci = parametros[2] *  dificult_percent  # carga la velocidad
	enemy.items = items() # Agrega el item por probabilidad
	# modifica el color del sprite a partir d ela oleada 21
	match dificult_extra:
		1:
			red=0.7
			blue=0.7
		2:
			red=0.7
			green=0.7
		3:
			blue=0.7
			green=0.7	
		4:
			green=0.7	
	enemy.red = red
	enemy.green = green
	enemy.blue = blue
		
	# genera la direccion del Sprite   "defecto" + tipo + nivel + numero de nivel
	enemy.sprite = sprite_enemy_default + str(enemy_type) + "_nivel" + str(dificult_grup) + ".png"
		
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

# Items que contendran los enemy y lo sueltan al morir
func items():
	var numero_aleatorio = randi() % 100 + 1  # 100 opciones
	if numero_aleatorio < porcentaje_items * .50:
		return 1 # maiz 1
	if numero_aleatorio < porcentaje_items * .70:
		return 2 # maiz 2
	if numero_aleatorio < porcentaje_items * .80:
		return 3 # maiz 3
	if numero_aleatorio < porcentaje_items * .85:
		return 4 # Power up Vida
	if numero_aleatorio < porcentaje_items * .90:
		return 5 # Power up vel
	if numero_aleatorio < porcentaje_items * .95:
		return 6 # Power up daño	
	if numero_aleatorio <= porcentaje_items:
		return 7 # Power up vel disparo	
	return 0
	

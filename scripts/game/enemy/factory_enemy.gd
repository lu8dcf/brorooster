extends Node2D
class_name EnemyFactory

# spawn
var posicionCero = 10 # margen de posision de spawn de los enemigos en los bordes


# Enemigos
#var move_enemy = 0.05  # Intervalo de tiempo para el movimiento enemigo
var timer_between_enemy = GlobalOleada.timer_between_enemy # .5 seg Intervalo que aparecen los enemigos
#var velocidad = 10


# Diccionario con las rutas de los enemigos
var enemigos = {
	1: "res://scenes/game/enemy/enemy1.tscn",
	2: "res://scenes/game/enemy/enemy2.tscn", #seria enemigo 2
	3: "res://scenes/game/enemy/enemy3.tscn", #seria enemgio 3
	4: "res://scenes/game/enemy/enemy4.tscn",
	5: "res://scenes/game/enemy/enemy5.tscn"
}

func _ready() -> void:
	await get_tree().create_timer(timer_between_enemy).timeout
	timer_add_enemy()
	pass
	
func timer_add_enemy():
	
	match (Global.stage):  # este paso lo vamos a manejar por oleadas
		1:iniciarEnemigo(enemigos[1])
		2:iniciarEnemigo(sorteoEnemigo(1,Global.stage))
		3:iniciarEnemigo(sorteoEnemigo(1,Global.stage))
		_:iniciarEnemigo(enemigos[1])
pass
	
	
func sorteoEnemigo(min, max):
	var randomEnemy = randi_range(min, max)
	return enemigos.get(randomEnemy, enemigos[1])  # random de la lista, si no, el enemgio 1
	
func iniciarEnemigo (enemigo: String):
	var position = enemy_starting_point() # posicion inicial del enemigo en algun extremo
	var enemy = load(enemigo).instantiate()
	enemy.position = Vector2(position[0], position[1]) # Ubica al enemigo en la X random e Y en el inicio
	GlobalEnemy.enemies.append(enemy)
	add_child(enemy)  # Agrega como hijo del main al enemigo
pass


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

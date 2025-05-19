extends Node

# Propiedades del  player seleccionado 

	# Cantidad de vida 
var health = 100:
	get:
		return health
	set(value):
		health = value
		emit_signal("lives_changed", health)
	# velocidad de movimiento
var speed = 200:
	get:
		return speed
	set(value):
		speed = value
				
	#Armadura  valor de 0,1 a 1 - 1 sin armadura
var armor = 1:
	get:
		return armor
	set(value):
		armor = value
					
var sprite_player = "res://assets/graphics/character_graphics/gallo.png":
	get:
		return sprite_player
	set(value):
		sprite_player = value
		
		
var mouse_sens = 0.5

var speed_main = 200
var deadzone_radius_main = 20 

# Propiedades de la partida actual
var score = 0
var enemigos_eliminados = 0

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = 1160
var pantalla_alto = 764

# Arma
var angle = 0

#Stage
var stage = 1

signal lives_changed(new_value)
func decrease_lives(amount = 1):
	health = max(0, health - amount)
	
func get_lives() -> int:
	return health

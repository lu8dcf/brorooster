extends Node

# Propiedades del  player seleccionado 

	# Cantidad de vida 
var _health = 100:
	get:
		return _health
	set(value):
		# Validación 
		if value < 0:
			value = 0
		elif value > 100:
			value = 100
		emit_signal("lives_changed", _health)
	# velocidad de movimiento
var _speed = 200:
	get:
		return _speed
	set(value):
		if value < 0:
			value = 0
		elif value > 400:
			value = 400
		_speed = value		
	#Armadura  valor de 0,1 a 1 - 1 sin armadura
var _armor = 1:
	get:
		return _armor
	set(value):
		if value < 0:
			value = 0.1
		elif value > 1:
			value = 1
		_armor = value
					
var _sprite_player = "res://assets/graphics/character_graphics/gallos/gallo1.png":
	get:
		return _sprite_player
	set(value):
		_sprite_player = value
		# aca hay que proteger por carga fallida
		
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
	_health = max(0, _health - amount)
	
func get_lives() -> int:
	return _health

extends Node
# Propiedades del  player 
var lives = 3:
	set(value):
		lives = value
		emit_signal("lives_changed", lives)
		
var speed_player = 1000
var mouse_sens = 0.5

var speed_main = 200
var deadzone_radius_main = 20 

# Propiedades de la partida actual
var score = 0
var enemigos_eliminados = 0

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = 896
var pantalla_alto = 504

# Arma
var angle = 0

#Stage
var stage = 1

signal lives_changed(new_value)
func decrease_lives(amount = 1):
	lives = max(0, lives - amount)

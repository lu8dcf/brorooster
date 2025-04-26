extends Node


# Propiedades del  player 
var lives = 3
var speed_player = 500
var mouse_sens = 0.5

var speed_main = 200
var deadzone_radius_main = 20 

# Propiedades de la partida actual
var score = 0
var enemigos_eliminados = 0

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = 1280
var pantalla_alto = 720

#Para actualizar el juego
var stage = 1;

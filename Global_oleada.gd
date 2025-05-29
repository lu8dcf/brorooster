extends Node

signal wave_changed(new_value)

# General 


var maiz = 0


# Enemigos
var enemies = []
var timer_between_enemy = 2


# Oleada

var oleada = 4




#Factory enemy
var timer_spawn = 1  # tiempo por defecto entre spawn d eenemigos

# debe ser lista tipo fifo
# -- Oleada
#tiempo de oleada
var tiempo_oleada = 25.0 # tiempo por defecto que dura una oleada
var tiempo_seleccion = 5.0 # tiempo que esta el menu se compra y armado para la prox oleada

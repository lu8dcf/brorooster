extends Node

signal wave_changed(new_value)

# General 


var maiz = 0


# Enemigos
var enemies = []
var timer_between_enemy = 1


# Oleada

var oleada = 1




#Factory enemy
var timer_spawn = 1  # tiempo por defecto entre spawn d eenemigos

# debe ser lista tipo fifo
# -- Oleada
#tiempo de oleada
var tiempo_oleada = 20 # tiempo por defecto que dura una oleada

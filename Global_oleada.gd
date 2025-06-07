extends Node

signal wave_changed(new_value)
signal time_changed(new_value)

# General 
var maiz = 0


# Enemigos
var enemies = []
var timer_between_enemy = 2


# Oleada
var oleada = 5


#Factory enemy
var timer_spawn = 1  # tiempo por defecto entre spawn d eenemigos

# -- Oleada
#tiempo de oleada
var tiempo_oleada = 25 # tiempo por defecto que dura una oleada
#tiempo de meni de seleccion
var tiempo_seleccion = 5 # tiempo que esta el menu se compra y armado para la prox oleada
var tiempo_restante_oleada = 0



func _on_wave_number_changed(new_number: int):
	# Propaga el cambio de salud del personaje como señal global
	wave_changed.emit(new_number)


func _on_time_wave_changed(new_time: int):
	# Propaga el cambio de salud del personaje como señal global
	time_changed.emit(new_time)

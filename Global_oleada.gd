extends Node

signal wave_changed(new_value)
signal time_changed(new_value)
signal time_hud_changed(new_value)

# General 
var maiz = 0


# Enemigos
var enemies = [] # se guardan todas las intancias enemigas
var timer_between_enemy = 1
var experiencia = 0

func eliminar_todos_enemigos():
	for enemy in enemies:  # rastrea entre todos los enemigos
		if is_instance_valid(enemy):  # Verifica que la instancia aún existe
			enemy.queue_free()  # Programa la eliminación para el próximo frame
	enemies.clear()  # Limpia el array

# Oleada
var oleada = 1


#Factory enemy
#var timer_spawn = 1  # tiempo por defecto entre spawn de enemigos

# -- Oleada
#tiempo de oleada
var tiempo_oleada = 25 # tiempo por defecto que dura una oleada
var tiempo_restante_oleada = 0
#tiempo de menu de seleccion
var tiempo_seleccion = 15 # tiempo que esta el menu se compra y armado para la prox oleada
var tiempo_restante_seleccion = 0

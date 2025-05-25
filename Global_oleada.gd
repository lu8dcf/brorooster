extends Node

# General 

var oleada = 0
var maiz = 0


# Enemigos
var enemies = []



# Oleada

# debe ser lista tipo fifo
# -- Oleada
#tiempo de oleada
var tiempo_oleada = 20

# hacer los tipos de bichos 1,2,3,4 5  6,7,8,9,10   11 - 15   16 -20    1y2  3y4 5   6y7 8y9 10
# necesitamos 1 bicho mas  langosta Salta

#tipo de dato
#[ vida , daño , velocidad , sprite de cambio de color ] 
var bichos ={
	1: [10,5,20," sprite babosa"],
	2: [15,6,22,"sprite lombris"],
}


# -- valores enemigos
# tipo de enemigo  1-4
# multiplicador de daño
# multiplicador de vida enemigo
# velocidad 
# tiempo span por oleadas cambia mas adelante
# tipo de sprite

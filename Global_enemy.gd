extends Node2D
	
class_name Enemy
	
# base de datos de las caracteristicas enemigas
# aca se pueden modificar las caracteristicas de los bichos

var enemy_count = 5 # Cantidad de enemigos disponibles
var group_dificult = 0.2 # porcentaje que se agrega al subir d enivel el bicho en todos sus paramentros

#tipo de dato
#[ health , damage , velocidad  ] 

var enemy_param = {
	1:[20, 10 , 1 ], # "Babosa"
	2:[30, 10 , 1.5], # "Lombriz"
	3:[40, 10 , 1.8 ], # "Bolita"
	4:[50, 10 , 2 ], #"Langosta"
	5:[200, 50 , 2.1 ]# "Araña"
}

# Diccionario con las rutas de los enemigos
var enemy_class = {
	1: "res://scenes/game/enemy/enemy1.tscn", # Babosas
	2: "res://scenes/game/enemy/enemy2.tscn", # Lombris
	3: "res://scenes/game/enemy/enemy3.tscn", # Bicho bola
	4: "res://scenes/game/enemy/enemy4.tscn", # Saltamontes
	5: "res://scenes/game/enemy/enemy5.tscn" # Araña BOSS
}

extends Node2D
	
class_name Enemy
	
# base de datos de las caracteristicas enemigas
# aca se pueden modificar las caracteristicas de los bichos

var enemy_count = 5 # Cantidad de enemigos disponibles
var group_dificult = 20 # en % porcentaje que se agrega al subir d enivel el bicho en todos sus paramentros
var porcentaje_items = 90 # en % porcentaje de probabilidad de items
var margen_spawn= 100 # margen de spawn con referencia a la pantallla donde inician los enemigos
#tipo de dato
#[ health , damage , velocidad  ] 

var enemy_param = {
	1:[5.0, 5.0 , 0.4 ], # "Babosa"
	2:[10.0, 5.0 , 0.5], # "Lombriz"
	3:[10.0, 5.0 , 0.6 ], # "Bolita"
	4:[10.0, 5.0 , 0.7 ], #"Langosta"
	5:[200.0, 50.0 , 2.0 ],# "Araña"
	6:[5.0, 10.0 , 0.5 ] # arañas pequeñas
}

# Diccionario con las rutas de los enemigos
var enemy_class = {
	1: "res://scenes/game/enemy/enemy1.tscn", # Babosas
	2: "res://scenes/game/enemy/enemy2.tscn", # Lombris
	3: "res://scenes/game/enemy/enemy3.tscn", # Bicho bola
	4: "res://scenes/game/enemy/enemy4.tscn", # Saltamontes
	5: "res://scenes/game/enemy/enemy5.tscn", # Araña BOSS
	6: "res://scenes/game/enemy/enemy6.tscn" # Araña BOSS
}

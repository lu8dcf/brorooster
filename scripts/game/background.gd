extends Area2D


@onready var Fondo = $Fondo  # Es el nodo del fondo

var nuevo_fondo = preload("res://assets/graphics/menu_graphics/backgrounddefault.png")  # fondo por defecto

var spawner_worms_scene = preload("res://scenes/game/enemy/spawner_worms.tscn")



func _on_main_game_stage() -> void:
	Fondo.texture = nuevo_fondo  # # Asignpass # Replace with function body.

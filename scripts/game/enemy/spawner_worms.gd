extends Node2D

class_name SpawnerWorms

var enemigoASpawnear = preload("res://scenes/game/enemy/enemy_2.tscn")
@onready var timer:Timer = $TimeToSpawn
@export var player: CharacterBody2D

func _ready() -> void:
	pass
	

func _on_time_to_spawn_timeout() -> void:
	var enemigoWorm = enemigoASpawnear.instantiate()
	enemigoWorm.position = self.position
	enemigoWorm.SetTarget(player)
	self.get_parent().add_child(enemigoWorm)
	pass # Replace with function body.

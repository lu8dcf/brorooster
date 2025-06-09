extends Node2D

@onready var  animation = $AnimationPlayer

func _ready() -> void:
	$AudioStreamPlayer2D.stream = load("res://assets/sound/menus_effects/muerte.mp3")
	$AudioStreamPlayer2D.play()
	animation.play("Muerte")
	

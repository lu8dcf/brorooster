extends Control


@onready var  animation = $AnimationPlayer
func _ready() -> void:
	# Cargar y reproducir el sonido
	var sound = load("res://assets/sound/menus_effects/muerte.mp3")

	animation.play("Creditos")

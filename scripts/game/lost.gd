extends Node2D

@onready var  animation = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D
func _ready() -> void:
	# Cargar y reproducir el sonido
	var sound = load("res://assets/sound/menus_effects/muerte.mp3")
	if sound:
		audio.stream = sound
		audio.play()
	animation.play("Muerte")
	

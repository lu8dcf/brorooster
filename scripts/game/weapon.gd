extends Node2D
@onready var animation_player = $AnimationPlayer
#var current_weapon: Node2D = null

#var target_position: Vector2 = Vector2.ZERO

#@export var player: CharacterBody2D  # Asigna el jugador en el inspector

#var offset = Vector2(20, 0)  # Ajusta según la posición deseada
# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀




	
	
	#muestra el retroceso 
func play_retroceso():
	animation_player.play("retroceso")	

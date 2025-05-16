extends Node2D

var current_weapon: Node2D = null

var target_position: Vector2 = Vector2.ZERO

@export var player: CharacterBody2D  # Asigna el jugador en el inspector
var offset = Vector2(20, 0)  # Ajusta según la posición deseada
# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀

func _process(delta):
	if player:
		global_position = player.global_position + offset
	# Calcular la dirección hacia el objetivo
	var direction: Vector2 = (target_position - global_position).normalized()
	
	# Calcular el ángulo deseado (en radianes)
	var target_angle: float = direction.angle()
	
	
	
	

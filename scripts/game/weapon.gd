extends Area2D
var target_position: Vector2 = Vector2(393.4185, 295.3448)

func _process(delta):
	var direction = target_position - global_position
	var target_angle = direction.angle()
	
	# Rotación gradual hacia el objetivo
	rotation = lerp_angle(rotation, target_angle, 5 * delta) # Ajusta la velocidad con "5 * delta"

# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀

extends Area2D
var direction: Vector2 = Vector2(0, 0) # direccion a donde debe apuntar el arma,inicial

func _process(delta):
	var apunta = direction - global_position
	var target_angle = apunta.angle()
	
	# Rotación gradual hacia el objetivo
	rotation = lerp_angle(rotation, target_angle, 5 * delta) # Ajusta la velocidad con "5 * delta"

# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀


func _on_main_game_shoot(direction: Vector2) -> void:
	print (direction)
	pass # Replace with function body.

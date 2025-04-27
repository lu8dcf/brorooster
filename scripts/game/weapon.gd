extends Area2D
var direction: Vector2  # direccion a donde debe apuntar el arma,inicial



func _process(delta):

	var target_angle = direction.angle()
		# Rotación gradual hacia el objetivo
	rotation = lerp_angle(rotation, target_angle , 5 *delta) # Ajustar la velocidad de rotacion "5 * delta"
	print (direction)
	

	
# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀

func _on_main_game_shoot(enemy_position: Vector2,self_position: Vector2):
	
	direction = enemy_position - self_position  # Direccion donde debe apuntar el arma
	
	# Obtener el ángulo hacia la dirección calculada
	#var target_angle = direction.angle()
	# Establecer la rotación del nodo hacia el ángulo objetivo
	
	

	

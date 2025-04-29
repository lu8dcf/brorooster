extends Node2D


var current_weapon: Node2D = null
var apunta

var target_position: Vector2 = Vector2.ZERO
@export var rotation_speed: float = 5.0  # Ajusta la velocidad de rotación

@export var player: CharacterBody2D  # Asigna el jugador en el inspector
var offset = Vector2(20, 0)  # Ajusta según la posición deseada
# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀

func _on_main_game_shoot(enemy_position: Vector2,self_position: Vector2) -> void:
	target_position = enemy_position
	#direction = enemy_position - self_position  # Direccion donde debe apuntar el arma
	# Obtener el ángulo hacia la dirección calculada
	#target_angle = direction.angle()
	
	
func _process(delta):
	if player:
		global_position = player.global_position + offset
	# Calcular la dirección hacia el objetivo
	var direction: Vector2 = (target_position - global_position).normalized()
	
	# Calcular el ángulo deseado (en radianes)
	var target_angle: float = direction.angle()
	
	# Interpolar suavemente la rotación actual hacia el objetivo
	#rotation = lerp_angle(rotation, target_angle , rotation_speed * delta)
	
	print("Ángulo interpolado: ", rotation )
	# (Opcional) Asegurarse de que el sprite apunte correctamente
	if direction.x < 0:
		$Sprite2D.flip_v = true   # Voltear si el objetivo está a la izquierda
	else:
		$Sprite2D.flip_v = false
	#apunta = direction - global_position
	#var target_angle = apunta.angle()
		
	# Rotación gradual hacia el objetivo
	#rotation = lerp_angle(rotation, target_angle, 5 * delta) # Ajustar la velocidad de rotacion "5 * delta"

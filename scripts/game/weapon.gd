extends Area2D
var direction: Vector2 = Vector2(0, 0) # direccion a donde debe apuntar el arma,inicial
var apunta
@onready var Weapon = $Weapon  # Es el nodo del arma

func _process(delta):
	apunta = direction - global_position
	var target_angle = apunta.angle()
	#print ("----------------")
	#print ("apunta1 ",apunta)
	
	#print ("direction1 ",direction)
	#print ("Global1 ",global_position)
	# Rotación gradual hacia el objetivo
	rotation = lerp_angle(rotation, target_angle, 5 * delta) # Ajustar la velocidad de rotacion "5 * delta"

# girará sobre su eje central y apuntará hacia la posición (x, y) que le indiques. Si necesitas ajustar más detalles como velocidad, interpolaciones, o interacción, ¡puedo ayudarte con eso! 🚀

func _on_main_game_shoot(direction: Vector2) -> void:
	direction=direction
	print("---------------")
	print ("apunta ",apunta)
	print ("direction ",direction)
	print ("Global ",global_position)
	pass # Replace with function body.
	

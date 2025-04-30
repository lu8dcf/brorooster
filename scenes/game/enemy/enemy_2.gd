extends CharacterBody2D

var movimiento = Vector2()

var velocidad = 0.5

func _physics_process(delta: float) -> void:
	move_and_collide(movimiento)
	if Global.lives >= 1:
		set_vector(get_node("/root/main_game/player").global_position - global_position)
	else:
		movimiento = Vector2.ZERO
		
func set_vector(vector):
	movimiento = vector.normalized() * velocidad
	pass
	

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("player"):
		
		print ("toco")
	pass # Replace with function body.

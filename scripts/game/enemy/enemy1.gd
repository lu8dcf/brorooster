class_name Babosa
extends EnemigoBase


# Movimiento exclusivo de la Babosa
func _physics_process(_delta):
	move_and_collide(movimiento)
	set_vector(get_node("/root/main_game/player").global_position - global_position)
	

func set_vector(vector):
	movimiento = vector.normalized() * veloci
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")

extends CharacterBody2D

var movimiento  = Vector2()

var velocidad = 1

func _ready():
	#$AnimationPlayer.play("tornado")
	pass

func _physics_process(_delta): 
	move_and_collide(movimiento)
	set_vector(get_node("../player").global_position - global_position)		
				
	
	
func set_vector(vector):
	movimiento = vector.normalized() * velocidad
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")
	pass
	
	 


func _on_area_2d_body_entered(body):
	
	if body.is_in_group("player"):
		
		print ("toco")
	pass # Replace with function body.

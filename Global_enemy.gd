extends CharacterBody2D
	
class_name Enemy
	
var stats: Dictionary= {"nombre"= "", "vida"= 0, "alcance"= 0, "dano"= 0, "velocidad"= 0}
var movimiento = Vector2()
var velocidad = 0.5



# Enemigos
var enemies = []  # Almacenará las instancias de enemigos


var timer_between_enemy = .5 # .5 seg Intervalo que aparecen los enemigos



func _ready() -> void:
	SetUp()
	pass
	
func A_physics_process(_delta): 
	move_and_collide(movimiento)
	if Global.lives >= 1:
		set_vector(get_node("/root/main_game/player").global_position - global_position)
	else:
		movimiento = Vector2.ZERO
	
	
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
	
func SetUp():
	pass
	
func Ataque():
	
	pass
	
func RecibirDano():
	
	pass
	
func Morir():
	queue_free()
	pass

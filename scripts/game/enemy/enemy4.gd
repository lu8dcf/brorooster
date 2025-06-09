extends EnemigoBase
class_name Langosta


# Lógica de salto
var salto_timer := Timer.new()
var salto_fuerza := 10.0
var desaceleracion := 0.9

func _ready():
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)  # Dejado igual que tu código original

	# Configurar el timer de salto
	salto_timer.wait_time = 0.8
	salto_timer.one_shot = false
	salto_timer.connect("timeout", Callable(self, "_on_salto_timer_timeout"))
	add_child(salto_timer)
	salto_timer.start()

func _physics_process(_delta): 
	move_and_collide(movimiento)
	movimiento *= desaceleracion  # Frena el movimiento tras el salto

func _on_salto_timer_timeout():
	if Global.currentPlayer._health >= 1:
		var direccion = get_node("/root/main_game/player").global_position - global_position
		movimiento = direccion.normalized() * salto_fuerza
		if movimiento.x > 0:
			$AnimationPlayer.play("right")
		else:
			$AnimationPlayer.play("left")
	else:
		movimiento = Vector2.ZERO

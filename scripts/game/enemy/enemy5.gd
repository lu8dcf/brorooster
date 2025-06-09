extends EnemigoBase
class_name Arania


# Variables para movimiento en espiral
var angulo := 0.0
var radio := 200.0  # Distancia inicial del jugador
var velocidad_angular := 2.0  # Qué tan rápido gira

func _ready():
	update_health(health)
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)

func _physics_process(delta):
	move_and_collide(movimiento)
	if Global.currentPlayer._health >= 1:
		var player_pos = get_node("/root/main_game/player").global_position
		set_spiral_vector(player_pos, delta)
	else:
		movimiento = Vector2.ZERO

func set_spiral_vector(target_pos: Vector2, delta: float):
	# Reducimos el radio gradualmente para acercarnos al jugador
	radio = max(radio - 20 * delta, 20)  # nunca menor a 20

	# Actualizamos el ángulo para girar
	angulo += velocidad_angular * delta

	# Calculamos una posición alrededor del jugador
	var offset = Vector2(cos(angulo), sin(angulo)) * radio
	var destino = target_pos + offset

	# Movemos hacia ese destino
	var direccion = (destino - global_position).normalized()
	movimiento = direccion * veloci

	# Animación
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")



func take_damage(amount: float):
	health -= amount
	update_health(health)
	if health <= 0:
		die()



func update_health(value: float):
	$HealthBar/ProgressBar.value = value

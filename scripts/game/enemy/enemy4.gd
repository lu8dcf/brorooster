extends CharacterBody2D
class_name Langosta

# Parámetros obtenidos de la instancia -----------------------
var health : float  # Vida del bicho
var damage : float  # daño que causa al player
var veloci : float  # velocidad de movimiento
var sprite : String  # Sprite correspondiente al nivel
var red : int        # color del Sprite - a partir de la oleada 21
var green : int
var blue : int
# --------------------------------------------------------------
var movimiento = Vector2()

# Lógica de salto
var salto_timer := Timer.new()
var salto_fuerza := 10.0
var desaceleracion := 0.9

func _ready():
	update_health(health)
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

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("toco")

func take_damage(amount: float):
	health -= amount
	update_health(health)
	if health <= 0:
		die()

func die():
	queue_free()

func update_health(value: float):
	$HealthBar/ProgressBar.value = value

func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)

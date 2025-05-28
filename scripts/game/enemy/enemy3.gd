extends CharacterBody2D
class_name Bolita

var health : float  # Vida del bicho
var damage : float  # daño que causa al player
var veloci : float  # velocidad de movimiento normal
var sprite : String  # Sprite correspondiente al nivel
var red : int
var green : int
var blue : int

var movimiento = Vector2()

var velocidad_actual : float
var timer_acelerar := Timer.new()

func _ready():
	update_health(health)
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)

	velocidad_actual = veloci * 0.2  # velocidad inicial lenta

	timer_acelerar.wait_time = 2.0  # después de 2 segundos acelera
	timer_acelerar.one_shot = true
	timer_acelerar.connect("timeout", Callable(self, "_on_timer_acelerar_timeout"))
	add_child(timer_acelerar)
	timer_acelerar.start()

func _physics_process(_delta):
	move_and_collide(movimiento)
	if Global.currentPlayer._health >= 1:
		set_vector(get_node("/root/main_game/player").global_position - global_position)
	else:
		movimiento = Vector2.ZERO

func set_vector(vector):
	movimiento = vector.normalized() * velocidad_actual
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")

func _on_timer_acelerar_timeout():
	velocidad_actual = 2.0  # velocidad rápida fija

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

extends CharacterBody2D

var health : float
var damage : float
var veloci : float
var sprite : String
var red : int
var green : int
var blue : int

var movimiento = Vector2()

var tiene_maiz := false
#var maiz_scene := preload("res://objetos/maiz.tscn")  # Ruta del prefab de maíz (ajustala si es distinta)

func _ready():
	update_health(health)
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)

	tiene_maiz = randf() < 0.3  # 30% de probabilidad de tener maíz (podés ajustar)
	

func _physics_process(_delta):
	move_and_collide(movimiento)
	if Global.currentPlayer._health >= 1:
		set_vector(get_node("/root/main_game/player").global_position - global_position)
	else:
		movimiento = Vector2.ZERO

func set_vector(vector):
	movimiento = vector.normalized() * veloci
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("toco")

func take_damage(amount: float):
	health -= amount
	update_health(health)
	if health <= 0:
		die()

func die():
	#if tiene_maiz:
		#var maiz = maize_scene.instantiate()
		#get_parent().add_child(maiz)
		#maiz.global_position = global_position
	queue_free()

func update_health(value: float):
	$HealthBar/ProgressBar.value = value

func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)

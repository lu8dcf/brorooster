extends CharacterBody2D

# Parametros obtenidos de la instancia -----------------------
var health : float  # Vida de la babosa
var damage : float  # daño que causa la babosa al player
var veloci : float # velocidad de movimiento d ela babosa
var sprite : String  # Sprite correspondiente al nivel

# --------------------------------------------------------------
var movimiento  = Vector2()
# Referencia al sprite para poder modificarlo mas adelante ne la seleccion del player
#@onready var sprite = $Sprite2D 

func _ready():
	update_health(health)
	$Sprite2D.texture = load(sprite)	# Cambia la textura de player dependiedno la seleccion
	print ("h ",health," d ",damage," v ",veloci)
	
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
	pass
	
	 
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print ("toco")
	

func take_damage(amount: float):
	health -= amount
	# $AnimationPlayer.play("hit")
	#print("Enemigo golpeado! Vida restante: ", health)
	update_health(health)
	if health <= 0:
		die()

func die():
	# $AnimationPlayer.play("death")
	# await $AnimationPlayer.animation_finished
	# Soltar maiz si tiene
	queue_free()
	
func update_health(value: float):   #barra de vida del enemigo
	$HealthBar/ProgressBar.value = value

func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)  # Método en el enemigo de daño

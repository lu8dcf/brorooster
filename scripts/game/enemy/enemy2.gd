class_name Lombriz
extends EnemigoBase

var can_move := false  # Variable para controlar cuando puede moverse

func _ready():
	$DelayTimer.wait_time = 1.5  # Configurar tiempo desde código
	salida()
	cpu_particles = get_node("CPUParticles2D")  # o $CPUParticles2D
	
func _physics_process(_delta): 
	if can_move:  # Solo mover si puede moverse
		move_and_collide(movimiento)
		set_vector(get_node("/root/main_game/player").global_position - global_position)
		
	
func set_vector(vector):
	if not can_move:  # Si no puede moverse, salir de la función
		return
	movimiento = vector.normalized() * veloci
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")

func salida():
	recibe_danio=false
	$AnimationPlayer.play("SPAWN")
	$DelayTimer.start()  # Inicia el temporizador de 2.3 segundos
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SPAWN":
		can_move = true  # Permitir movimiento después de SPAWN
	

func _on_delay_timer_timeout() -> void:
	can_move = true  # Permite el movimiento después de 2.3 segundos
	recibe_danio=true # permite recibir daño

# daño a player
func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)

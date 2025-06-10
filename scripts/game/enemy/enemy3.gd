extends EnemigoBase
class_name Bolita



var velocidad_actual : float
var timer_acelerar := Timer.new()

func _ready():
	velocidad_actual = veloci * 0.2  # velocidad inicial lenta
	cpu_particles = get_node("CPUParticles2D")  # o $CPUParticles2D

	timer_acelerar.wait_time = 2.0  # después de 2 segundos acelera
	timer_acelerar.one_shot = true
	timer_acelerar.connect("timeout", Callable(self, "_on_timer_acelerar_timeout"))
	add_child(timer_acelerar)
	timer_acelerar.start()

func _physics_process(_delta):
	move_and_collide(movimiento)
	set_vector(get_node("/root/main_game/player").global_position - global_position)
	

func set_vector(vector):
	movimiento = vector.normalized() * velocidad_actual
	if movimiento.x > 0:
		$AnimationPlayer.play("right")
	else:
		$AnimationPlayer.play("left")

func _on_timer_acelerar_timeout():
	velocidad_actual = 2.0  # velocidad rápida fija

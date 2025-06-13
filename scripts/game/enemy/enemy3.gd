extends EnemigoBase
class_name Bolita

var salto_timer := Timer.new()
var etapa=1

func _ready():
	$Sprite2D.texture = load(sprite)
	$Sprite2D.modulate = Color(red, green, blue)  # Dejado igual que tu código original
	cpu_particles = get_node("CPUParticles2D")  # o $CPUParticles2D
	# Configurar el timer de salto
	salto_timer.wait_time = 2.1
	salto_timer.one_shot = false
	salto_timer.connect("timeout", Callable(self, "_on_salto_timer_timeout"))
	add_child(salto_timer)
	salto_timer.start()

func _physics_process(_delta): 
	move_and_collide(movimiento)
#	

func _on_salto_timer_timeout():
	
	match etapa:
		1:
			recibe_danio=true
			var direccion = get_node("/root/main_game/player").global_position - global_position
			movimiento = direccion.normalized() * veloci
			$AnimationPlayer.play("anda")
			if movimiento.x > 0:
				$Sprite2D.flip_h = false
			else:
				$Sprite2D.flip_h = true
			
		2:
			recibe_danio=false
			var direccion = get_node("/root/main_game/player").global_position - global_position
			# Elige aleatoriamente entre perpendicular izquierda o derecha
			var sentido = 1 if randf() > 0.5 else -1
			var movimiento = direccion.normalized().rotated(deg_to_rad(90 * sentido)) * veloci
			
			$AnimationPlayer.play("rueda")
			if movimiento.x > 0:
				$Sprite2D.flip_h = false
			else:
				$Sprite2D.flip_h = true
			etapa = 0
	etapa += 1

# daño a player
func _on_area_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		
